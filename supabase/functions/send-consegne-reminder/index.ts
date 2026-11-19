import webpush from "npm:web-push@3";
import { createClient } from "jsr:@supabase/supabase-js@2";

Deno.serve(async () => {
  // Invia solo alle 8:00 ora italiana (CET/CEST)
  const now = new Date();
  const italianHour = parseInt(
    new Intl.DateTimeFormat("it", { timeZone: "Europe/Rome", hour: "numeric", hour12: false }).format(now),
    10,
  );
  if (italianHour !== 8) {
    return new Response(JSON.stringify({ skipped: true, hour: italianHour }), { status: 200 });
  }

  const VAPID_PUB  = Deno.env.get("VAPID_PUBLIC_KEY")  ?? "";
  const VAPID_PRIV = Deno.env.get("VAPID_PRIVATE_KEY") ?? "";
  const VAPID_SUB  = Deno.env.get("VAPID_SUBJECT")     ?? "mailto:info@meridiano361.it";

  if (!VAPID_PUB || !VAPID_PRIV) {
    return new Response(JSON.stringify({ error: "VAPID not configured" }), { status: 500 });
  }

  webpush.setVapidDetails(VAPID_SUB, VAPID_PUB, VAPID_PRIV);

  const db = createClient(
    Deno.env.get("SUPABASE_URL")!,
    Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
  );

  // Data italiana di oggi
  const todayIT = new Intl.DateTimeFormat("it", {
    timeZone: "Europe/Rome", year: "numeric", month: "2-digit", day: "2-digit",
  }).format(now);
  const [dd, mm, yyyy] = todayIT.split("/");
  const todayISO = `${yyyy}-${mm}-${dd}`;

  // Consegne di oggi
  const { data: consegne } = await db
    .from("consegne")
    .select("id, destinatario_nome, ora_prevista, stato, da_concordare, data_consegna")
    .or(`data_consegna.eq.${todayISO},and(da_concordare.eq.true,data_consegna.is.null)`)
    .neq("stato", "annullato");

  const totale = (consegne ?? []).length;
  if (totale === 0) {
    return new Response(JSON.stringify({ sent: 0, reason: "no deliveries today" }), { status: 200 });
  }

  // Destinatari: tutti i fattorini attivi
  const { data: fattorini } = await db
    .from("operatori")
    .select("id")
    .eq("ruolo", "fattorino")
    .eq("attivo", true);

  const ids = (fattorini ?? []).map((f) => String(f.id));
  if (!ids.length) {
    return new Response(JSON.stringify({ sent: 0, reason: "no fattorini" }), { status: 200 });
  }

  const { data: subs } = await db
    .from("push_subscriptions")
    .select("endpoint, subscription")
    .in("operatore_id", ids);

  if (!subs?.length) {
    return new Response(JSON.stringify({ sent: 0, reason: "no subscriptions" }), { status: 200 });
  }

  // Testo notifica
  const concordare = (consegne ?? []).filter((c) => c.da_concordare && !c.data_consegna).length;
  const programmate = totale - concordare;
  let corpo = "";
  if (programmate > 0) corpo += `${programmate} ${programmate === 1 ? "consegna programmata" : "consegne programmate"}`;
  if (concordare > 0)  corpo += (corpo ? " · " : "") + `${concordare} da concordare`;

  const payload = JSON.stringify({
    title: `📦 Consegne di oggi`,
    body: corpo,
    url: "/pages/consegne/index.html",
  });

  let sent = 0, failed = 0;
  await Promise.all(subs.map(async (row) => {
    try {
      await webpush.sendNotification(row.subscription as webpush.PushSubscription, payload, { urgency: "high", TTL: 43200 });
      sent++;
    } catch (e: unknown) {
      const status = (e as { statusCode?: number })?.statusCode;
      if (status === 404 || status === 410) {
        await db.from("push_subscriptions").delete().eq("endpoint", row.endpoint);
      } else {
        failed++;
      }
    }
  }));

  return new Response(JSON.stringify({ sent, failed, totale_consegne: totale }), { status: 200 });
});
