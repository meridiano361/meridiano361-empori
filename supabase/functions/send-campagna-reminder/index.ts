import webpush from "npm:web-push@3";
import { createClient } from "jsr:@supabase/supabase-js@2";
import {
  loadRules,
  resolveOperatorIds,
  resolveEmails,
  sendPushBatch,
  sendEmailViaResend,
  type NotificaRule,
  type VapidConfig,
} from "../_shared/notifiche_lib.ts";

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

function fmtDateIt(dateStr: string): string {
  const [y, m, d] = dateStr.split("-");
  const mesi = ["","gennaio","febbraio","marzo","aprile","maggio","giugno",
                 "luglio","agosto","settembre","ottobre","novembre","dicembre"];
  return `${parseInt(d)} ${mesi[parseInt(m)]} ${y}`;
}

function emailHtmlCampagna(titoloCampagna: string, tipologia: string | null, dataInizio: string, pdvLabel: string, giorniStr: string): string {
  const tipoStr  = tipologia ? ` (${tipologia})` : "";
  const dataFmt  = fmtDateIt(dataInizio);
  return `
<div style="font-family:sans-serif;max-width:500px;margin:0 auto">
  <div style="background:#1e293b;color:#fff;padding:20px;border-radius:12px 12px 0 0">
    <h2 style="margin:0;font-size:18px">Promemoria campagna</h2>
    <p style="margin:4px 0 0;opacity:.7;font-size:13px">Emporio ${pdvLabel}</p>
  </div>
  <div style="padding:20px;background:#fff;border:1px solid #e2e8f0;border-top:none;border-radius:0 0 12px 12px">
    <p style="font-size:16px;font-weight:700;color:#1e293b;margin:0 0 4px">${titoloCampagna}${tipoStr}</p>
    <p style="color:#64748b;font-size:14px;margin:0 0 16px">inizia ${giorniStr}, il <strong>${dataFmt}</strong>.</p>
    <p style="font-size:14px;color:#475569;margin:0 0 20px">Assicurati che l'emporio sia pronto: materiali, vetrine e scorte in ordine.</p>
    <a href="https://meridiano361-empori.vercel.app/pages/calendario-commerciale/calendario-commerciale.html"
       style="display:inline-block;background:#1e293b;color:#fff;padding:10px 18px;border-radius:8px;text-decoration:none;font-weight:700;font-size:13px">
      Vedi calendario →
    </a>
  </div>
</div>`;
}

// ── Helper push per campagna (usa resolveOperatorIds + sendPushBatch) ─────────
async function sendCampagnaPush(
  db: ReturnType<typeof createClient>,
  vapid: VapidConfig,
  rule: NotificaRule,
  campagna: Record<string, unknown>,
  emporio: string,
  pdvLabel: string,
  giorni: number,
  log: string[],
): Promise<{ sent: number; failed: number }> {
  const opIds = await resolveOperatorIds(db, rule.destinatari ?? "Responsabile emporio", { emporio, settore: campagna.settore as string });
  if (!opIds.length) {
    log.push(`[${rule.id}] ${pdvLabel}: no operatori`);
    return { sent: 0, failed: 0 };
  }

  const { data: subs } = await db
    .from("push_subscriptions")
    .select("operatore_id, endpoint, subscription")
    .in("operatore_id", opIds);

  const giorniLabel = giorni === 0 ? "oggi" : giorni === 1 ? "domani" : `tra ${giorni} giorni`;
  const titolo = (rule.nome ?? `Campagna ${giorniLabel} — ${pdvLabel}`)
    .replace(/\{pdv\}/g, pdvLabel)
    .replace(/\{giorni\}/g, String(giorni));
  const corpo = (rule.descrizione ?? `"${campagna.titolo}"${campagna.tipologia ? " (" + campagna.tipologia + ")" : ""} inizia ${giorniLabel}.`)
    .replace(/\{titolo\}/g, String(campagna.titolo ?? ""))
    .replace(/\{pdv\}/g, pdvLabel)
    .replace(/\{giorni\}/g, String(giorni));

  const payload = {
    title: titolo,
    body: corpo,
    url: "/pages/calendario-commerciale/calendario-commerciale.html",
  };

  const r = await sendPushBatch(db, subs ?? [], payload, vapid, log);
  log.push(`[${rule.id}] push ${pdvLabel}: ${r.sent} sent`);
  return r;
}

