import webpush from "npm:web-push@3";
import { createClient } from "jsr:@supabase/supabase-js@2";

const CORS = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

type Sub = {
  operatore_nome: string | null;
  operatore_id: string | null;
  endpoint: string;
  subscription: object;
};

type OpEntry = { nome?: string; rimosso?: boolean };

// Orari di default per fascia (stesso valore di DEFAULTHOURS in turni.html)
const DEFAULT_SHIFT: Record<string, { start: string; end: string }> = {
  mattina:    { start: "09:15", end: "13:00" },
  pomeriggio: { start: "15:00", end: "19:00" },
  sera:       { start: "20:00", end: "22:30" },
};

function shiftTimes(fascia: string, orari: Record<string, string>): { start: string; end: string } {
  const def = DEFAULT_SHIFT[fascia] ?? { start: "09:00", end: "18:00" };
  if (fascia === "mattina")    return { start: orari.mat_open ?? def.start, end: orari.mat_close ?? def.end };
  if (fascia === "pomeriggio") return { start: orari.pom_open ?? def.start, end: orari.pom_close ?? def.end };
  return def; // sera: hardcoded 20:00–22:30, non salvato in turni_orari
}

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") return new Response(null, { headers: CORS });

  const VAPID_PUB  = Deno.env.get("VAPID_PUBLIC_KEY")  ?? "";
  const VAPID_PRIV = Deno.env.get("VAPID_PRIVATE_KEY") ?? "";
  const VAPID_SUB  = Deno.env.get("VAPID_SUBJECT")     ?? "mailto:info@meridiano361.it";

  const urlObj   = new URL(req.url);
  const dryrun   = urlObj.searchParams.get("dryrun") === "1";
  const force    = dryrun || urlObj.searchParams.get("force") === "1";
  const forceTime = urlObj.searchParams.get("time"); // es. "16:30" per test

  // Ora italiana corrente
  const now = new Date();
  const italyParts = new Intl.DateTimeFormat("it-IT", {
    timeZone: "Europe/Rome",
    year: "numeric", month: "numeric", day: "numeric",
    hour: "2-digit", minute: "2-digit", hour12: false,
  }).formatToParts(now);

  const year  = parseInt(italyParts.find(p => p.type === "year")!.value,   10);
  const month = parseInt(italyParts.find(p => p.type === "month")!.value,  10);
  const day   = parseInt(italyParts.find(p => p.type === "day")!.value,    10);
  const hourI = parseInt(italyParts.find(p => p.type === "hour")!.value,   10);
  const minI  = parseInt(italyParts.find(p => p.type === "minute")!.value, 10);

  const currentTimeStr = forceTime ?? `${String(hourI).padStart(2, "0")}:${String(minI).padStart(2, "0")}`;
  const todayStr = `${year}-${String(month).padStart(2, "0")}-${String(day).padStart(2, "0")}`;

  const db = createClient(
    Deno.env.get("SUPABASE_URL")!,
    Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
  );

  // Carica tutti i dati in parallelo
  const [
    { data: turniRows, error: turniErr },
    { data: orariRows },
    { data: operatoriRows },
    { data: prefsDisab },
    { data: subsRaw },
  ] = await Promise.all([
    db.from("turni").select("emporio, turno, operatori")
      .eq("anno", year).eq("mese", month).eq("giorno", day).eq("aperto", true),
    db.from("turni_orari").select("emporio, orari"),
    db.from("operatori").select("id, nome"),
    db.from("operatore_notif_prefs").select("operatore_id").eq("tipo", "turni").eq("abilitato", false),
    db.from("push_subscriptions").select("operatore_nome, operatore_id, endpoint, subscription"),
  ]);

  if (turniErr) {
    return new Response(
      JSON.stringify({ error: "DB error turni: " + turniErr.message }),
      { status: 500, headers: { "Content-Type": "application/json", ...CORS } },
    );
  }

  // Mappa emporio → orari
  const emporiOrari: Record<string, Record<string, string>> = {};
  for (const row of orariRows ?? []) {
    emporiOrari[row.emporio] = (row.orari as Record<string, string>) ?? {};
  }

  // Determina chi va notificato in questo minuto
  type Task = {
    nome: string;
    nomeLower: string;
    emporio: string;
    fascia: string;
    tipo: "entrata" | "uscita";
    body: string;
  };
  const tasks: Task[] = [];

  for (const t of turniRows ?? []) {
    const orari = emporiOrari[t.emporio] ?? {};
    const { start, end } = shiftTimes(t.turno, orari);

    let tipo: "entrata" | "uscita" | null = null;
    if (currentTimeStr === start) tipo = "entrata";
    else if (currentTimeStr === end) tipo = "uscita";

    if (!tipo) {
      if (!force) continue;
      tipo = "entrata"; // fallback per test ?force=1
    }

    const fasciaLabel = t.turno === "mattina" ? "mattino" : t.turno === "pomeriggio" ? "pomeriggio" : "serata";
    const body = tipo === "entrata"
      ? `Turno ${fasciaLabel} iniziato. Ricorda di timbrare l'entrata.`
      : `Turno ${fasciaLabel} terminato. Ricorda di timbrare l'uscita.`;

    for (const op of (t.operatori ?? []) as OpEntry[]) {
      if (!op.nome || op.rimosso) continue;
      tasks.push({ nome: op.nome, nomeLower: op.nome.toLowerCase().trim(), emporio: t.emporio, fascia: t.turno, tipo, body });
    }
  }

  if (!tasks.length) {
    return new Response(
      JSON.stringify({ skipped: true, currentTime: currentTimeStr, date: todayStr, reason: "nessun turno inizia o finisce in questo minuto" }),
      { headers: { "Content-Type": "application/json", ...CORS } },
    );
  }

  // Lookup maps operatori
  const nomeToId = new Map<string, string>();
  const idToNome = new Map<string, string>();
  for (const op of operatoriRows ?? []) {
    if (op.nome) {
      nomeToId.set(op.nome.toLowerCase().trim(), op.id);
      idToNome.set(op.id, op.nome);
    }
  }

  const disabledIds = new Set((prefsDisab ?? []).map(p => p.operatore_id as string));

  // Lookup subscriptions
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

  if (!VAPID_PUB || !VAPID_PRIV) {
    return new Response(
      JSON.stringify({ error: "VAPID keys non configurate" }),
      { status: 500, headers: { "Content-Type": "application/json", ...CORS } },
    );
  }
  webpush.setVapidDetails(VAPID_SUB, VAPID_PUB, VAPID_PRIV);

  const results = {
    date: todayStr, currentTime: currentTimeStr,
    sent: 0, skipped: 0, failed: 0, dryrun,
    log: [] as object[],
  };

  for (const task of tasks) {
    const opId = nomeToId.get(task.nomeLower);

    // Rispetta preferenza "turni" disabilitata
    if (opId && disabledIds.has(opId)) {
      results.skipped++;
      results.log.push({ nome: task.nome, motivo_skip: "notifiche turni disabilitate" });
      continue;
    }

    // Deduplicazione: controlla se già inviato oggi per questa fascia+tipo
    if (!dryrun && opId) {
      const { data: logRow } = await db.from("push_timbra_log")
        .select("id").eq("operatore_id", opId).eq("data", todayStr)
        .eq("fascia", task.fascia).eq("tipo", task.tipo)
        .maybeSingle();
      if (logRow) {
        results.skipped++;
        results.log.push({ nome: task.nome, motivo_skip: "già inviato oggi" });
        continue;
      }
    }

    // Raccogli subscription (dedup endpoint)
    const seenEp = new Set<string>();
    const opSubs: Sub[] = [];
    for (const s of [...(idToSubs.get(opId ?? "") ?? []), ...(nomeToSubs.get(task.nomeLower) ?? [])]) {
      if (!seenEp.has(s.endpoint)) { seenEp.add(s.endpoint); opSubs.push(s); }
    }

    if (!opSubs.length) {
      results.skipped++;
      results.log.push({ nome: task.nome, motivo_skip: "nessun token push", fascia: task.fascia, tipo: task.tipo });
      continue;
    }

    const payload = JSON.stringify({
      title: "Meridiano 361",
      body: task.body,
      url: "/pages/turni/turni.html",
      tag: `m361-timbra-${todayStr}-${task.fascia}-${task.tipo}`,
    });

    results.log.push({ nome: task.nome, fascia: task.fascia, tipo: task.tipo, body: task.body });

    if (!dryrun) {
      const sendResults = await Promise.allSettled(
        opSubs.map(sub =>
          webpush.sendNotification(sub.subscription as webpush.PushSubscription, payload, { urgency: "high", TTL: 300 })
        ),
      );

      const anyOk = sendResults.some(r => r.status === "fulfilled");
      const anyFail = sendResults.filter(r => r.status === "rejected");

      // Rimuovi token scaduti
      for (let i = 0; i < sendResults.length; i++) {
        const r = sendResults[i];
        if (r.status === "rejected") {
          const e = r.reason as { statusCode?: number };
          if (e?.statusCode === 404 || e?.statusCode === 410) {
            await db.from("push_subscriptions").delete().eq("endpoint", opSubs[i].endpoint);
          }
        }
      }

      if (anyOk) {
        results.sent++;
        if (opId) {
          await db.from("push_timbra_log").insert({
            operatore_id: opId,
            data: todayStr,
            fascia: task.fascia,
            tipo: task.tipo,
            emporio: task.emporio,
          });
        }
      } else {
        results.failed++;
        results.log.at(-1)!["motivo_skip"] = `invio fallito: ${anyFail.length} dispositivi`;
      }
    } else {
      results.sent++;
    }
  }

  return new Response(JSON.stringify(results, null, 2), {
    headers: { "Content-Type": "application/json", ...CORS },
  });
});
