// Supabase Edge Function — send-notification
// Invia notifiche push (Web Push) ed email (Resend) agli operatori.
// Secrets necessari (supabase secrets set ...):
//   VAPID_PUBLIC_KEY   — chiave pubblica VAPID
//   VAPID_PRIVATE_KEY  — chiave privata VAPID
//   VAPID_SUBJECT      — es. mailto:info@meridiano361.it
//   RESEND_API_KEY     — chiave API Resend

import webpush from "npm:web-push@3";
import { createClient } from "jsr:@supabase/supabase-js@2";

const CORS = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") return new Response(null, { headers: CORS });

  const VAPID_PUB  = Deno.env.get("VAPID_PUBLIC_KEY")  ?? "";
  const VAPID_PRIV = Deno.env.get("VAPID_PRIVATE_KEY") ?? "";
  const VAPID_SUB  = Deno.env.get("VAPID_SUBJECT")     ?? "mailto:info@meridiano361.it";
  const RESEND_KEY = Deno.env.get("RESEND_API_KEY")    ?? "";
  const FROM_EMAIL = Deno.env.get("RESEND_FROM")       ?? "Meridiano361 <notifiche@meridiano361.it>";

  const db = createClient(
    Deno.env.get("SUPABASE_URL")!,
    Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
  );

  let body: { target: string; titolo: string; testo: string; mittente: string };
  try { body = await req.json(); }
  catch { return new Response(JSON.stringify({ error: "invalid json" }), { status: 400, headers: CORS }); }

  const { target, titolo, testo, mittente } = body;
  const results = { email_sent: 0, push_sent: 0, errors: [] as string[] };

  // ── EMAIL via Resend ───────────────────────────────────────────────────
  if (RESEND_KEY) {
    let q = db.from("operatori").select("email, nome").not("email", "is", null).neq("email", "");
    if (target !== "tutti") q = (q as typeof q).eq("emporio", target);
    const { data: ops } = await q;

    await Promise.all((ops ?? []).map(async (op: { email: string; nome: string }) => {
      if (!op.email) return;
      try {
        const res = await fetch("https://api.resend.com/emails", {
          method: "POST",
          headers: { Authorization: `Bearer ${RESEND_KEY}`, "Content-Type": "application/json" },
          body: JSON.stringify({
            from: FROM_EMAIL,
            to:   [op.email],
            subject: `🔔 ${titolo}`,
            html: `
              <div style="font-family:Inter,sans-serif;max-width:520px;margin:0 auto;border-radius:12px;overflow:hidden;border:1px solid #e2e8f0">
                <div style="background:#B5453A;padding:20px 24px">
                  <h2 style="color:#fff;margin:0;font-size:18px">🔔 ${titolo}</h2>
                </div>
                <div style="padding:20px 24px;background:#fff">
                  ${testo ? `<p style="color:#334155;font-size:15px;line-height:1.6;margin:0 0 16px">${testo}</p>` : ""}
                  <hr style="border:none;border-top:1px solid #f1f5f9;margin:0 0 12px">
                  <p style="color:#94a3b8;font-size:12px;margin:0">
                    Inviato da <strong>${mittente}</strong> — Meridiano361 Empori
                  </p>
                </div>
              </div>`,
          }),
        });
        if (res.ok) results.email_sent++;
        else results.errors.push(`email_err:${op.email}`);
      } catch (e) {
        results.errors.push(`email_exc:${op.email}`);
      }
    }));
  }

  // ── WEB PUSH ──────────────────────────────────────────────────────────
  if (VAPID_PUB && VAPID_PRIV) {
    webpush.setVapidDetails(VAPID_SUB, VAPID_PUB, VAPID_PRIV);

    let q = db.from("push_subscriptions").select("endpoint, subscription, emporio");
    if (target !== "tutti") q = (q as typeof q).eq("emporio", target);
    const { data: subs } = await q;

    const payload = JSON.stringify({ title: titolo, body: testo || "", url: "/" });

    await Promise.all((subs ?? []).map(async (row: { endpoint: string; subscription: object }) => {
      try {
        await webpush.sendNotification(row.subscription as webpush.PushSubscription, payload);
        results.push_sent++;
      } catch (e: unknown) {
        const status = (e as { statusCode?: number })?.statusCode;
        // Rimuovi sottoscrizioni scadute/non valide
        if (status === 404 || status === 410) {
          await db.from("push_subscriptions").delete().eq("endpoint", row.endpoint);
        } else {
          results.errors.push(`push_err:${String(row.endpoint).slice(-12)}`);
        }
      }
    }));
  }

  return new Response(JSON.stringify(results), {
    headers: { "Content-Type": "application/json", ...CORS },
  });
});