// ── Helper email per campagna ─────────────────────────────────────────────────
async function sendCampagnaEmail(
  db: ReturnType<typeof createClient>,
  rule: NotificaRule,
  campagna: Record<string, unknown>,
  emporio: string,
  pdvLabel: string,
  giorni: number,
  log: string[],
): Promise<number> {
  const emailList = await resolveEmails(db, rule.destinatari ?? "Responsabile emporio", { emporio, settore: campagna.settore as string });
  if (!emailList.length) {
    log.push(`[${rule.id}] ${pdvLabel}: no emails`);
    return 0;
  }

  const giorniStr = giorni === 0 ? "oggi" : giorni === 1 ? "domani" : `tra ${giorni} giorni`;
  const subject = `${rule.nome ?? "Promemoria campagna"}: ${campagna.titolo} — Emporio ${pdvLabel}`;
  const html    = emailHtmlCampagna(campagna.titolo as string, campagna.tipologia as string | null, campagna.data_inizio as string, pdvLabel, giorniStr);

  for (const addr of emailList) {
    await sendEmailViaResend(addr, subject, html);
  }
  log.push(`[${rule.id}] email ${pdvLabel}: ${emailList.length} inviati`);
  return emailList.length;
}

Deno.serve(async (req) => {
  const body = await req.json().catch(() => ({})) as Record<string, unknown>;
  const soloOrdini = body.solo_ordini === true;

  const VAPID_PUB  = Deno.env.get("VAPID_PUBLIC_KEY")  ?? "";
  const VAPID_PRIV = Deno.env.get("VAPID_PRIVATE_KEY") ?? "";
  const VAPID_SUB  = Deno.env.get("VAPID_SUBJECT")     ?? "mailto:info@meridiano361.it";

  const vapid: VapidConfig = { pub: VAPID_PUB, priv: VAPID_PRIV, subject: VAPID_SUB };

  const db = createClient(
    Deno.env.get("SUPABASE_URL")!,
    Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
  );

  const log: string[] = [];
  let push_sent = 0, push_failed = 0, email_sent = 0;

  const today = new Date();
  const fmtDate = (d: Date) => d.toISOString().split("T")[0];

  const dateTomorrow = new Date(today); dateTomorrow.setDate(today.getDate() + 1);
  const tomorrowStr  = fmtDate(dateTomorrow);
  const todayStr     = fmtDate(today);

  log.push(`Today: ${todayStr}, tomorrow: ${tomorrowStr}`);

  if (VAPID_PUB && VAPID_PRIV) webpush.setVapidDetails(VAPID_SUB, VAPID_PUB, VAPID_PRIV);

  // Carica TUTTE le regole campagna
  const rules = await loadRules(db, "campagna");
  log.push(`Regole campagna: ${rules.length}`);

  // ── 0. Ordini a fornitore che iniziano domani → push a responsabili acquisti ──
  if (VAPID_PUB && VAPID_PRIV) {
    const { data: campagneOrdini } = await db
      .from("campagne_commerciali")
      .select("id, titolo, tipologia, data_inizio_ordini, pdv_data")
      .eq("data_inizio_ordini", tomorrowStr);

    for (const c of campagneOrdini ?? []) {
      const { data: respAcquisti } = await db
        .from("operatori")
        .select("id")
        .eq("is_resp_acquisti", true)
        .eq("attivo", true);

      const respIds = (respAcquisti ?? []).map((r: { id: string }) => r.id);
      if (!respIds.length) { log.push(`[ordini] no resp_acquisti`); continue; }

      const { data: subs } = await db
        .from("push_subscriptions")
        .select("operatore_id, endpoint, subscription")
        .in("operatore_id", respIds);
      if (!subs?.length) { log.push(`[ordini] no subs for resp_acquisti`); continue; }

      const payload = {
        title: `Ordini fornitore domani`,
        body:  `Campagna "${c.titolo}"${c.tipologia ? " (" + c.tipologia + ")" : ""}: inizio ordini domani.`,
        url:   "/pages/calendario/index.html",
      };
      const r = await sendPushBatch(db, subs, payload, vapid, log);
      push_sent += r.sent; push_failed += r.failed;
      log.push(`[ordini] ${c.titolo}: ${r.sent} push`);
    }
  }

  if (soloOrdini) {
    return new Response(
      JSON.stringify({ push_sent, push_failed, email_sent, log }),
      { headers: { "Content-Type": "application/json" } },
    );
  }

  // ── Elabora campagne per ogni regola con quando_tipo='giorni' ────────────────
  const rulesGiorni = rules.filter(r => r.quando_tipo === "giorni" && r.giorni_anticipo != null);
  const rulesOggi   = rules.filter(r => r.quando_tipo === "giorno_stesso");

  // Raccogli tutte le date target necessarie (es. +1, +3, ...)
  const giorniSet = new Set<number>(rulesGiorni.map(r => r.giorni_anticipo!));

  for (const giorni of giorniSet) {
    const targetDate = new Date(today);
    targetDate.setDate(today.getDate() + giorni);
    const targetStr = fmtDate(targetDate);

    const { data: campagneTarget } = await db
      .from("campagne_commerciali")
      .select("id, titolo, tipologia, settore, data_inizio, pdv_data")
      .eq("data_inizio", targetStr);

    for (const c of campagneTarget ?? []) {
      const pdvData = (c.pdv_data ?? {}) as Record<string, { aderisce?: boolean }>;

      for (const [pdv, emporio] of Object.entries(PDV_TO_EMPORIO)) {
        if (!pdvData[pdv]?.aderisce) continue;
        const pdvLabel = PDV_LABELS[pdv] ?? pdv;

        // Tutte le regole con questo giorni_anticipo
        const matchingRules = rulesGiorni.filter(r => r.giorni_anticipo === giorni);

        for (const rule of matchingRules) {
          if (rule.canale === "push" || rule.canale === "entrambi" || !rule.canale) {
            if (VAPID_PUB && VAPID_PRIV) {
              const r = await sendCampagnaPush(db, vapid, rule, c, emporio, pdvLabel, giorni, log);
              push_sent += r.sent; push_failed += r.failed;
            }
          }
          if (rule.canale === "email" || rule.canale === "entrambi") {
            const n = await sendCampagnaEmail(db, rule, c, emporio, pdvLabel, giorni, log);
            email_sent += n;
          }
        }
      }
    }
  }

  // ── Campagne che iniziano oggi ────────────────────────────────────────────────
  if (rulesOggi.length) {
    const { data: campagneOggi } = await db
      .from("campagne_commerciali")
      .select("id, titolo, tipologia, settore, data_inizio, pdv_data")
      .eq("data_inizio", todayStr);

    for (const c of campagneOggi ?? []) {
      const pdvData = (c.pdv_data ?? {}) as Record<string, { aderisce?: boolean }>;

      for (const [pdv, emporio] of Object.entries(PDV_TO_EMPORIO)) {
        if (!pdvData[pdv]?.aderisce) continue;
        const pdvLabel = PDV_LABELS[pdv] ?? pdv;

        for (const rule of rulesOggi) {
          if (rule.canale === "push" || rule.canale === "entrambi" || !rule.canale) {
            if (VAPID_PUB && VAPID_PRIV) {
              const r = await sendCampagnaPush(db, vapid, rule, c, emporio, pdvLabel, 0, log);
              push_sent += r.sent; push_failed += r.failed;
            }
          }
          if (rule.canale === "email" || rule.canale === "entrambi") {
            const n = await sendCampagnaEmail(db, rule, c, emporio, pdvLabel, 0, log);
            email_sent += n;
          }
        }
      }
    }
  }

  return new Response(
    JSON.stringify({ push_sent, push_failed, email_sent, log }),
    { headers: { "Content-Type": "application/json" } },
  );
});
