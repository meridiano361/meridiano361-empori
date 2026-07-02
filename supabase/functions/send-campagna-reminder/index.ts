import webpush from "npm:web-push@3";
import { createClient } from "jsr:@supabase/supabase-js@2";

// Mapping codice PDV → valore emporio nella tabella operatori (lowercase)
const PDV_TO_EMPORIO: Record<string, string> = {
  CR:  "cremona",
  CA:  "casalmaggiore",
  VI:  "viadana",
  RE:  "reggio emilia",
  // WEB: nessun emporio fisico, skip
};

const PDV_LABELS: Record<string, string> = {
  CR: "Cremona",
  CA: "Casalmaggiore",
  VI: "Viadana",
  RE: "Reggio Emilia",
  WEB: "Web",
};

Deno.serve(async () => {
  const VAPID_PUB  = Deno.env.get("VAPID_PUBLIC_KEY")  ?? "";
  const VAPID_PRIV = Deno.env.get("VAPID_PRIVATE_KEY") ?? "";
  const VAPID_SUB  = Deno.env.get("VAPID_SUBJECT")     ?? "mailto:info@meridiano361.it";

  const db = createClient(
    Deno.env.get("SUPABASE_URL")!,
    Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
  );

  const log: string[] = [];
  let push_sent = 0;
  let push_failed = 0;

  const today = new Date();
  const fmtDate = (d: Date) => d.toISOString().split("T")[0];
  const dateTomorrow = new Date(today); dateTomorrow.setDate(today.getDate() + 1);
  const date3days    = new Date(today); date3days.setDate(today.getDate() + 3);

  const tomorrowStr = fmtDate(dateTomorrow);
  const in3daysStr  = fmtDate(date3days);

  log.push(`Today: ${fmtDate(today)}, tomorrow: ${tomorrowStr}, in3days: ${in3daysStr}`);

  if (!VAPID_PUB || !VAPID_PRIV) {
    log.push("VAPID keys not configured — skip");
    return new Response(JSON.stringify({ log }), { headers: { "Content-Type": "application/json" } });
  }
  webpush.setVapidDetails(VAPID_SUB, VAPID_PUB, VAPID_PRIV);

  // ── 1. Campagne che iniziano domani → tutti gli operatori dei PDV aderenti ──
  const { data: campagneDomani } = await db
    .from("campagne_commerciali")
    .select("id, titolo, tipologia, pdv_data")
    .eq("data_inizio", tomorrowStr);

  for (const c of campagneDomani ?? []) {
    const pdvData = (c.pdv_data ?? {}) as Record<string, { aderisce?: boolean }>;
    for (const [pdv, emporio] of Object.entries(PDV_TO_EMPORIO)) {
      if (!pdvData[pdv]?.aderisce) continue;
      // Trova tutte le subscription per questo emporio
      const { data: subs } = await db
        .from("push_subscriptions")
        .select("endpoint, subscription")
        .ilike("emporio", emporio);
      if (!subs?.length) { log.push(`${pdv}: no subs`); continue; }

      const titolo = `📢 Campagna domani — ${PDV_LABELS[pdv]}`;
      const testo  = `"${c.titolo}"${c.tipologia ? " ("+c.tipologia+")" : ""} parte domani. Pronti?`;
      const payload = JSON.stringify({ title: titolo, body: testo, url: "/pages/calendario/" });

      for (const row of subs) {
        try {
          await webpush.sendNotification(row.subscription as webpush.PushSubscription, payload, { urgency: "high", TTL: 86400 });
          push_sent++;
        } catch (e: unknown) {
          const status = (e as { statusCode?: number })?.statusCode;
          if (status === 404 || status === 410) {
            await db.from("push_subscriptions").delete().eq("endpoint", row.endpoint);
          } else {
            push_failed++;
            log.push(`err(${status}): ${String(e).slice(0, 80)}`);
          }
        }
      }
      log.push(`[1d] ${c.titolo} → ${pdv}: ${subs.length} dest.`);
    }
  }

  // ── 2. Campagne che iniziano fra 3 giorni → solo resp_emporio dei PDV aderenti ──
  const { data: campagne3g } = await db
    .from("campagne_commerciali")
    .select("id, titolo, tipologia, pdv_data")
    .eq("data_inizio", in3daysStr);

  for (const c of campagne3g ?? []) {
    const pdvData = (c.pdv_data ?? {}) as Record<string, { aderisce?: boolean }>;
    for (const [pdv, emporio] of Object.entries(PDV_TO_EMPORIO)) {
      if (!pdvData[pdv]?.aderisce) continue;

      // Trova gli ID degli is_resp_emporio di questo emporio
      const { data: resps } = await db
        .from("operatori")
        .select("id")
        .eq("is_resp_emporio", true)
        .eq("attivo", true)
        .ilike("emporio", emporio);
      if (!resps?.length) { log.push(`[3d] ${pdv}: no resp_emporio`); continue; }

      const respIds = resps.map((r: { id: string }) => r.id);
      const { data: subs } = await db
        .from("push_subscriptions")
        .select("endpoint, subscription")
        .in("operatore_id", respIds);
      if (!subs?.length) { log.push(`[3d] ${pdv}: no subs for resp`); continue; }

      const titolo = `🗓️ Campagna fra 3 giorni — ${PDV_LABELS[pdv]}`;
      const testo  = `"${c.titolo}"${c.tipologia ? " ("+c.tipologia+")" : ""} inizia il ${in3daysStr}. Tutto pronto?`;
      const payload = JSON.stringify({ title: titolo, body: testo, url: "/pages/calendario/" });

      for (const row of subs) {
        try {
          await webpush.sendNotification(row.subscription as webpush.PushSubscription, payload, { urgency: "normal", TTL: 86400 * 2 });
          push_sent++;
        } catch (e: unknown) {
          const status = (e as { statusCode?: number })?.statusCode;
          if (status === 404 || status === 410) {
            await db.from("push_subscriptions").delete().eq("endpoint", row.endpoint);
          } else {
            push_failed++;
            log.push(`err(${status}): ${String(e).slice(0, 80)}`);
          }
        }
      }
      log.push(`[3d] ${c.titolo} → ${pdv}: ${subs.length} resp dest.`);
    }
  }

  return new Response(
    JSON.stringify({ push_sent, push_failed, log }),
    { headers: { "Content-Type": "application/json" } },
  );
});
