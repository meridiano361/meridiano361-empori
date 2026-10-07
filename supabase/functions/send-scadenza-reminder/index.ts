import webpush from "npm:web-push@3";
import { createClient } from "jsr:@supabase/supabase-js@2";
import {
  loadRules,
  resolveOperatorIds,
  getPushSubs,
  sendPushBatch,
  sendEmailViaResend,
  type NotificaRule,
  type VapidConfig,
} from "../_shared/notifiche_lib.ts";

const CORS = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

type Prodotto = {
  id: string; emporio: string; codice: string | null; descrizione: string;
  quantita: number; scadenza: string; solo_alcuni: boolean; in_promo: boolean;
  sconto_suggerito: number | null;
  notif_30g_at: string | null; notif_14g_at: string | null; notif_1g_at: string | null;
};

function pad(n: number) { return String(n).padStart(2, "0"); }

function todayRome(): { year: number; month: number; day: number; dateStr: string } {
  const now  = new Date();
  const fmt  = new Intl.DateTimeFormat("it-IT", {
    timeZone: "Europe/Rome", year: "numeric", month: "numeric", day: "numeric",
  });
  const p    = fmt.formatToParts(now);
  const year  = parseInt(p.find(x => x.type === "year")!.value, 10);
  const month = parseInt(p.find(x => x.type === "month")!.value, 10);
  const day   = parseInt(p.find(x => x.type === "day")!.value, 10);
  return { year, month, day, dateStr: `${year}-${pad(month)}-${pad(day)}` };
}

function addDays(dateStr: string, n: number): string {
  const d = new Date(dateStr + "T00:00:00");
  d.setDate(d.getDate() + n);
  return `${d.getFullYear()}-${pad(d.getMonth() + 1)}-${pad(d.getDate())}`;
}

function giorniAlla(scadenza: string, todayStr: string): number {
  const t = new Date(todayStr + "T00:00:00");
  const s = new Date(scadenza + "T00:00:00");
  return Math.round((s.getTime() - t.getTime()) / 86400000);
}

function urgenzaLabel(giorni: number): string {
  if (giorni <= 1)  return "domani";
  return `tra ${giorni} giorni`;
}

function buildPushPayload(prodotto: Prodotto, giorni: number): object {
  const sconto = prodotto.sconto_suggerito;
  const body = `${prodotto.descrizione} (${prodotto.quantita} pz) — scade ${urgenzaLabel(giorni)}.` +
    (sconto && sconto > 0 ? ` Sconto consigliato: −${sconto}%.` : "");
  return {
    title: "Prodotto in scadenza — " + prodotto.emporio,
    body,
    url: "/pages/prodotti-scadenza/prodotti-scadenza.html",
    tag: `scad-${prodotto.id}-${giorni}g`,
  };
}

function emailHtml(prodotto: Prodotto, giorni: number): string {
  const sconto = prodotto.sconto_suggerito;
  return `
    <div style="font-family:sans-serif;max-width:480px;margin:0 auto">
      <div style="background:#1e293b;color:#fff;padding:20px;border-radius:12px 12px 0 0">
        <h2 style="margin:0;font-size:18px">Prodotto in scadenza</h2>
        <p style="margin:4px 0 0;opacity:.7;font-size:13px">Emporio ${prodotto.emporio}</p>
      </div>
      <div style="padding:20px;background:#fff;border:1px solid #e2e8f0;border-top:none;border-radius:0 0 12px 12px">
        <p style="font-size:16px;font-weight:700;color:#1e293b">${prodotto.descrizione}</p>
        ${prodotto.codice ? `<p style="color:#64748b;font-size:13px">Codice: ${prodotto.codice}</p>` : ""}
        <table style="width:100%;border-collapse:collapse;margin:12px 0">
          <tr><td style="padding:6px 0;color:#64748b;font-size:13px">Quantità</td><td style="font-weight:700">${prodotto.quantita} pz${prodotto.solo_alcuni ? " (solo alcuni in scadenza)" : ""}</td></tr>
          <tr><td style="padding:6px 0;color:#64748b;font-size:13px">Scadenza</td><td style="font-weight:700;color:#B5453A">${new Date(prodotto.scadenza + "T00:00:00").toLocaleDateString("it-IT", { day: "2-digit", month: "long", year: "numeric" })}</td></tr>
          <tr><td style="padding:6px 0;color:#64748b;font-size:13px">Giorni rimanenti</td><td style="font-weight:700">${giorni}</td></tr>
          ${sconto && sconto > 0 ? `<tr><td style="padding:6px 0;color:#64748b;font-size:13px">Sconto consigliato</td><td style="font-weight:800;color:#B5453A;font-size:16px">−${sconto}%</td></tr>` : ""}
        </table>
        ${prodotto.in_promo ? `<p style="background:#f5f3ff;color:#7c3aed;padding:8px 12px;border-radius:8px;font-size:13px;font-weight:700">Già in promo a scaffale</p>` : ""}
        <a href="https://meridiano361-empori.vercel.app/pages/prodotti-scadenza/prodotti-scadenza.html"
           style="display:inline-block;margin-top:12px;background:#B5453A;color:#fff;padding:10px 18px;border-radius:8px;text-decoration:none;font-weight:700;font-size:13px">
          Vai all'app →
        </a>
      </div>
    </div>
  `;
}

