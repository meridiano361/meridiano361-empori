import webpush from "npm:web-push@3";
import { createClient } from "jsr:@supabase/supabase-js@2";
import {
  loadRules,
  sendEmailViaResend,
} from "../_shared/notifiche_lib.ts";

const CORS = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

type OpEntry  = { nome?: string; rimosso?: boolean };
type TurnoRec = { emporio: string; turno: string; operatori: OpEntry[] | null; assenze?: Record<string, unknown> | null };
type Shift    = { turno: string; emporio: string };
type Sub      = { operatore_nome: string; operatore_id: string | null; endpoint: string; subscription: object; last_push_at: string | null };
type LogEntry = {
  nome: string;
  motivo_skip?: string;
  turni?: Array<{ fascia: string; colleghi: string[] }>;
  body?: string;
};

function primoNome(nome: string): string {
  return nome.trim().split(/\s+/)[0];
}

const MASCHILI_IN_A = new Set(["luca", "andrea", "nicola", "mattia", "elia", "battista", "enea"]);
function soloSola(nomeCompleto: string): string {
  const first = nomeCompleto.trim().split(/\s+/)[0].toLowerCase();
  if (MASCHILI_IN_A.has(first)) return "solo";
  return first.endsWith("a") ? "sola" : "solo";
}

function joinNomi(nomi: string[]): string {
  if (nomi.length === 0) return "";
  if (nomi.length === 1) return primoNome(nomi[0]);
  const ini = nomi.slice(0, -1).map(primoNome).join(", ");
  return `${ini} e ${primoNome(nomi.at(-1)!)}`;
}

