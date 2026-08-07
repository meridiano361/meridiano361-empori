import webpush from "npm:web-push@3";
import { createClient } from "jsr:@supabase/supabase-js@2";

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

function italyNow(): { year: number; month: number; day: number; hour: number } {
  const now = new Date();
  const p = new Intl.DateTimeFormat("it-IT", {
    timeZone: "Europe/Rome",
    year: "numeric", month: "numeric", day: "numeric",
    hour: "2-digit", minute: "2-digit", hour12: false,
  }).formatToParts(now);
  return {
    year:  parseInt(p.find(x => x.type === "year")!.value,  10),
    month: parseInt(p.find(x => x.type === "month")!.value, 10),
    day:   parseInt(p.find(x => x.type === "day")!.value,   10),
    hour:  parseInt(p.find(x => x.type === "hour")!.value,  10),
  };
}

// lastDayOfMonth: month è 1-based → new Date(year, month, 0) dà l'ultimo giorno del mese
function lastDayOfMonth(year: number, month: number): number {
  return new Date(year, month, 0).getDate();
}

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") return new Response(null, { headers: CORS });

  const urlObj = new URL(req.url);
  const dryrun = urlObj.searchParams.get("dryrun") === "1";
  const force  = dryrun || urlObj.searchParams.get("force") === "1";

  const VAPID_PUB  = Deno.env.get("VAPID_PUBLIC_KEY")  ?? "";
  const VAPID_PRIV = Deno.env.get("VAPID_PRIVATE_KEY") ?? "";
  const VAPID_SUB  = Deno.env.get("VAPID_SUBJECT")     ?? "mailto:info@meridiano361.it";

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

  if (!VAPID_PUB || !VAPID_PRIV) {
    return new Response(
      JSON.stringify({ error: "VAPID keys non configurate" }),
      { status: 500, headers: { "Content-Type": "application/json", ...CORS } },
    );
  }

  const nomeMese = MESI[month - 1];
  const msgBody  = `Ricordati di compilare il foglio delle presenze di ${nomeMese} entro domani.`;
  const dateStr  = `${year}-${pad(month)}-${pad(day)}`;

  const db = createClient(
    Deno.env.get("SUPABASE_URL")!,
    Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
  );

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
    log: [] as object[],
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
      results.log.push({ nome: op.nome, motivo_skip: "nessun token push" });
      continue;
    }

    if (dryrun) {
      results.sent++;
      results.log.push({ nome: op.nome, body: msgBody });
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
      results.log.push({ nome: op.nome, body: msgBody });
    } else {
      results.failed++;
      results.log.push({ nome: op.nome, motivo_skip: "invio push fallito" });
    }
  }

  return new Response(JSON.stringify(results, null, 2), {
    headers: { "Content-Type": "application/json", ...CORS },
  });
});
