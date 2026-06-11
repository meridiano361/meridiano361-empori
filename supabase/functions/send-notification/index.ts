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

  const db = createClient(
    Deno.env.get("SUPABASE_URL")!,
    Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
  );

  let body: { target: string; titolo: string; testo: string; mittente?: string };
  try { body = await req.json(); }
  catch { return new Response(JSON.stringify({ error: "invalid json" }), { status: 400, headers: CORS }); }

  const { target, titolo, testo } = body;
  const results = {
    push_sent: 0,
    push_failed: 0,
    push_removed: 0,
    subscribers_found: 0,
    vapid_configured: !!(VAPID_PUB && VAPID_PRIV),
    errors: [] as string[],
  };

  if (!VAPID_PUB || !VAPID_PRIV) {
    results.errors.push("VAPID keys not configured");
    return new Response(JSON.stringify(results), { headers: { "Content-Type": "application/json", ...CORS } });
  }

  try {
    webpush.setVapidDetails(VAPID_SUB, VAPID_PUB, VAPID_PRIV);
  } catch (e: unknown) {
    results.errors.push("VAPID setup error: " + String(e));
    return new Response(JSON.stringify(results), { headers: { "Content-Type": "application/json", ...CORS } });
  }

  let q = db.from("push_subscriptions").select("endpoint, subscription, emporio");
  if (target !== "tutti") q = (q as typeof q).eq("emporio", target);
  const { data: subs, error: dbErr } = await q;

  if (dbErr) {
    results.errors.push("DB error: " + dbErr.message);
    return new Response(JSON.stringify(results), { headers: { "Content-Type": "application/json", ...CORS } });
  }

  results.subscribers_found = (subs ?? []).length;
  const payload = JSON.stringify({ title: titolo, body: testo || "", url: "/" });

  await Promise.all((subs ?? []).map(async (row: { endpoint: string; subscription: object }) => {
    try {
      await webpush.sendNotification(row.subscription as webpush.PushSubscription, payload);
      results.push_sent++;
    } catch (e: unknown) {
      const status = (e as { statusCode?: number })?.statusCode;
      const msg    = (e as { message?: string })?.message ?? String(e);
      if (status === 404 || status === 410) {
        await db.from("push_subscriptions").delete().eq("endpoint", row.endpoint);
        results.push_removed++;
      } else {
        results.push_failed++;
        results.errors.push(`send_err(${status ?? "?"}): ${msg.slice(0, 120)}`);
      }
    }
  }));

  return new Response(JSON.stringify(results), {
    headers: { "Content-Type": "application/json", ...CORS },
  });
});
