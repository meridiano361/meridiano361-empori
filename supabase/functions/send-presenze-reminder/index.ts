import webpush from "npm:web-push@3";
import { createClient } from "jsr:@supabase/supabase-js@2";
import {
  italyNow,
  loadRules,
  resolveOperatorIds,
  getPushSubs,
  sendPushBatch,
  type VapidConfig,
} from "../_shared/notifiche_lib.ts";

const CORS = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

const MESI = [
  "gennaio","febbraio","marzo","aprile","maggio","giugno",
  "luglio","agosto","settembre","ottobre","novembre","dicembre",
];

type Sub = {
  operatore_nome: string | null;
  operatore_id: string | null;
  endpoint: string;
  subscription: object;
};

function pad(n: number) { return String(n).padStart(2, "0"); }

// lastDayOfMonth: month è 1-based
function lastDayOfMonth(year: number, month: number): number {
  return new Date(year, month, 0).getDate();
}

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") return new Response(null, { headers: CORS });

  const VAPID_PUB  = Deno.env.get("VAPID_PUBLIC_KEY")  ?? "";
  const VAPID_PRIV = Deno.env.get("VAPID_PRIVATE_KEY") ?? "";
  const VAPID_SUB  = Deno.env.get("VAPID_SUBJECT")     ?? "mailto:info@meridiano361.it";

  const vapid: VapidConfig = { pub: VAPID_PUB, priv: VAPID_PRIV, subject: VAPID_SUB };

  const urlObj = new URL(req.url);
  const dryrun = urlObj.searchParams.get("dryrun") === "1";
  const force  = dryrun || urlObj.searchParams.get("force") === "1";

  const { year, month, day, hour } = italyNow();

  if (!force && hour !== 9) {
    return new Response(
      JSON.stringify({ skipped: true, reason: `ora italiana ${hour}:xx, non sono le 9:00` }),
      { headers: { "Content-Type": "application/json", ...CORS } },
    );
  }

  const lastDay = lastDayOfMonth(year, month);
  if (!force && day !== lastDay - 1) {
    return new Response(
      JSON.stringify({
        skipped: true,
        reason: `oggi è il ${day}/${month}/${year}, il penultimo giorno è il ${lastDay - 1}`,
      }),
      { headers: { "Content-Type": "application/json", ...CORS } },
    );
  }

  const db = createClient(
    Deno.env.get("SUPABASE_URL")!,
    Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
  );

  const log: string[] = [];
  const nomeMese = MESI[month - 1];
  const dateStr  = `${year}-${pad(month)}-${pad(day)}`;

  // Carica regole
  const rules = await loadRules(db, "presenza");
  log.push(`Regole trovate: ${rules.length}`);

  if (rules.length > 0) {
    // Usa le regole configurate
    const results = {
      date: dateStr, mese: nomeMese,
      sent: 0, failed: 0, emails: 0, dryrun, log,
    };

    if (!VAPID_PUB || !VAPID_PRIV) {
      return new Response(
        JSON.stringify({ error: "VAPID keys non configurate" }),
        { status: 500, headers: { "Content-Type": "application/json", ...CORS } },
      );
    }

    for (const rule of rules) {
      const titolo  = rule.nome ?? "Meridiano 361";
      const msgBody = rule.descrizione ?? `Ricordati di compilare il foglio delle presenze di ${nomeMese} entro domani.`;

      const opIds = await resolveOperatorIds(db, rule.destinatari ?? "Tutti gli operatori");
      log.push(`[${rule.id}] operatori: ${opIds.length}`);

      if (!opIds.length) continue;

      const subs = await getPushSubs(db, opIds);
      log.push(`[${rule.id}] subs: ${subs.length}`);

      if (!subs.length) continue;

      if (!dryrun) {
        const payload = {
          title: titolo,
          body: msgBody,
          url: "/",
          tag: `m361-presenze-${year}-${pad(month)}`,
        };
        const r = await sendPushBatch(db, subs, payload, vapid, log);
        results.sent   += r.sent;
        results.failed += r.failed;
      } else {
        results.sent += subs.length;
      }
    }

    return new Response(JSON.stringify(results, null, 2), {
      headers: { "Content-Type": "application/json", ...CORS },
    });
  }

  // ── FALLBACK: comportamento originale ────────────────────────────────────────
  log.push("Nessuna regola attiva — uso comportamento originale");

  if (!VAPID_PUB || !VAPID_PRIV) {
    return new Response(
      JSON.stringify({ error: "VAPID keys non configurate" }),
      { status: 500, headers: { "Content-Type": "application/json", ...CORS } },
    );
  }

  const msgBody = `Ricordati di compilare il foglio delle presenze di ${nomeMese} entro domani.`;

  const [{ data: operatoriRaw }, { data: subsRaw }] = await Promise.all([
    db.from("operatori")
      .select("id, nome")
      .eq("attivo", true)
      .in("tipo_contratto", ["indeterminato", "determinato"]),
    db.from("push_subscriptions").select("operatore_nome, operatore_id, endpoint, subscription"),
  ]);

  const operatori = operatoriRaw ?? [];
  const subs      = (subsRaw ?? []) as Sub[];

  const nomeToId = new Map<string, string>();
  for (const op of operatori) {
    if (op.nome) nomeToId.set(op.nome.toLowerCase().trim(), op.id);
  }

  const idToSubs   = new Map<string, Sub[]>();
  const nomeToSubs = new Map<string, Sub[]>();
  for (const sub of subs) {
    if (sub.operatore_id) {
      if (!idToSubs.has(sub.operatore_id)) idToSubs.set(sub.operatore_id, []);
      idToSubs.get(sub.operatore_id)!.push(sub);
    }
    const key = (sub.operatore_nome ?? "").toLowerCase().trim();
    if (key) {
      if (!nomeToSubs.has(key)) nomeToSubs.set(key, []);
      nomeToSubs.get(key)!.push(sub);
    }
  }

  webpush.setVapidDetails(VAPID_SUB, VAPID_PUB, VAPID_PRIV);

  const payload = JSON.stringify({
    title: "Meridiano 361",
    body:  msgBody,
    url:   "/",
    tag:   `m361-presenze-${year}-${pad(month)}`,
  });

  const results = {
    date: dateStr, mese: nomeMese,
    operatori_dipendenti: operatori.length,
    sent: 0, skipped: 0, failed: 0, dryrun,
    log,
  };

  for (const op of operatori) {
    const nomeLower = (op.nome ?? "").toLowerCase().trim();

    const seenEp = new Set<string>();
    const opSubs: Sub[] = [];
    for (const s of [...(idToSubs.get(op.id) ?? []), ...(nomeToSubs.get(nomeLower) ?? [])]) {
      if (!seenEp.has(s.endpoint)) { seenEp.add(s.endpoint); opSubs.push(s); }
    }

    if (!opSubs.length) {
      results.skipped++;
      continue;
    }

    if (dryrun) {
      results.sent++;
      continue;
    }

    const sendResults = await Promise.allSettled(
      opSubs.map(sub =>
        webpush.sendNotification(sub.subscription as webpush.PushSubscription, payload, {
          urgency: "normal",
          TTL: 86400,
        })
      ),
    );

    const anyOk = sendResults.some(r => r.status === "fulfilled");

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
    } else {
      results.failed++;
    }
  }

  return new Response(JSON.stringify(results, null, 2), {
    headers: { "Content-Type": "application/json", ...CORS },
  });
});
