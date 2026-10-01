import webpush from "npm:web-push@3";
import { createClient } from "jsr:@supabase/supabase-js@2";

const CORS = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

const DESTINATARI = ["Emilio Mazzolari", "Chiara Monteverdi"];

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") return new Response(null, { headers: CORS });

  const VAPID_PUB  = Deno.env.get("VAPID_PUBLIC_KEY")  ?? "";
  const VAPID_PRIV = Deno.env.get("VAPID_PRIVATE_KEY") ?? "";
  const VAPID_SUB  = Deno.env.get("VAPID_SUBJECT")     ?? "mailto:info@meridiano361.it";

  const now = new Date();
  const romanHour = parseInt(
    now.toLocaleString("en-US", { timeZone: "Europe/Rome", hour: "numeric", hour12: false }), 10,
  );

  const urlObj  = new URL(req.url);
  const dryrun  = urlObj.searchParams.get("dryrun") === "1";
  const force   = dryrun || urlObj.searchParams.get("force") === "1";

  if (!force && romanHour !== 9) {
    return new Response(
      JSON.stringify({ skipped: true, reason: `ora italiana: ${romanHour}h (non le 9:00)` }),
      { headers: { "Content-Type": "application/json", ...CORS } },
    );
  }

  const db = createClient(
    Deno.env.get("SUPABASE_URL")!,
    Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
  );

  // Data di oggi in fuso Italy
  const dateFmt = new Intl.DateTimeFormat("it-IT", {
    timeZone: "Europe/Rome", year: "numeric", month: "numeric", day: "numeric",
  });
  const parts = dateFmt.formatToParts(now);
  const day   = parseInt(parts.find(p => p.type === "day")!.value,   10);
  const month = parseInt(parts.find(p => p.type === "month")!.value, 10);

  // Clienti che compiono gli anni oggi
  const { data: clientiBirthday, error: bdErr } = await db
    .from("clienti")
    .select("id, nome, cognome, data_nascita")
    .not("data_nascita", "is", null);

  if (bdErr) {
    return new Response(JSON.stringify({ error: bdErr.message }), { status: 500, headers: { "Content-Type": "application/json", ...CORS } });
  }

  const oggiCompleanni = (clientiBirthday ?? []).filter(c => {
    const d = new Date(c.data_nascita);
    return d.getDate() === day && (d.getMonth() + 1) === month;
  });

  if (!oggiCompleanni.length) {
    return new Response(
      JSON.stringify({ skipped: true, reason: "nessun compleanno oggi", date: `${day}/${month}` }),
      { headers: { "Content-Type": "application/json", ...CORS } },
    );
  }

  // Recupera tipo tessera per ogni cliente
  const clienteIds = oggiCompleanni.map(c => c.id);
  const { data: tessereRows } = await db
    .from("tessere")
    .select("cliente_id, tipo")
    .in("cliente_id", clienteIds);

  const tipoMap = new Map<number, string>(
    (tessereRows ?? []).map(t => [t.cliente_id as number, t.tipo as string])
  );

  // Recupera subscriptions dei destinatari
  const { data: subsRaw } = await db
    .from("push_subscriptions")
    .select("operatore_nome, endpoint, subscription")
    .in("operatore_nome", DESTINATARI);

  const subs = subsRaw ?? [];

  if (!subs.length) {
    return new Response(
      JSON.stringify({ skipped: true, reason: "nessuna subscription per i destinatari" }),
      { headers: { "Content-Type": "application/json", ...CORS } },
    );
  }

  if (!VAPID_PUB || !VAPID_PRIV) {
    return new Response(JSON.stringify({ error: "VAPID keys mancanti" }), { status: 500, headers: { "Content-Type": "application/json", ...CORS } });
  }
  webpush.setVapidDetails(VAPID_SUB, VAPID_PUB, VAPID_PRIV);

  const results: { sent: number; failed: number; errors: string[]; compleanni: string[] } = {
    sent: 0, failed: 0, errors: [], compleanni: [],
  };

  for (const c of oggiCompleanni) {
    const tipo = tipoMap.get(c.id) ?? "standard";
    const nomeCompleto = `${c.cognome ?? ""} ${c.nome}`.trim();
    results.compleanni.push(nomeCompleto);

    let body = `Compleanno di ${nomeCompleto} oggi!`;
    if (tipo === "ambassador") body += " ★ Ambassador — ricorda il 10% di sconto nel mese del compleanno.";

    const payload = JSON.stringify({
      title: "M361 — Compleanno cliente",
      body,
      url: "/pages/tessere/index.html",
      tag: `m361-bday-${c.id}-${day}-${month}`,
    });

    if (!dryrun) {
      const sends = await Promise.allSettled(
        subs.map(sub =>
          webpush.sendNotification(sub.subscription as webpush.PushSubscription, payload, { urgency: "normal", TTL: 86400 })
        )
      );
      sends.forEach((r, i) => {
        if (r.status === "fulfilled") {
          results.sent++;
        } else {
          const e = r.reason as { statusCode?: number; message?: string };
          if (e?.statusCode === 404 || e?.statusCode === 410) {
            db.from("push_subscriptions").delete().eq("endpoint", subs[i].endpoint);
          } else {
            results.failed++;
            results.errors.push(`${subs[i].operatore_nome}: ${e?.message?.slice(0,80)}`);
          }
        }
      });
    } else {
      results.sent += subs.length;
    }
  }

  return new Response(JSON.stringify({ ...results, dryrun, date: `${day}/${month}` }, null, 2), {
    headers: { "Content-Type": "application/json", ...CORS },
  });
});
