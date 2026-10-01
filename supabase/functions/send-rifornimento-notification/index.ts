import webpush from "npm:web-push@3";
import { createClient } from "jsr:@supabase/supabase-js@2";

const CORS = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

type Body = {
  proposta_id: number;
  tipo: "nuova" | "modificata" | "evasa";
  nota_evasione?: string;
};

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") return new Response(null, { headers: CORS });

  const db = createClient(
    Deno.env.get("SUPABASE_URL")!,
    Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
  );

  let body: Body;
  try { body = await req.json(); }
  catch { return new Response(JSON.stringify({ error: "invalid json" }), { status: 400, headers: CORS }); }

  const { proposta_id, tipo, nota_evasione = "" } = body;

  const { data: prop } = await db
    .from("rifornimento_proposte")
    .select("*")
    .eq("id", proposta_id)
    .single();

  if (!prop) {
    return new Response(JSON.stringify({ error: "proposta not found" }), { status: 404, headers: CORS });
  }

  // Prodotti compilati + totale stimato
  const { data: righe } = await db
    .from("rifornimento_proposte_righe")
    .select("quantity, catalog_product_id")
    .eq("proposal_id", proposta_id)
    .gt("quantity", 0);

  const nProdotti = righe?.length ?? 0;
  let totale = 0;

  if (righe?.length) {
    const catIds = righe.filter(r => r.catalog_product_id).map(r => r.catalog_product_id);
    if (catIds.length) {
      const { data: catProds } = await db
        .from("rifornimento_catalogo")
        .select("id, pvp")
        .in("id", catIds);
      const priceMap = new Map((catProds ?? []).map(p => [p.id, p.pvp]));
      righe.forEach(r => {
        const pvp = priceMap.get(r.catalog_product_id);
        if (pvp && r.quantity) totale += pvp * r.quantity;
      });
    }
  }

  const fmtEuro = (n: number) => `€${n.toFixed(2).replace(".", ",")}`;
  const fmtDt   = (iso: string) => new Date(iso).toLocaleString("it-IT", { day: "2-digit", month: "2-digit", year: "numeric", hour: "2-digit", minute: "2-digit" });
  const APP_URL  = "https://meridiano361-empori.vercel.app";
  const propUrl  = `${APP_URL}/pages/rifornimento/proposta.html?id=${proposta_id}`;

  const results = { push_sent: 0, push_failed: 0, email_sent: false, errors: [] as string[] };

  // ── Helper push ─────────────────────────────────────────────────────────
  async function sendPush(operatoreIds: number[], titolo: string, testo: string) {
    const VAPID_PUB  = Deno.env.get("VAPID_PUBLIC_KEY")  ?? "";
    const VAPID_PRIV = Deno.env.get("VAPID_PRIVATE_KEY") ?? "";
    const VAPID_SUB  = Deno.env.get("VAPID_SUBJECT")     ?? "mailto:info@meridiano361.it";
    if (!VAPID_PUB || !VAPID_PRIV) return;
    webpush.setVapidDetails(VAPID_SUB, VAPID_PUB, VAPID_PRIV);
    const { data: subs } = await db
      .from("push_subscriptions")
      .select("endpoint, subscription")
      .in("operatore_id", operatoreIds);
    for (const sub of subs ?? []) {
      try {
        await webpush.sendNotification(sub.subscription, JSON.stringify({ title: titolo, body: testo, url: propUrl }), { urgency: "high", TTL: 86400 });
        results.push_sent++;
      } catch (e: unknown) {
        const status = (e as { statusCode?: number })?.statusCode;
        if (status === 404 || status === 410) {
          await db.from("push_subscriptions").delete().eq("endpoint", sub.endpoint);
        } else {
          results.push_failed++;
        }
      }
    }
  }

  // ── Helper email ─────────────────────────────────────────────────────────
  async function sendEmail(to: string, subject: string, html: string) {
    const apiKey = Deno.env.get("RESEND_API_KEY");
    if (!apiKey) return;
    try {
      await fetch("https://api.resend.com/emails", {
        method: "POST",
        headers: { "Authorization": `Bearer ${apiKey}`, "Content-Type": "application/json" },
        body: JSON.stringify({ from: "M361 Empori <notifiche@meridiano361.it>", to: [to], subject, html }),
      });
      results.email_sent = true;
    } catch (_) { /* ignora */ }
  }

  // ── nuova / modificata → notifica a Emilio ──────────────────────────────
  if (tipo === "nuova" || tipo === "modificata") {
    const tipoLabel = tipo === "nuova" ? "Nuova proposta" : "Proposta aggiornata";
    const titolo    = `${tipoLabel} — ${prop.emporio}`;
    const testo     = `${prop.created_by} · ${nProdotti} prodotti · Totale stimato ${fmtEuro(totale)} · v${prop.versione}`;

    // Notifica in-app
    await db.from("notifiche").insert({ titolo, testo, target: "tutti", mittente: prop.created_by || prop.emporio });

    // Push a Emilio
    const EMILIO_EMAIL = "e.mazzolari@meridiano361.it";
    const { data: emilioOp } = await db.from("operatori").select("id").eq("email", EMILIO_EMAIL).single();
    if (emilioOp) await sendPush([emilioOp.id], titolo, testo);

    // Email a Emilio
    await sendEmail(
      "e.mazzolari@meridiano361.it",
      titolo,
      emailHtmlCoordinatore(prop, nProdotti, totale, propUrl, tipo, fmtEuro, fmtDt),
    );

    // Log
    await db.from("rifornimento_notif_log").insert([
      { proposta_id, versione: prop.versione, tipo: "push",  evento: tipo, destinatario: "emilio", stato: results.push_sent > 0 ? "sent" : "skipped" },
      { proposta_id, versione: prop.versione, tipo: "email", evento: tipo, destinatario: "e.mazzolari@meridiano361.it", stato: results.email_sent ? "sent" : "skipped" },
    ]);
  }

  // ── evasa → notifica ai responsabili ────────────────────────────────────
  if (tipo === "evasa") {
    const titolo = `Ordine evaso — ${prop.emporio}`;
    const noteStr = nota_evasione ? ` · Note: ${nota_evasione}` : "";
    const testo  = `Il tuo ordine è stato caricato su Amshop${noteStr}`;

    // Push ai responsabili autorizzati
    const { data: autorizzati } = await db
      .from("rifornimento_autorizzati")
      .select("operatore_id")
      .eq("emporio", prop.emporio);

    const opIds = (autorizzati ?? []).map((a: { operatore_id: number }) => a.operatore_id);
    if (opIds.length) await sendPush(opIds, titolo, testo);

    // Email ai responsabili
    if (opIds.length) {
      const { data: ops } = await db.from("operatori").select("email").in("id", opIds);
      for (const op of ops ?? []) {
        if (op.email) {
          await sendEmail(op.email, titolo, emailHtmlResponsabile(prop, nota_evasione, propUrl, fmtDt));
        }
      }
    }

    // Log
    await db.from("rifornimento_notif_log").insert({
      proposta_id, versione: prop.versione, tipo: "email", evento: "evasa",
      destinatario: "responsabili", stato: results.email_sent ? "sent" : "skipped",
    });
  }

  return new Response(JSON.stringify(results), { headers: { "Content-Type": "application/json", ...CORS } });
});

