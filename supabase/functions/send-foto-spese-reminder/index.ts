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

  // Ora italiana corrente
  const now = new Date();
  const itDate = new Intl.DateTimeFormat("it-IT", {
    timeZone: "Europe/Rome",
    year: "numeric", month: "2-digit", day: "2-digit", hour: "2-digit", hour12: false,
  }).formatToParts(now);
  const itHour = parseInt(itDate.find(p => p.type === "hour")!.value, 10);

  const urlObj  = new URL(req.url);
  const force   = urlObj.searchParams.get("force") === "1";
  const dryrun  = urlObj.searchParams.get("dryrun") === "1";

  // Il cron gira alle 15:00 e 16:00 UTC; esegui solo alle 17:00 ora italiana
  if (!force && itHour !== 17) {
    return new Response(JSON.stringify({ skipped: true, itHour }), {
      headers: { "Content-Type": "application/json", ...CORS },
    });
  }

  // Ultimi 7 giorni: cerca fogli con spese ma senza foto e non esenti
  const sevenDaysAgo = new Date(now);
  sevenDaysAgo.setDate(sevenDaysAgo.getDate() - 7);

  const { data: records } = await db
    .from("cassa_giorni")
    .select("chiave, emporio, mat_pay_spese, pom_pay_spese, mat_foto_spese, pom_foto_spese, mat_spese_foto_exempt, pom_spese_foto_exempt")
    .gte("created_at", sevenDaysAgo.toISOString());

  if (!records?.length) {
    return new Response(JSON.stringify({ ok: true, checked: 0 }), {
      headers: { "Content-Type": "application/json", ...CORS },
    });
  }

  // Individua gli empori con almeno un turno mancante
  const emporiDaRicordare = new Map<string, string[]>();

  for (const r of records) {
    const emp = (r.emporio || "").toLowerCase();
    if (!emp) continue;

    const matSpese = parseFloat(r.mat_pay_spese ?? 0) > 0;
    const pomSpese = parseFloat(r.pom_pay_spese ?? 0) > 0;
    const matManca = matSpese && !r.mat_foto_spese && !r.mat_spese_foto_exempt;
    const pomManca = pomSpese && !r.pom_foto_spese && !r.pom_spese_foto_exempt;

    if (!matManca && !pomManca) continue;

    const turni: string[] = [];
    if (matManca) turni.push("mattino");
    if (pomManca) turni.push("pomeriggio");
    if (!emporiDaRicordare.has(emp)) emporiDaRicordare.set(emp, []);
    for (const t of turni) {
      if (!emporiDaRicordare.get(emp)!.includes(t)) emporiDaRicordare.get(emp)!.push(t);
    }
  }

  if (emporiDaRicordare.size === 0) {
    return new Response(JSON.stringify({ ok: true, nothingToDo: true }), {
      headers: { "Content-Type": "application/json", ...CORS },
    });
  }

  const results = { notified: 0, push_sent: 0, push_failed: 0, errors: [] as string[], dryrun };

  if (!dryrun && VAPID_PUB && VAPID_PRIV) {
    webpush.setVapidDetails(VAPID_SUB, VAPID_PUB, VAPID_PRIV);
  }

  for (const [emp, turni] of emporiDaRicordare) {
    const turnoStr = turni.join(" e ");
    const titolo = "📸 Foto scontrino mancante";
    const testo  = `Ricorda di caricare la foto dello scontrino per le spese del ${turnoStr} in Controllo Cassa.`;

    results.notified++;

    if (dryrun) continue;

    // Push alle subscriptions dell'emporio
    const { data: subs } = await db
      .from("push_subscriptions")
      .select("endpoint, subscription, operatore_nome")
      .eq("emporio", emp);

    for (const s of subs ?? []) {
      try {
        await webpush.sendNotification(
          s.subscription as webpush.PushSubscription,
          JSON.stringify({
            title: titolo,
            body:  testo,
            icon:  "/icons/icon-192.png",
            url:   "/pages/cassa/cassa.html",
          }),
        );
        results.push_sent++;
      } catch (e: unknown) {
        const status = (e as { statusCode?: number })?.statusCode;
        if (status === 404 || status === 410) {
          await db.from("push_subscriptions").delete().eq("endpoint", s.endpoint);
        } else {
          results.push_failed++;
          results.errors.push(String(e).slice(0, 100));
        }
      }
    }
  }

  return new Response(JSON.stringify({ ok: true, ...results }), {
    headers: { "Content-Type": "application/json", ...CORS },
  });
});