function altriInTurno(rec: TurnoRec, escludi: string): string[] {
  const escludiKey = escludi.toLowerCase().trim();
  return (rec.operatori ?? [])
    .filter(op => op.nome && !op.rimosso && op.nome.toLowerCase().trim() !== escludiKey)
    .map(op => op.nome as string);
}

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") return new Response(null, { headers: CORS });

  const VAPID_PUB  = Deno.env.get("VAPID_PUBLIC_KEY")  ?? "";
  const VAPID_PRIV = Deno.env.get("VAPID_PRIVATE_KEY") ?? "";
  const VAPID_SUB  = Deno.env.get("VAPID_SUBJECT")     ?? "mailto:info@meridiano361.it";

  const now = new Date();
  const romanHour = parseInt(
    now.toLocaleString("en-US", { timeZone: "Europe/Rome", hour: "numeric", hour12: false }),
    10,
  );
  const todayMidnightUtc = new Date(Date.UTC(now.getUTCFullYear(), now.getUTCMonth(), now.getUTCDate()));

  const urlObj    = new URL(req.url);
  const dryrun    = urlObj.searchParams.get("dryrun") === "1";
  const force     = dryrun || urlObj.searchParams.get("force") === "1";
  const reset     = urlObj.searchParams.get("reset") === "1";
  const soloOp    = (urlObj.searchParams.get("operatore") ?? "").toLowerCase().trim();
  const customMsg = urlObj.searchParams.get("msg") ?? "";

  if (!force && romanHour !== 8) {
    return new Response(
      JSON.stringify({ skipped: true, reason: `ora italiana: ${romanHour}h (non le 8:00)` }),
      { headers: { "Content-Type": "application/json", ...CORS } },
    );
  }

  const db = createClient(
    Deno.env.get("SUPABASE_URL")!,
    Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
  );

  const log: string[] = [];

  // ── Step 1: Carica la regola 'turno' ─────────────────────────────────────────
  const rules = await loadRules(db, "turno");
  const rule  = rules[0] ?? null;

  if (!rule) {
    // Nessuna regola attiva: skip tutto
    return new Response(
      JSON.stringify({ skipped: true, reason: "nessuna regola turno attiva" }),
      { headers: { "Content-Type": "application/json", ...CORS } },
    );
  }

  const canale = rule.canale ?? "push";
  // Titolo dalla regola (es. "Il tuo turno oggi"), fallback al precedente
  const titleTemplate = rule.nome ?? "M361 — Il tuo turno oggi";
  log.push(`Regola: ${rule.id}, canale: ${canale}, titolo: ${titleTemplate}`);

  const dateFmt = new Intl.DateTimeFormat("it-IT", {
    timeZone: "Europe/Rome",
    year: "numeric", month: "numeric", day: "numeric",
  });
  const parts = dateFmt.formatToParts(now);
  const year  = parseInt(parts.find(p => p.type === "year")!.value,  10);
  const month = parseInt(parts.find(p => p.type === "month")!.value, 10);
  const day   = parseInt(parts.find(p => p.type === "day")!.value,   10);

  const DEFAULT_HOURS = {
    mat_open: "09:15", mat_close: "13:00",
    pom_open: "15:00", pom_close: "19:00",
  };

  const [
    { data: orariRows },
    { data: rawTurni, error: turniErr },
    { data: prefsDisab },
    { data: tuttiOp },
    { data: subsRaw },
  ] = await Promise.all([
    db.from("turni_orari").select("emporio, orari"),
    db.from("turni").select("emporio, turno, operatori, assenze")
      .eq("anno", year).eq("mese", month).eq("giorno", day).eq("aperto", true),
    db.from("operatore_notif_prefs").select("operatore_id").eq("tipo", "turni").eq("abilitato", false),
    db.from("operatori").select("id, nome"),
    db.from("push_subscriptions").select("operatore_nome, operatore_id, endpoint, subscription, last_push_at"),
  ]);

  if (turniErr) {
    return new Response(
      JSON.stringify({ error: "DB error turni: " + turniErr.message }),
      { status: 500, headers: { "Content-Type": "application/json", ...CORS } },
    );
  }

  const emporiOrari: Record<string, typeof DEFAULT_HOURS> = {};
  for (const row of orariRows ?? []) {
    emporiOrari[row.emporio] = { ...DEFAULT_HOURS, ...(row.orari ?? {}) };
  }

  const turniOggi: TurnoRec[] = (rawTurni ?? []).map(t => ({
    emporio:   t.emporio,
    turno:     t.turno,
    operatori: (t.operatori ?? []) as OpEntry[],
    assenze:   (t.assenze ?? null) as Record<string, unknown> | null,
  }));

  const assentiOggi = new Set<string>();
  for (const t of turniOggi) {
    for (const key of Object.keys(t.assenze ?? {})) {
      const nome = key.split("|").slice(4).join("|");
      if (nome) assentiOggi.add(nome.toLowerCase().trim());
    }
  }

  if (!turniOggi.length) {
    return new Response(
      JSON.stringify({ skipped: true, reason: "nessun turno aperto oggi", date: `${year}-${month}-${day}` }),
      { headers: { "Content-Type": "application/json", ...CORS } },
    );
  }

  const operatoriMap = new Map<string, Shift[]>();
  for (const t of turniOggi) {
    for (const op of t.operatori ?? []) {
      if (!op.nome || op.rimosso) continue;
      if (!operatoriMap.has(op.nome)) operatoriMap.set(op.nome, []);
      operatoriMap.get(op.nome)!.push({ turno: t.turno, emporio: t.emporio });
    }
  }

  const disabledIds = new Set((prefsDisab ?? []).map(p => p.operatore_id as string));

  const nomeToId  = new Map<string, string>();
  const idToNome  = new Map<string, string>();
  for (const op of tuttiOp ?? []) {
    if (op.nome) {
      nomeToId.set(op.nome.toLowerCase().trim(), op.id);
      idToNome.set(op.id, op.nome);
    }
  }

  const nomeToSubs = new Map<string, Sub[]>();
  const idToSubs   = new Map<string, Sub[]>();
  for (const sub of (subsRaw ?? []) as Sub[]) {
    const key = (sub.operatore_nome ?? "").toLowerCase().trim();
    if (key) {
      if (!nomeToSubs.has(key)) nomeToSubs.set(key, []);
      nomeToSubs.get(key)!.push(sub);
    }
    if (sub.operatore_id) {
      if (!idToSubs.has(sub.operatore_id)) idToSubs.set(sub.operatore_id, []);
      idToSubs.get(sub.operatore_id)!.push(sub);
    }
  }

  const sendPush = canale === "push" || canale === "entrambi";
  const sendEmail = canale === "email" || canale === "entrambi";

  if (sendPush && (!VAPID_PUB || !VAPID_PRIV)) {
    return new Response(
      JSON.stringify({ error: "VAPID keys non configurate" }),
      { status: 500, headers: { "Content-Type": "application/json", ...CORS } },
    );
  }

  if (sendPush) webpush.setVapidDetails(VAPID_SUB, VAPID_PUB, VAPID_PRIV);

  const dateStr = `${year}-${String(month).padStart(2,"0")}-${String(day).padStart(2,"0")}`;

  const results = {
    date:               dateStr,
    operatori_in_turno: operatoriMap.size,
    sent: 0, skipped: 0, failed: 0,
    errors: [] as string[],
    log:   [] as LogEntry[],
  };

  type SendTask = { sub: Sub; payload: string; nome: string; email?: string; emailSubject?: string; emailBody?: string };
  const sendTasks: SendTask[] = [];

  for (const [nome, shifts] of operatoriMap.entries()) {
    if (soloOp && !nome.toLowerCase().includes(soloOp)) {
      results.log.push({ nome, motivo_skip: `escluso da filtro ?operatore=${soloOp}` });
      continue;
    }

    if (assentiOggi.has(nome.toLowerCase().trim())) {
      results.skipped++;
      results.log.push({ nome, motivo_skip: "assenza registrata oggi" });
      continue;
    }

    let opId = nomeToId.get(nome.toLowerCase().trim());
    if (!opId) {
      const nomeKey = nome.toLowerCase().trim();
      for (const [canonKey, id] of nomeToId.entries()) {
        if (canonKey.includes(nomeKey) || nomeKey.includes(canonKey)) {
          opId = id; break;
        }
      }
    }

    if (opId && disabledIds.has(opId)) {
      results.skipped++;
      results.log.push({ nome, motivo_skip: "notifiche turni disabilitate" });
      continue;
    }

    const sorted = [...shifts].sort((a, b) => {
      if (a.turno === "mattina" && b.turno !== "mattina") return -1;
      if (a.turno !== "mattina" && b.turno === "mattina") return  1;
      return 0;
    });

    const fasceTesto: string[] = [];
    const fasceDiag: Array<{ fascia: string; colleghi: string[] }> = [];
    const seenFasce = new Set<string>();

    for (const s of sorted) {
      const uniqKey = `${s.emporio}:${s.turno}`;
      if (seenFasce.has(uniqKey)) continue;
      seenFasce.add(uniqKey);

      const orari = emporiOrari[s.emporio] ?? DEFAULT_HOURS;
      const orarioLabel = s.turno === "mattina"
        ? `dalle ${orari.mat_open} alle ${orari.mat_close}`
        : `dalle ${orari.pom_open} alle ${orari.pom_close}`;

      const rec  = turniOggi.find(t => t.emporio === s.emporio && t.turno === s.turno);
      const cols = rec ? altriInTurno(rec, nome) : [];
      fasceTesto.push(cols.length > 0 ? `${orarioLabel} con ${joinNomi(cols)}` : `${orarioLabel} da ${soloSola(nome)}`);
      fasceDiag.push({ fascia: orarioLabel, colleghi: cols });
    }

    if (!fasceTesto.length) {
      results.skipped++;
      results.log.push({ nome, motivo_skip: "nessuna fascia valida", turni: fasceDiag });
      continue;
    }

    const body = customMsg || `Oggi sei in turno ${
      fasceTesto.length === 1
        ? fasceTesto[0]
        : fasceTesto.slice(0, -1).join(", ") + " e " + fasceTesto.at(-1)
    }`;

    // Raccogli subscription (deduplicato per endpoint)
    const seenEndpoints = new Set<string>();
    const operatoreSubs: Sub[] = [];

    if (opId) {
      for (const s of idToSubs.get(opId) ?? []) {
        if (!seenEndpoints.has(s.endpoint)) { seenEndpoints.add(s.endpoint); operatoreSubs.push(s); }
      }
    }
    for (const s of nomeToSubs.get(nome.toLowerCase().trim()) ?? []) {
      if (!seenEndpoints.has(s.endpoint)) { seenEndpoints.add(s.endpoint); operatoreSubs.push(s); }
    }
    if (opId) {
      const nomeCanon = (idToNome.get(opId) ?? "").toLowerCase().trim();
      if (nomeCanon && nomeCanon !== nome.toLowerCase().trim()) {
        for (const s of nomeToSubs.get(nomeCanon) ?? []) {
          if (!seenEndpoints.has(s.endpoint)) { seenEndpoints.add(s.endpoint); operatoreSubs.push(s); }
        }
      }
    }

    results.log.push({ nome, turni: fasceDiag, body });

    if (sendPush) {
      if (!operatoreSubs.length) {
        results.skipped++;
        results.log.find(l => l.nome === nome)!.motivo_skip = "nessun token push registrato";
        continue;
      }

      const payload = JSON.stringify({
        title: titleTemplate,
        body,
        url: "/pages/turni/turni.html",
        tag: `m361-turno-${dateStr}`,
      });

      for (const sub of operatoreSubs) {
        if (!reset && sub.last_push_at && new Date(sub.last_push_at) >= todayMidnightUtc) {
          const logEntry = results.log.find(l => l.nome === nome);
          if (logEntry) logEntry.motivo_skip = (logEntry.motivo_skip ?? "") + "[già inviato oggi] ";
          results.skipped++;
          continue;
        }
        sendTasks.push({ sub, payload, nome });
      }
    }

    // Email per-operatore (se canale include email)
    if (sendEmail && opId) {
      const { data: opData } = await db.from("operatori").select("email").eq("id", opId).single();
      if (opData?.email) {
        sendTasks.push({
          sub: {} as Sub,
          payload: "",
          nome,
          email: opData.email,
          emailSubject: titleTemplate,
          emailBody: body,
        });
      }
    }
  }

  // ── Invia tutte le notifiche ──────────────────────────────────────────────────
  if (!dryrun && sendTasks.length > 0) {
    const pushTasks  = sendTasks.filter(t => t.payload && !t.email);
    const emailTasks = sendTasks.filter(t => t.email);

    // Push
    if (pushTasks.length) {
      const sendResults = await Promise.allSettled(
        pushTasks.map(async ({ sub, payload }) => {
          await webpush.sendNotification(
            sub.subscription as webpush.PushSubscription,
            payload,
            { urgency: "high", TTL: 43200 },
          );
          await db.from("push_subscriptions")
            .update({ last_push_at: new Date().toISOString(), last_push_ok: true })
            .eq("endpoint", sub.endpoint);
        })
      );

      for (let i = 0; i < sendResults.length; i++) {
        const r = sendResults[i];
        if (r.status === "fulfilled") {
          results.sent++;
        } else {
          const e      = r.reason as { statusCode?: number; message?: string };
          const status = e?.statusCode;
          const msg    = e?.message ?? String(r.reason);
          if (status === 404 || status === 410) {
            await db.from("push_subscriptions").delete().eq("endpoint", pushTasks[i].sub.endpoint);
          } else {
            results.failed++;
            await db.from("push_subscriptions")
              .update({ last_push_at: new Date().toISOString(), last_push_ok: false })
              .eq("endpoint", pushTasks[i].sub.endpoint);
            results.errors.push(`${pushTasks[i].nome}: ${msg.slice(0, 120)}`);
          }
        }
      }
    }

    // Email
    for (const task of emailTasks) {
      await sendEmailViaResend(
        task.email!,
        task.emailSubject!,
        `<p>${task.emailBody}</p>`,
      );
      results.sent++;
    }
  } else if (dryrun) {
    results.sent = sendTasks.length;
  }

  return new Response(JSON.stringify({ ...results, dryrun }, null, 2), {
    headers: { "Content-Type": "application/json", ...CORS },
  });
});
