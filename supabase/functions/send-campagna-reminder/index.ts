import webpush from "npm:web-push@3";
import { createClient } from "jsr:@supabase/supabase-js@2";

const PDV_TO_EMPORIO: Record<string, string> = {
  CR:  "cremona",
  CA:  "casalmaggiore",
  VI:  "viadana",
  RE:  "reggio emilia",
};

const PDV_LABELS: Record<string, string> = {
  CR: "Cremona",
  CA: "Casalmaggiore",
  VI: "Viadana",
  RE: "Reggio Emilia",
  WEB: "Web",
};

// ── Email via Resend ──────────────────────────────────────────────────────────
async function sendEmail(to: string, subject: string, html: string) {
  const apiKey = Deno.env.get("RESEND_API_KEY");
  if (!apiKey) return;
  try {
    await fetch("https://api.resend.com/emails", {
      method: "POST",
      headers: { "Authorization": `Bearer ${apiKey}`, "Content-Type": "application/json" },
      body: JSON.stringify({
        from: "M361 Empori <notifiche@meridiano361.it>",
        to: [to],
        subject,
        html,
      }),
    });
  } catch (_) { /* ignora errori email */ }
}

function pad(n: number) { return String(n).padStart(2, "0"); }

function fmtDateIt(dateStr: string): string {
  const [y, m, d] = dateStr.split("-");
  const mesi = ["","gennaio","febbraio","marzo","aprile","maggio","giugno",
                 "luglio","agosto","settembre","ottobre","novembre","dicembre"];
  return `${parseInt(d)} ${mesi[parseInt(m)]} ${y}`;
}

function emailHtmlCampagna(titoloCampagna: string, tipologia: string | null, dataInizio: string, pdvLabel: string): string {
  const tipoStr = tipologia ? ` (${tipologia})` : "";
  const dataFmt = fmtDateIt(dataInizio);
  return `
<div style="font-family:sans-serif;max-width:500px;margin:0 auto">
  <div style="background:#1e293b;color:#fff;padding:20px;border-radius:12px 12px 0 0">
    <h2 style="margin:0;font-size:18px">🗓️ Promemoria campagna</h2>
    <p style="margin:4px 0 0;opacity:.7;font-size:13px">Emporio ${pdvLabel}</p>
  </div>
  <div style="padding:20px;background:#fff;border:1px solid #e2e8f0;border-top:none;border-radius:0 0 12px 12px">
    <p style="font-size:16px;font-weight:700;color:#1e293b;margin:0 0 4px">${titoloCampagna}${tipoStr}</p>
    <p style="color:#64748b;font-size:14px;margin:0 0 16px">inizia tra <strong>3 giorni</strong>, il <strong>${dataFmt}</strong>.</p>
    <p style="font-size:14px;color:#475569;margin:0 0 20px">Assicurati che l'emporio sia pronto: materiali, vetrine e scorte in ordine.</p>
    <a href="https://meridiano361-empori.vercel.app/pages/calendario-commerciale/calendario-commerciale.html"
       style="display:inline-block;background:#1e293b;color:#fff;padding:10px 18px;border-radius:8px;text-decoration:none;font-weight:700;font-size:13px">
      Vedi calendario →
    </a>
  </div>
</div>`;
}

