import { createClient } from "jsr:@supabase/supabase-js@2";
import {
  italyNow,
  loadRules,
  matchesWeekly,
  resolveAndSend,
  type VapidConfig,
} from "../_shared/notifiche_lib.ts";

const CORS = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") return new Response(null, { headers: CORS });

  const VAPID_PUB  = Deno.env.get("VAPID_PUBLIC_KEY")  ?? "";
  const VAPID_PRIV = Deno.env.get("VAPID_PRIVATE_KEY") ?? "";
  const VAPID_SUB  = Deno.env.get("VAPID_SUBJECT")     ?? "mailto:info@meridiano361.it";

  const vapid: VapidConfig = { pub: VAPID_PUB, priv: VAPID_PRIV, subject: VAPID_SUB };

  const db = createClient(
    Deno.env.get("SUPABASE_URL")!,
    Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
  );

  const log: string[] = [];
  const { hour, weekday, year } = italyNow();

  // Calcola settimana ISO corrente
  const now = new Date();
  const isoWeek = (() => {
    const d = new Date(now); d.setHours(12, 0, 0, 0);
    d.setDate(d.getDate() + 3 - (d.getDay() + 6) % 7);
    const w1 = new Date(d.getFullYear(), 0, 4);
    return 1 + Math.round(((d.getTime() - w1.getTime()) / 86400000 - 3 + (w1.getDay() + 6) % 7) / 7);
  })();

  log.push(`italyNow: hour=${hour} weekday=${weekday} year=${year} isoWeek=${isoWeek}`);

  const rules = await loadRules(db, "pezzi");
  log.push(`Regole trovate: ${rules.length}`);

  const results = { push_sent: 0, push_failed: 0, emails: 0, rules_matched: 0, log };

  for (const rule of rules) {
    if (rule.quando_tipo !== "settimana") {
      log.push(`[${rule.id}] skipped: quando_tipo=${rule.quando_tipo}`);
      continue;
    }

    if (!matchesWeekly(rule, hour, weekday)) {
      log.push(`[${rule.id}] no match: giorno_settimana=${rule.giorno_settimana} ora_invio=${rule.ora_invio}`);
      continue;
    }

    results.rules_matched++;
    log.push(`[${rule.id}] MATCH`);

    const titolo = rule.nome ?? "Compilazione settimanale";
    const corpo  = rule.descrizione ?? `Inserisci i pezzi e il venduto della settimana ${isoWeek} in Commerciale → Settimanale.`;

    // Inserisci notifica in-app
    await db.from("notifiche").insert({
      titolo,
      testo: corpo,
      target: "tutti",
      mittente: "sistema",
    });

    const r = await resolveAndSend(db, rule, vapid, log, {
      title: titolo,
      body: corpo,
      url: "/pages/cassa/cassa.html",
      tag: `m361-pezzi-w${isoWeek}-${year}`,
    });

    results.push_sent   += r.sent;
    results.push_failed += r.failed;
    results.emails      += r.emails;
  }

  return new Response(JSON.stringify({ ok: true, isoWeek, ...results }), {
    headers: { "Content-Type": "application/json", ...CORS },
  });
});
