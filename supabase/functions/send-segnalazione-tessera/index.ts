import webpush from "npm:web-push@3";
import { createClient } from "jsr:@supabase/supabase-js@2";

const CORS = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

const SUPERADMIN_EMAIL = "e.mazzolari@meridiano361.it";

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") return new Response(null, { headers: CORS });

  const VAPID_PUB  = Deno.env.get("VAPID_PUBLIC_KEY")  ?? "";
  const VAPID_PRIV = Deno.env.get("VAPID_PRIVATE_KEY") ?? "";
  const VAPID_SUB  = Deno.env.get("VAPID_SUBJECT")     ?? "mailto:info@meridiano361.it";
  const RESEND_KEY = Deno.env.get("RESEND_API_KEY")    ?? "";

  const db = createClient(
    Deno.env.get("SUPABASE_URL")!,
    Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
  );

  let body: { messaggio: string; tessera_id?: string; nome_cliente?: string };
  try { body = await req.json(); }
  catch { return new Response(JSON.stringify({ error: "invalid json" }), { status: 400, headers: CORS }); }

  const { messaggio, tessera_id, nome_cliente } = body;
  if (!messaggio?.trim()) {
    return new Response(JSON.stringify({ error: "messaggio vuoto" }), { status: 400, headers: CORS });
  }

  const titolo = "🔧 Segnalazione problema tessera";
  const testo  = nome_cliente
    ? `Da ${nome_cliente}: ${messaggio}`
    : messaggio;

  // 1. Email via Resend
  if (RESEND_KEY) {
    try {
      await fetch("https://api.resend.com/emails", {
        method: "POST",
        headers: {
          "Authorization": `Bearer ${RESEND_KEY}`,
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          from: "M361 Empori <notifiche@meridiano361.it>",
          to: [SUPERADMIN_EMAIL],
          subject: titolo,
          html: `<p><strong>${titolo}</strong></p>
                 <p>${testo.replace(/\n/g, "<br>")}</p>
                 ${tessera_id ? `<p style="color:#888;font-size:12px">Tessera ID: ${tessera_id}</p>` : ""}`,
        }),
      });
    } catch (_) { /* ignora */ }
  }

  // 2. Push notification → tutte le subscription di Emilio (email superadmin)
  if (VAPID_PUB && VAPID_PRIV) {
    try {
      webpush.setVapidDetails(VAPID_SUB, VAPID_PUB, VAPID_PRIV);

      // Trova l'operatore superadmin tramite email
      const { data: operatori } = await db
        .from("operatori")
        .select("id")
        .eq("email", SUPERADMIN_EMAIL)
        .limit(1);

      if (operatori?.length) {
        const opId = operatori[0].id;
        const { data: subs } = await db
          .from("push_subscriptions")
          .select("subscription")
          .eq("operatore_id", opId);

        const payload = JSON.stringify({ title: titolo, body: testo, url: "/pages/tessere/index.html" });
        for (const row of (subs ?? [])) {
          try {
            await webpush.sendNotification(JSON.parse(row.subscription), payload);
          } catch (_) { /* ignora subscription scaduta */ }
        }
      }
    } catch (_) { /* ignora */ }
  }

  return new Response(JSON.stringify({ ok: true }), {
    headers: { "Content-Type": "application/json", ...CORS },
  });
});