// ── Template email coordinatore ──────────────────────────────────────────────
function emailHtmlCoordinatore(
  prop: Record<string, unknown>, nProdotti: number, totale: number,
  url: string, tipo: string,
  fmtEuro: (n: number) => string, fmtDt: (s: string) => string,
): string {
  const tipoLabel = tipo === "nuova" ? "Nuova proposta di rifornimento" : "Proposta aggiornata";
  const dataInvio = prop.submitted_at ? fmtDt(prop.submitted_at as string) : "—";
  return `<div style="font-family:sans-serif;max-width:520px;margin:0 auto">
    <div style="background:#1e293b;color:#fff;padding:20px;border-radius:12px 12px 0 0">
      <h2 style="margin:0;font-size:18px">${tipoLabel}</h2>
      <p style="margin:4px 0 0;opacity:.7;font-size:13px">${prop.emporio}</p>
    </div>
    <div style="padding:20px;background:#fff;border:1px solid #e2e8f0;border-top:none;border-radius:0 0 12px 12px">
      <table style="width:100%;border-collapse:collapse;margin-bottom:16px">
        <tr><td style="padding:6px 0;color:#64748b;font-size:13px">Responsabile</td><td style="font-weight:700">${prop.created_by || "—"}</td></tr>
        <tr><td style="padding:6px 0;color:#64748b;font-size:13px">Data invio</td><td style="font-weight:700">${dataInvio}</td></tr>
        <tr><td style="padding:6px 0;color:#64748b;font-size:13px">Versione</td><td style="font-weight:700">v${prop.versione}</td></tr>
        <tr><td style="padding:6px 0;color:#64748b;font-size:13px">Prodotti compilati</td><td style="font-weight:700">${nProdotti}</td></tr>
        <tr><td style="padding:6px 0;color:#64748b;font-size:13px">Totale stimato</td><td style="font-weight:800;font-size:16px;color:#d97706">${fmtEuro(totale)}</td></tr>
      </table>
      <a href="${url}" style="display:block;background:#d97706;color:#fff;text-align:center;padding:12px;border-radius:10px;font-weight:700;text-decoration:none;font-size:14px">Apri proposta →</a>
    </div>
  </div>`;
}

// ── Template email responsabile (evasa) ──────────────────────────────────────
function emailHtmlResponsabile(
  prop: Record<string, unknown>, note: string, url: string,
  fmtDt: (s: string) => string,
): string {
  const dataEvasione = prop.evasa_at ? fmtDt(prop.evasa_at as string) : "—";
  return `<div style="font-family:sans-serif;max-width:520px;margin:0 auto">
    <div style="background:#16a34a;color:#fff;padding:20px;border-radius:12px 12px 0 0">
      <h2 style="margin:0;font-size:18px">Ordine caricato su Amshop ✓</h2>
      <p style="margin:4px 0 0;opacity:.8;font-size:13px">Emporio ${prop.emporio}</p>
    </div>
    <div style="padding:20px;background:#fff;border:1px solid #e2e8f0;border-top:none;border-radius:0 0 12px 12px">
      <p style="font-size:14px;color:#1e293b">Il tuo ordine di rifornimento (v${prop.versione}) è stato caricato su Amshop il <strong>${dataEvasione}</strong> da <strong>Emilio Mazzolari</strong>.</p>
      ${note ? `<div style="background:#f0fdf4;border:1px solid #bbf7d0;border-radius:8px;padding:12px;margin:12px 0">
        <p style="margin:0;font-size:13px;color:#166534;font-weight:600">Note dal coordinatore:</p>
        <p style="margin:6px 0 0;font-size:13px;color:#14532d">${note.replace(/\n/g, "<br>")}</p>
      </div>` : ""}
      <a href="${url}" style="display:block;background:#16a34a;color:#fff;text-align:center;padding:12px;border-radius:10px;font-weight:700;text-decoration:none;font-size:14px;margin-top:16px">Vedi proposta →</a>
    </div>
  </div>`;
}
