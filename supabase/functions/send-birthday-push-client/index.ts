import webpush from "npm:web-push@3";
import { createClient } from "jsr:@supabase/supabase-js@2";
import { italyNow } from "../_shared/notifiche_lib.ts";

const CORS = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") return new Response(null, { headers: CORS });

  const VAPID_PUB  = Deno.env.get("VAPID_PUBLIC_KEY")  ?? "";
  const VAPID_PRIV = Deno.env.get("VAPID_PRIVATE_KEY") ?? "";
  const VAPID_SUB  = Deno.env.get("VAPID_SUBJECT")     ?? "mailto:info@meridiano361.it";

  const urlObj = new URL(req.url);
  const dryrun = urlObj.searchParams.get("dryrun") === "1";
  const force  = dryrun || urlObj.searchParams.get("force") === "1";

  const { hour, day, month, year } = italyNow();

  if (!force && hour !== 9) {
    return new Response(
      JSON.stringify({ skipped: true, reason: `ora italiana: ${hour}h (esegue solo alle 9:00)` }),
      { headers: { "Content-Type": "application/json", ...CORS } },
    );
  }

  if (!VAPID_PUB || !VAPID_PRIV) {
    return new Response(JSON.stringify({ error: "VAPID keys mancanti" }), {
      status: 500, headers: { "Content-Type": "application/json", ...CORS },
    });
  }

  const db = createClient(
    Deno.env.get("SUPABASE_URL")!,
    Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
  );

  webpush.setVapidDetails(VAPID_SUB, VAPID_PUB, VAPID_PRIV);
  const log: string[] = [];

  // Tessere digitali attive con cliente che compie gli anni oggi
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  const { data: tessere, error: tErr } = await db
    .from("tessere")
    .select("id, slug, tipo, clienti!inner(id, nome, cognome, data_nascita)")
    .eq("attiva", true)
    .eq("ha_carta_digitale", true)
    .not("clienti.data_nascita", "is", null);

  if (tErr) {
    return new Response(JSON.stringify({ error: tErr.message }), {
      status: 500, headers: { "Content-Type": "application/json", ...CORS },
    });
  }

  // Filtra solo i compleanni di oggi
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  const oggi = (tessere ?? []).filter((t: any) => {
    const bd = new Date(t.clienti.data_nascita);
    return bd.getDate() === day && (bd.getMonth() + 1) === month;
  });

  log.push(`Tessere digitali con compleanno oggi (${day}/${month}): ${oggi.length}`);

  if (!oggi.length) {
    return new Response(
      JSON.stringify({ skipped: true, reason: "nessun compleanno oggi", date: `${day}/${month}`, log }),
      { headers: { "Content-Type": "application/json", ...CORS } },
    );
  }

  const results = { sent: 0, failed: 0, skipped_already: 0, dryrun, log };

  for (const t of oggi) {
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    const c = (t as any).clienti;
    const tesseraId = String(t.id);
    const clienteId = c.id;
    const nomeCliente = c.nome || c.cognome || "Cliente";
    const isAmb = t.tipo === "ambassador";

    // Controlla se già inviato quest'anno
    const { data: existing } = await db
      .from("birthday_push_log")
      .select("id")
      .eq("cliente_id", clienteId)
      .eq("anno", year)
      .maybeSingle();

    if (existing) {
      log.push(`${nomeCliente}: già inviato nel ${year}, skip`);
      results.skipped_already++;
      continue;
    }

    // Recupera subscriptions
    const { data: subs } = await db
      .from("tessera_push_subscriptions")
      .select("subscription, endpoint")
      .eq("tessera_id", tesseraId);

    const nSubs = (subs ?? []).length;
    log.push(`${nomeCliente}: ${nSubs} subscription(s)`);

    if (!nSubs) {
      // Registra ugualmente che non aveva subscription
      if (!dryrun) {
        await db.from("birthday_push_log").upsert({
          cliente_id: clienteId, tessera_id: tesseraId, anno: year,
          n_subscriptions: 0, n_inviate: 0, n_errori: 0, esito: "no_subscription",
        }, { onConflict: "cliente_id,anno" });
      }
      continue;
    }

    // Costruisci payload
    const cardUrl = t.slug
      ? `/tessera/${t.slug}`
      : `/pages/tessere/carta.html?id=${tesseraId}`;

    const title = `🎂 Tanti auguri, ${nomeCliente}!`;
    const body = isAmb
      ? `Buon compleanno da Meridiano 361! Come Ambassador hai uno sconto speciale questo mese ✨ Mostralo in cassa.`
      : `Buon compleanno da Meridiano 361! Ti aspettiamo in emporio per festeggiare insieme 🎁`;

    const payload = JSON.stringify({
      title,
      body,
      icon:  "/icons/icon-192.png",
      badge: "/icons/icon-72.png",
      url:   cardUrl,
      tag:   `m361-compleanno-${clienteId}-${year}`,
    });

    if (dryrun) {
      log.push(`DRYRUN — ${nomeCliente}: "${title}" → ${body}`);
      results.sent += nSubs;
      continue;
    }

    let nInviate = 0, nErrori = 0;

    const sends = await Promise.allSettled(
      // eslint-disable-next-line @typescript-eslint/no-explicit-any
      (subs ?? []).map((sub: any) =>
        webpush.sendNotification(sub.subscription as webpush.PushSubscription, payload, {
          urgency: "normal", TTL: 86400,
        })
      ),
    );

    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    await Promise.all(sends.map(async (r, i) => {
      if (r.status === "fulfilled") {
        nInviate++;
        results.sent++;
      } else {
        // eslint-disable-next-line @typescript-eslint/no-explicit-any
        const e = (r as any).reason as { statusCode?: number; message?: string };
        if (e?.statusCode === 404 || e?.statusCode === 410) {
          // Subscription scaduta, rimuovila
          // eslint-disable-next-line @typescript-eslint/no-explicit-any
          await db.from("tessera_push_subscriptions").delete().eq("endpoint", (subs![i] as any).endpoint);
          log.push(`Subscription rimossa (${e.statusCode})`);
        } else {
          nErrori++;
          results.failed++;
          log.push(`Errore invio: ${e?.message?.slice(0, 80)}`);
        }
      }
    }));

    // Salva log
    await db.from("birthday_push_log").upsert({
      cliente_id: clienteId, tessera_id: tesseraId, anno: year,
      n_subscriptions: nSubs, n_inviate: nInviate, n_errori: nErrori,
      esito: nErrori === 0 ? "ok" : (nInviate > 0 ? "parziale" : "errore"),
    }, { onConflict: "cliente_id,anno" });
  }

  return new Response(JSON.stringify({ ...results }, null, 2), {
    headers: { "Content-Type": "application/json", ...CORS },
  });
});
