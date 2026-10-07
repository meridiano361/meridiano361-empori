import webpush from "npm:web-push@3";
import { createClient } from "jsr:@supabase/supabase-js@2";
import {
  italyNow,
  loadRules,
  resolveAndSend,
  type VapidConfig,
} from "../_shared/notifiche_lib.ts";

const CORS = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

// Fallback hardcoded destinatari (usato se nessuna regola attiva)
const DESTINATARI_FALLBACK = ["Emilio Mazzolari", "Chiara Monteverdi"];

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") return new Response(null, { headers: CORS });

  const VAPID_PUB  = Deno.env.get("VAPID_PUBLIC_KEY")  ?? "";
  const VAPID_PRIV = Deno.env.get("VAPID_PRIVATE_KEY") ?? "";
  const VAPID_SUB  = Deno.env.get("VAPID_SUBJECT")     ?? "mailto:info@meridiano361.it";

  const vapid: VapidConfig = { pub: VAPID_PUB, priv: VAPID_PRIV, subject: VAPID_SUB };

  const urlObj  = new URL(req.url);
  const dryrun  = urlObj.searchParams.get("dryrun") === "1";
  const force   = dryrun || urlObj.searchParams.get("force") === "1";

  const { hour, day, month } = italyNow();

  if (!force && hour !== 9) {
    return new Response(
      JSON.stringify({ skipped: true, reason: `ora italiana: ${hour}h (non le 9:00)` }),
      { headers: { "Content-Type": "application/json", ...CORS } },
    );
  }

  const db = createClient(
    Deno.env.get("SUPABASE_URL")!,
    Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
  );

  const log: string[] = [];

  // Clienti che compiono gli anni oggi
  const { data: clientiBirthday, error: bdErr } = await db
    .from("clienti")
    .select("id, nome, cognome, data_nascita")
    .not("data_nascita", "is", null);

  if (bdErr) {
    return new Response(JSON.stringify({ error: bdErr.message }), { status: 500, headers: { "Content-Type": "application/json", ...CORS } });
  }

  const oggiCompleanni = (clientiBirthday ?? []).filter((c: { data_nascita: string }) => {
    const d = new Date(c.data_nascita);
    return d.getDate() === day && (d.getMonth() + 1) === month;
  });

  if (!oggiCompleanni.length) {
    return new Response(
      JSON.stringify({ skipped: true, reason: "nessun compleanno oggi", date: `${day}/${month}` }),
      { headers: { "Content-Type": "application/json", ...CORS } },
    );
  }

  // Recupera tipo tessera per ogni cliente
  const clienteIds = oggiCompleanni.map((c: { id: unknown }) => c.id);
  const { data: tessereRows } = await db
    .from("tessere")
    .select("cliente_id, tipo")
    .in("cliente_id", clienteIds);

  const tipoMap = new Map<number, string>(
    (tessereRows ?? []).map((t: { cliente_id: number; tipo: string }) => [t.cliente_id as number, t.tipo as string])
  );

  const nCompleanni = oggiCompleanni.length;
  const nomi = oggiCompleanni.map((c: { cognome?: string; nome: string }) =>
    `${c.cognome ?? ""} ${c.nome}`.trim()
  ).join(", ");

  const results = {
    sent: 0, failed: 0, emails: 0,
    compleanni: oggiCompleanni.map((c: { cognome?: string; nome: string }) => `${c.cognome ?? ""} ${c.nome}`.trim()),
    dryrun,
    date: `${day}/${month}`,
    log,
  };

  // Carica regole
  const rules = await loadRules(db, "compleanni");
  log.push(`Regole trovate: ${rules.length}`);

  const activeRules = rules.filter(r => r.quando_tipo === "giorno_stesso" || r.quando_tipo == null);

  if (activeRules.length > 0) {
    // Usa le regole configurate: un invio per cliente (titolo/corpo con sostituzioni)
    for (const rule of activeRules) {
      for (const c of oggiCompleanni) {
        const tipo = tipoMap.get(c.id) ?? "standard";
        const nomeCompleto = `${c.cognome ?? ""} ${c.nome}`.trim();
        let corpo = (rule.descrizione ?? "Compleanno di {nomi} oggi!")
          .replace(/\{n\}/g, String(nCompleanni))
          .replace(/\{nomi\}/g, nomeCompleto);

        if (tipo === "ambassador") {
          corpo += " ★ Ambassador — ricorda il 10% di sconto nel mese del compleanno.";
        }

        const titolo = (rule.nome ?? "M361 — Compleanno cliente")
          .replace(/\{n\}/g, String(nCompleanni))
          .replace(/\{nomi\}/g, nomeCompleto);

        if (!dryrun) {
          const r = await resolveAndSend(db, rule, vapid, log, {
            title: titolo,
            body: corpo,
            url: "/pages/tessere/index.html",
            tag: `m361-bday-${c.id}-${day}-${month}`,
          });
          results.sent    += r.sent;
          results.failed  += r.failed;
          results.emails  += r.emails;
        } else {
          results.sent++;
        }
      }
    }
  } else {
    // FALLBACK: comportamento hardcoded originale
    log.push("Nessuna regola attiva — uso fallback hardcoded");

    if (!VAPID_PUB || !VAPID_PRIV) {
      return new Response(JSON.stringify({ error: "VAPID keys mancanti" }), { status: 500, headers: { "Content-Type": "application/json", ...CORS } });
    }

    const { data: subsRaw } = await db
      .from("push_subscriptions")
      .select("operatore_nome, endpoint, subscription")
      .in("operatore_nome", DESTINATARI_FALLBACK);

    const subs = subsRaw ?? [];

    if (!subs.length) {
      return new Response(
        JSON.stringify({ skipped: true, reason: "nessuna subscription per i destinatari fallback" }),
        { headers: { "Content-Type": "application/json", ...CORS } },
      );
    }

    webpush.setVapidDetails(VAPID_SUB, VAPID_PUB, VAPID_PRIV);

    for (const c of oggiCompleanni) {
      const tipo = tipoMap.get(c.id) ?? "standard";
      const nomeCompleto = `${c.cognome ?? ""} ${c.nome}`.trim();

      let body = `Compleanno di ${nomeCompleto} oggi!`;
      if (tipo === "ambassador") body += " ★ Ambassador — ricorda il 10% di sconto nel mese del compleanno.";

      const payload = JSON.stringify({
        title: "M361 — Compleanno cliente",
        body,
        url: "/pages/tessere/index.html",
        tag: `m361-bday-${c.id}-${day}-${month}`,
      });

      if (!dryrun) {
        const sends = await Promise.allSettled(
          subs.map((sub: { subscription: unknown }) =>
            webpush.sendNotification(sub.subscription as webpush.PushSubscription, payload, { urgency: "normal", TTL: 86400 })
          )
        );
        sends.forEach((r, i) => {
          if (r.status === "fulfilled") {
            results.sent++;
          } else {
            const e = r.reason as { statusCode?: number; message?: string };
            if (e?.statusCode === 404 || e?.statusCode === 410) {
              db.from("push_subscriptions").delete().eq("endpoint", (subs[i] as { endpoint: string }).endpoint);
            } else {
              results.failed++;
              log.push(`${(subs[i] as { operatore_nome: string }).operatore_nome}: ${e?.message?.slice(0, 80)}`);
            }
          }
        });
      } else {
        results.sent += subs.length;
      }
    }
  }

  // Riepilogo: invia un unico push riassuntivo con tutti i nomi (solo se > 1 compleanno e si sono usate le regole)
  if (activeRules.length > 0 && nCompleanni > 1 && !dryrun) {
    log.push(`Riepilogo: ${nCompleanni} compleanni oggi — ${nomi}`);
  }

  return new Response(JSON.stringify({ ...results }, null, 2), {
    headers: { "Content-Type": "application/json", ...CORS },
  });
});
