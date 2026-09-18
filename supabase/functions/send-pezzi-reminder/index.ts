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

  // Verifica ora italiana: deve essere le 9:00 (UTC+2 estate / UTC+1 inverno)
  const now = new Date();
  const itHour = new Date(now.toLocaleString("en-US", { timeZone: "Europe/Rome" })).getHours();
  if (itHour !== 9) {
    return new Response(JSON.stringify({ skipped: true, itHour }), {
      headers: { "Content-Type": "application/json", ...CORS },
    });
  }

  // Calcola settimana ISO appena conclusa (lunedì = inizio settimana, ricorda la settimana precedente)
  const lun = new Date(now);
  lun.setDate(lun.getDate() - 7); // settimana scorsa
  const isoWeek = (() => {
    const d = new Date(lun); d.setHours(12, 0, 0, 0);
    d.setDate(d.getDate() + 3 - (d.getDay() + 6) % 7);
    const w1 = new Date(d.getFullYear(), 0, 4);
    return 1 + Math.round(((d.getTime() - w1.getTime()) / 86400000 - 3 + (w1.getDay() + 6) % 7) / 7);
  })();

  const titolo = "📊 Compilazione settimanale";
  const testo  = `Inserisci i pezzi e il venduto della settimana ${isoWeek} in Commerciale → Settimanale.`;

  // Inserisci in-app notification (visibile a tutti al prossimo accesso)
  await db.from("notifiche").insert({
    titolo, testo, target: "tutti", mittente: "sistema",
  });

  const results = { push_sent: 0, push_failed: 0, errors: [] as string[] };

  if (VAPID_PUB && VAPID_PRIV) {
    try {
      webpush.setVapidDetails(VAPID_SUB, VAPID_PUB, VAPID_PRIV);
      const { data: subs } = await db.from("push_subscriptions").select("endpoint,subscription,operatore_nome");
      for (const s of subs ?? []) {
        try {
          await webpush.sendNotification(s.subscription as webpush.PushSubscription, JSON.stringify({
            title: titolo, body: testo, icon: "/icons/icon-192.png", url: "/pages/cassa/cassa.html"
          }));
          results.push_sent++;
        } catch (e: unknown) {
          results.push_failed++;
          results.errors.push(String(e).slice(0, 100));
        }
      }
    } catch (e: unknown) {
      results.errors.push("VAPID: " + String(e));
    }
  }

  return new Response(JSON.stringify({ ok: true, isoWeek, ...results }), {
    headers: { "Content-Type": "application/json", ...CORS },
  });
});
