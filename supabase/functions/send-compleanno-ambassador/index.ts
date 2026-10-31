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

  const { hour, day, month } = italyNow();

  // Esegui solo il 1° del mese alle 9:00
  if (!force && (day !== 1 || hour !== 9)) {
    return new Response(
      JSON.stringify({ skipped: true, reason: `giorno ${day}, ora ${hour}h (esegue solo il 1° del mese alle 9:00)` }),
      { headers: { "Content-Type": "application/json", ...CORS } },
    );
  }

  const db = createClient(
    Deno.env.get("SUPABASE_URL")!,
    Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
  );

  webpush.setVapidDetails(VAPID_SUB, VAPID_PUB, VAPID_PRIV);

  const log: string[] = [];

  // Trova le tessere Ambassador il cui cliente compie gli anni questo mese
  const { data: tessere, error: tErr } = await db
    .from("tessere")
    .select("id, slug, token, clienti!inner(nome, cognome, data_nascita)")
    .eq("tipo", "ambassador")
    .eq("attiva", true)
    .not("clienti.data_nascita", "is", null);

  if (tErr) {
    return new Response(JSON.stringify({ error: tErr.message }), { status: 500, headers: { "Content-Type": "application/json", ...CORS } });
  }

  const tessereCompleanno = (tessere ?? []).filter((t: any) => {
    const bd = new Date(t.clienti.data_nascita);
    return (bd.getMonth() + 1) === month;
  });

  log.push(`Tessere Ambassador con compleanno in mese ${month}: ${tessereCompleanno.length}`);

  if (dryrun) {
    return new Response(
      JSON.stringify({ dryrun: true, log, tessereCompleanno: tessereCompleanno.map((t: any) => ({ id: t.id, nome: t.clienti.nome })) }),
      { headers: { "Content-Type": "application/json", ...CORS } },
    );
  }

  let inviati = 0, errori = 0;

  for (const t of tessereCompleanno) {
    const { data: subs } = await db
      .from("tessera_push_subscriptions")
      .select("subscription, endpoint")
      .eq("tessera_id", t.id.toString());

    if (!subs || subs.length === 0) continue;

    const nomeCliente = t.clienti.nome || "Cliente";
    const payload = JSON.stringify({
      title: `🎂 Buon mese del compleanno, ${nomeCliente}!`,
      body: "Hai diritto a uno sconto del 10% su una spesa a tua scelta in questo mese. Mostralo in negozio!",
      icon: "/icons/icon-192.png",
      badge: "/icons/icon-192.png",
    });

    for (const sub of subs) {
      try {
        await webpush.sendNotification(sub.subscription, payload);
        inviati++;
        log.push(`✓ Inviato a tessera ${t.id} (${nomeCliente})`);
      } catch (e: any) {
        errori++;
        log.push(`✗ Errore tessera ${t.id}: ${e.message}`);
        // Rimuovi subscription scaduta
        if (e.statusCode === 410) {
          await db.from("tessera_push_subscriptions").delete().eq("endpoint", sub.endpoint);
          log.push(`  → Subscription rimossa (410 Gone)`);
        }
      }
    }
  }

  return new Response(
    JSON.stringify({ ok: true, inviati, errori, log }),
    { headers: { "Content-Type": "application/json", ...CORS } },
  );
});