Deno.serve(async () => {
  const VAPID_PUB  = Deno.env.get("VAPID_PUBLIC_KEY")  ?? "";
  const VAPID_PRIV = Deno.env.get("VAPID_PRIVATE_KEY") ?? "";
  const VAPID_SUB  = Deno.env.get("VAPID_SUBJECT")     ?? "mailto:info@meridiano361.it";

  const db = createClient(
    Deno.env.get("SUPABASE_URL")!,
    Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
  );

  const log: string[] = [];
  let push_sent = 0, push_failed = 0, email_sent = 0;

  const today = new Date();
  const fmtDate = (d: Date) => d.toISOString().split("T")[0];
  const dateTomorrow = new Date(today); dateTomorrow.setDate(today.getDate() + 1);
  const date3days    = new Date(today); date3days.setDate(today.getDate() + 3);
  const tomorrowStr  = fmtDate(dateTomorrow);
  const in3daysStr   = fmtDate(date3days);

  log.push(`Today: ${fmtDate(today)}, tomorrow: ${tomorrowStr}, in3days: ${in3daysStr}`);

  // Leggi configurazione notifiche
  const { data: configs } = await db.from("notifiche_config").select("id, attiva");
  const isActive = (id: string) => configs?.find((c: { id: string; attiva: boolean }) => c.id === id)?.attiva !== false;

  if (VAPID_PUB && VAPID_PRIV) webpush.setVapidDetails(VAPID_SUB, VAPID_PUB, VAPID_PRIV);

  // ── 1. Campagne che iniziano domani → push a tutti gli operatori ─────────────
  if (isActive("campagna_push_1g")) {
    const { data: campagneDomani } = await db
      .from("campagne_commerciali")
      .select("id, titolo, tipologia, pdv_data")
      .eq("data_inizio", tomorrowStr);

    for (const c of campagneDomani ?? []) {
      const pdvData = (c.pdv_data ?? {}) as Record<string, { aderisce?: boolean }>;
      for (const [pdv, emporio] of Object.entries(PDV_TO_EMPORIO)) {
        if (!pdvData[pdv]?.aderisce) continue;
        const { data: subs } = await db
          .from("push_subscriptions").select("endpoint, subscription").ilike("emporio", emporio);
        if (!subs?.length) { log.push(`[1d-push] ${pdv}: no subs`); continue; }
        const payload = JSON.stringify({
          title: `📢 Campagna domani — ${PDV_LABELS[pdv]}`,
          body:  `"${c.titolo}"${c.tipologia ? " ("+c.tipologia+")" : ""} parte domani. Pronti?`,
          url:   "/pages/calendario-commerciale/calendario-commerciale.html",
        });
        for (const row of subs) {
          try {
            await webpush.sendNotification(row.subscription as webpush.PushSubscription, payload, { urgency: "high", TTL: 86400 });
            push_sent++;
          } catch (e: unknown) {
            const st = (e as { statusCode?: number })?.statusCode;
            if (st === 404 || st === 410) await db.from("push_subscriptions").delete().eq("endpoint", row.endpoint);
            else { push_failed++; log.push(`err(${st}): ${String(e).slice(0, 80)}`); }
          }
        }
        log.push(`[1d-push] ${c.titolo} → ${pdv}: ${subs.length}`);
      }
    }
  }

  // ── 2. Campagne che iniziano fra 3 giorni ────────────────────────────────────
  const { data: campagne3g } = await db
    .from("campagne_commerciali")
    .select("id, titolo, tipologia, data_inizio, pdv_data")
    .eq("data_inizio", in3daysStr);

  for (const c of campagne3g ?? []) {
    const pdvData = (c.pdv_data ?? {}) as Record<string, { aderisce?: boolean }>;

    for (const [pdv, emporio] of Object.entries(PDV_TO_EMPORIO)) {
      if (!pdvData[pdv]?.aderisce) continue;

      // 2a. Push → solo resp_emporio
      if (isActive("campagna_push_3g") && VAPID_PUB && VAPID_PRIV) {
        const { data: resps } = await db.from("operatori")
          .select("id").eq("is_resp_emporio", true).eq("attivo", true).ilike("emporio", emporio);
        if (resps?.length) {
          const respIds = resps.map((r: { id: string }) => r.id);
          const { data: subs } = await db.from("push_subscriptions")
            .select("endpoint, subscription").in("operatore_id", respIds);
          const payload = JSON.stringify({
            title: `🗓️ Campagna fra 3 giorni — ${PDV_LABELS[pdv]}`,
            body:  `"${c.titolo}"${c.tipologia ? " ("+c.tipologia+")" : ""} inizia il ${in3daysStr}.`,
            url:   "/pages/calendario-commerciale/calendario-commerciale.html",
          });
          for (const row of subs ?? []) {
            try {
              await webpush.sendNotification(row.subscription as webpush.PushSubscription, payload, { urgency: "normal", TTL: 86400 * 2 });
              push_sent++;
            } catch (e: unknown) {
              const st = (e as { statusCode?: number })?.statusCode;
              if (st === 404 || st === 410) await db.from("push_subscriptions").delete().eq("endpoint", row.endpoint);
              else { push_failed++; log.push(`err(${st}): ${String(e).slice(0, 80)}`); }
            }
          }
          log.push(`[3d-push] ${c.titolo} → ${pdv}: ${subs?.length ?? 0} resp`);
        }
      }

      // 2b. Email → tutti gli operatori attivi dell'emporio con email
      if (isActive("campagna_email_3g")) {
        const { data: ops } = await db.from("operatori")
          .select("email").eq("attivo", true).ilike("emporio", emporio).not("email", "is", null);
        if (!ops?.length) { log.push(`[3d-email] ${pdv}: no emails`); continue; }
        const subject = `🗓️ Tra 3 giorni inizia: ${c.titolo} — Emporio ${PDV_LABELS[pdv]}`;
        const html    = emailHtmlCampagna(c.titolo, c.tipologia, c.data_inizio, PDV_LABELS[pdv]);
        for (const op of ops) {
          if (!op.email) continue;
          await sendEmail(op.email, subject, html);
          email_sent++;
        }
        log.push(`[3d-email] ${c.titolo} → ${pdv}: ${ops.length} email`);
      }
    }
  }

  return new Response(
    JSON.stringify({ push_sent, push_failed, email_sent, log }),
    { headers: { "Content-Type": "application/json" } },
  );
});