// Mappa giorni → campo notif_at
type NotifField = "notif_30g_at" | "notif_14g_at" | "notif_1g_at";
const DEFAULT_SOGLIE: Array<{ giorni: number; field: NotifField }> = [
  { giorni: 30, field: "notif_30g_at" },
  { giorni: 14, field: "notif_14g_at" },
  { giorni: 1,  field: "notif_1g_at"  },
];

function getFieldForGiorni(g: number): NotifField | null {
  if (g <= 1)  return "notif_1g_at";
  if (g <= 14) return "notif_14g_at";
  if (g <= 30) return "notif_30g_at";
  return null;
}

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") return new Response(null, { headers: CORS });

  const VAPID_PUB  = Deno.env.get("VAPID_PUBLIC_KEY")  ?? "";
  const VAPID_PRIV = Deno.env.get("VAPID_PRIVATE_KEY") ?? "";
  const VAPID_SUB  = Deno.env.get("VAPID_SUBJECT")     ?? "mailto:info@meridiano361.it";

  const vapid: VapidConfig = { pub: VAPID_PUB, priv: VAPID_PRIV, subject: VAPID_SUB };

  const url    = new URL(req.url);
  const dryrun = url.searchParams.get("dryrun") === "1";

  const db = createClient(
    Deno.env.get("SUPABASE_URL")!,
    Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
  );

  const log: string[] = [];
  const { dateStr } = todayRome();

  // Carica regole
  const rules = await loadRules(db, "scadenza_prodotti");
  log.push(`Regole trovate: ${rules.length}`);

  // Determina le soglie di notifica
  let soglieAttive: Array<{ giorni: number; rule: NotificaRule | null }>;

  const rulesGiorni = rules.filter(r => r.quando_tipo === "giorni" && r.giorni_anticipo != null);

  if (rulesGiorni.length > 0) {
    soglieAttive = rulesGiorni.map(r => ({ giorni: r.giorni_anticipo!, rule: r }));
    log.push(`Soglie da regole: ${soglieAttive.map(s => s.giorni).join(", ")} giorni`);
  } else {
    // Fallback ai default
    soglieAttive = DEFAULT_SOGLIE.map(s => ({ giorni: s.giorni, rule: null }));
    log.push("Nessuna regola attiva — uso soglie default (30, 14, 1 giorni)");
  }

  const maxGiorni = Math.max(...soglieAttive.map(s => s.giorni), 30);
  const inMax = addDays(dateStr, maxGiorni);

  // Tutti i prodotti con scadenza entro maxGiorni (non ancora scaduti)
  const { data: prodotti, error: pErr } = await db
    .from("prodotti_scadenza")
    .select("*")
    .gte("scadenza", dateStr)
    .lte("scadenza", inMax);

  if (pErr) {
    return new Response(JSON.stringify({ error: pErr.message }), { status: 500, headers: { "Content-Type": "application/json", ...CORS } });
  }

  if (!prodotti?.length) {
    return new Response(JSON.stringify({ skipped: true, reason: `nessun prodotto in scadenza nei prossimi ${maxGiorni} giorni` }), {
      headers: { "Content-Type": "application/json", ...CORS },
    });
  }

  if (VAPID_PUB && VAPID_PRIV) {
    webpush.setVapidDetails(VAPID_SUB, VAPID_PUB, VAPID_PRIV);
  }

  const results = {
    date: dateStr, prodotti_check: prodotti.length,
    notifiche_inviate: 0, email_inviate: 0, failed: 0, errors: [] as string[], log,
  };

  for (const p of prodotti as Prodotto[]) {
    const giorni = giorniAlla(p.scadenza, dateStr);

    // Determina quali soglie attivano questo prodotto
    const pending: Array<{ giorni: number; field: NotifField; rule: NotificaRule | null }> = [];

    for (const soglia of soglieAttive) {
      if (giorni > soglia.giorni) continue;
      const field = getFieldForGiorni(soglia.giorni);
      if (!field) continue;
      if (p[field]) continue; // già notificato
      pending.push({ giorni: soglia.giorni, field, rule: soglia.rule });
    }

    if (!pending.length) continue;

    const empKey = (p.emporio ?? "").toLowerCase().trim();

    for (const pn of pending) {
      const payload  = buildPushPayload(p, giorni);
      const subject  = `Scadenza prodotto: ${p.descrizione} — Emporio ${p.emporio}`;
      const html     = emailHtml(p, giorni);

      if (pn.rule) {
        // Usa regola configurata
        const opIds = await resolveOperatorIds(db, pn.rule.destinatari ?? "Responsabili acquisti", { emporio: empKey });
        if (opIds.length && (pn.rule.canale === "push" || pn.rule.canale === "entrambi" || !pn.rule.canale)) {
          const subs = await getPushSubs(db, opIds);
          if (!dryrun) {
            const r = await sendPushBatch(db, subs, payload, vapid, log);
            results.notifiche_inviate += r.sent;
            results.failed            += r.failed;
          } else {
            results.notifiche_inviate += opIds.length;
          }
        }
        if (pn.rule.canale === "email" || pn.rule.canale === "entrambi") {
          const emailList = await resolveEmails(db, pn.rule.destinatari ?? "Responsabili acquisti", { emporio: empKey });
          if (!dryrun) {
            for (const addr of emailList) {
              await sendEmailViaResend(addr, subject, html);
              results.email_inviate++;
            }
          } else {
            results.email_inviate += emailList.length;
          }
        }
      } else {
        // Fallback: responsabili acquisti + responsabili emporio per quell'emporio
        const { data: respAcq } = await db.from("operatori")
          .select("nome, email, emporio, id")
          .eq("is_resp_acquisti", true).eq("attivo", true).ilike("emporio", empKey);
        const { data: respEmp } = await db.from("operatori")
          .select("nome, id")
          .eq("is_resp_emporio", true).eq("attivo", true).ilike("emporio", empKey);

        const idSet = new Set<string>();
        for (const op of [...(respAcq ?? []), ...(respEmp ?? [])]) idSet.add(op.id);
        const opIds = [...idSet];

        if (opIds.length && VAPID_PUB && VAPID_PRIV) {
          const subs = await getPushSubs(db, opIds);
          if (!dryrun) {
            const r = await sendPushBatch(db, subs, payload, vapid, log);
            results.notifiche_inviate += r.sent;
            results.failed            += r.failed;
          } else {
            results.notifiche_inviate += opIds.length;
          }
        }

        for (const op of (respAcq ?? []) as Array<{ email?: string }>) {
          if (!op.email) continue;
          if (!dryrun) await sendEmailViaResend(op.email, subject, html);
          results.email_inviate++;
        }
      }

      // Marca notifica come inviata
      if (!dryrun) {
        await db.from("prodotti_scadenza").update({ [pn.field]: new Date().toISOString() }).eq("id", p.id);
      }
    }

    log.push({
      id: p.id, descrizione: p.descrizione, emporio: p.emporio,
      giorni, sconto: p.sconto_suggerito,
      notifiche: pending.map(x => `${x.giorni}g`),
    } as unknown as string);
  }

  return new Response(JSON.stringify({ ...results, dryrun }, null, 2), {
    headers: { "Content-Type": "application/json", ...CORS },
  });
});
