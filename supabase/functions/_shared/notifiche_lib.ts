// deno-lint-ignore-file no-explicit-any
import webpush from "npm:web-push@3";

// ── Types ────────────────────────────────────────────────────────────────────

export type NotificaRule = {
  id: string;
  nome: string | null;
  descrizione: string | null;
  attiva: boolean;
  canale: string | null;         // 'push' | 'email' | 'entrambi'
  destinatari: string | null;    // CSV
  evento: string | null;
  giorni_anticipo: number | null;
  quando_tipo: string | null;    // 'giorni' | 'giorno_stesso' | 'arrivo' | 'settimana' | 'ora_turno' | 'periodico'
  giorno_settimana: string | null; // 'lunedi' | 'martedi' | ... | 'domenica'
  ora_invio: string | null;      // 'HH:MM'
};

export type PushSub = {
  operatore_id: string | null;
  endpoint: string;
  subscription: any;
};

export type VapidConfig = {
  pub: string;
  priv: string;
  subject: string;
};

// ── italyNow ─────────────────────────────────────────────────────────────────

export function italyNow(): {
  year: number; month: number; day: number; hour: number; weekday: number;
} {
  const now = new Date();
  const p = new Intl.DateTimeFormat("it-IT", {
    timeZone: "Europe/Rome",
    year: "numeric", month: "numeric", day: "numeric",
    hour: "2-digit", minute: "2-digit", hour12: false,
    weekday: "long",
  }).formatToParts(now);

  // weekday in it-IT è in italiano (domenica, lunedì, ...)
  // Convertiamo a numero: 0=domenica, 1=lunedì, ..., 6=sabato
  const weekdayStr = (p.find(x => x.type === "weekday")?.value ?? "").toLowerCase();
  const weekdayMap: Record<string, number> = {
    "domenica": 0, "lunedì": 1, "martedì": 2, "mercoledì": 3,
    "giovedì": 4, "venerdì": 5, "sabato": 6,
  };
  const weekday = weekdayMap[weekdayStr] ?? new Date().getDay();

  return {
    year:  parseInt(p.find(x => x.type === "year")!.value,  10),
    month: parseInt(p.find(x => x.type === "month")!.value, 10),
    day:   parseInt(p.find(x => x.type === "day")!.value,   10),
    hour:  parseInt(p.find(x => x.type === "hour")!.value,  10),
    weekday,
  };
}

// ── matchesWeekly ─────────────────────────────────────────────────────────────

export function matchesWeekly(
  rule: NotificaRule,
  italyHour: number,
  italyWeekday: number,
): boolean {
  // Se entrambi i campi sono null → sempre esegui
  if (rule.giorno_settimana == null && rule.ora_invio == null) return true;

  const giornoMap: Record<string, number> = {
    lunedi: 1, martedi: 2, mercoledi: 3, giovedi: 4, venerdi: 5, sabato: 6, domenica: 0,
  };

  // Normalizza: rimuovi accenti
  const normalizeGiorno = (s: string) =>
    s.toLowerCase()
      .replace(/à/g, "a").replace(/è/g, "e").replace(/é/g, "e")
      .replace(/ì/g, "i").replace(/ò/g, "o").replace(/ù/g, "u");

  if (rule.giorno_settimana != null) {
    const target = giornoMap[normalizeGiorno(rule.giorno_settimana)];
    if (target == null || target !== italyWeekday) return false;
  }

  if (rule.ora_invio != null) {
    const ruleHour = parseInt(rule.ora_invio.split(":")[0], 10);
    if (ruleHour !== italyHour) return false;
  }

  return true;
}

// ── loadRules ─────────────────────────────────────────────────────────────────

export async function loadRules(db: any, evento: string): Promise<NotificaRule[]> {
  const { data, error } = await db
    .from("notifiche_config")
    .select("id, nome, descrizione, attiva, canale, destinatari, evento, giorni_anticipo, quando_tipo, giorno_settimana, ora_invio")
    .eq("evento", evento)
    .eq("attiva", true);

  if (error) {
    console.error(`loadRules error for evento=${evento}:`, error.message);
    return [];
  }
  return (data ?? []) as NotificaRule[];
}

// ── resolveOperatorIds ────────────────────────────────────────────────────────

export async function resolveOperatorIds(
  db: any,
  destinatari: string,
  context?: { emporio?: string; settore?: string },
): Promise<string[]> {
  const tokens = destinatari.split(",").map(t => t.trim()).filter(Boolean);
  const ids = new Set<string>();

  for (const token of tokens) {
    if (!token) continue;

    // Token email: cerca per email
    if (token.includes("@")) {
      const { data } = await db
        .from("operatori")
        .select("id")
        .ilike("email", token)
        .eq("attivo", true);
      for (const r of data ?? []) ids.add(r.id);
      continue;
    }

    // Gruppi predefiniti
    if (token === "Tutti gli operatori") {
      const { data } = await db.from("operatori").select("id").eq("attivo", true);
      for (const r of data ?? []) ids.add(r.id);
      continue;
    }

    if (token === "Responsabili acquisti") {
      const { data } = await db.from("operatori").select("id").eq("is_resp_acquisti", true).eq("attivo", true);
      for (const r of data ?? []) ids.add(r.id);
      continue;
    }

    if (token === "Responsabile emporio") {
      const { data } = await db.from("operatori").select("id").eq("is_resp_emporio", true).eq("attivo", true);
      for (const r of data ?? []) ids.add(r.id);
      continue;
    }

    if (token === "Referenti alimentari") {
      const { data } = await db.from("operatori").select("id").eq("referente_alimentari", true).eq("attivo", true);
      for (const r of data ?? []) ids.add(r.id);
      continue;
    }

    if (token === "Referenti casa") {
      const { data } = await db.from("operatori").select("id").eq("referente_casa", true).eq("attivo", true);
      for (const r of data ?? []) ids.add(r.id);
      continue;
    }

    if (token === "Referenti moda") {
      const { data } = await db.from("operatori").select("id").eq("referente_moda", true).eq("attivo", true);
      for (const r of data ?? []) ids.add(r.id);
      continue;
    }

    if (token === "Referenti cosmesi") {
      const { data } = await db.from("operatori").select("id").eq("referente_cosmesi", true).eq("attivo", true);
      for (const r of data ?? []) ids.add(r.id);
      continue;
    }

    if (token === "Referente del settore della campagna") {
      const settoreMap: Record<string, string> = {
        A: "referente_alimentari",
        C: "referente_casa",
        M: "referente_moda",
        N: "referente_cosmesi",
      };
      const settore = context?.settore ?? "";
      const colonna = settoreMap[settore.toUpperCase()];
      if (colonna) {
        const qb = db.from("operatori").select("id").eq(colonna, true).eq("attivo", true);
        const { data } = await qb;
        for (const r of data ?? []) ids.add(r.id);
      }
      continue;
    }

    if (token === "Operatori degli empori aderenti") {
      if (context?.emporio) {
        const { data } = await db
          .from("operatori")
          .select("id")
          .ilike("emporio", context.emporio)
          .eq("attivo", true);
        for (const r of data ?? []) ids.add(r.id);
      }
      continue;
    }

    // Altrimenti: cerca per nome (case-insensitive, partial match)
    const { data } = await db
      .from("operatori")
      .select("id, nome")
      .eq("attivo", true);
    for (const r of data ?? []) {
      if ((r.nome ?? "").toLowerCase().includes(token.toLowerCase())) {
        ids.add(r.id);
      }
    }
  }

  return [...ids];
}

// ── resolveEmails ─────────────────────────────────────────────────────────────

export async function resolveEmails(
  db: any,
  destinatari: string,
  context?: { emporio?: string; settore?: string },
): Promise<string[]> {
  const tokens = destinatari.split(",").map(t => t.trim()).filter(Boolean);
  const emails = new Set<string>();

  for (const token of tokens) {
    if (!token) continue;

    // Token email diretta
    if (token.includes("@")) {
      emails.add(token);
      continue;
    }

    if (token === "Tutti gli operatori") {
      const { data } = await db.from("operatori").select("email").eq("attivo", true).not("email", "is", null);
      for (const r of data ?? []) { if (r.email) emails.add(r.email); }
      continue;
    }

    if (token === "Responsabili acquisti") {
      const { data } = await db.from("operatori").select("email").eq("is_resp_acquisti", true).eq("attivo", true).not("email", "is", null);
      for (const r of data ?? []) { if (r.email) emails.add(r.email); }
      continue;
    }

    if (token === "Responsabile emporio") {
      const { data } = await db.from("operatori").select("email").eq("is_resp_emporio", true).eq("attivo", true).not("email", "is", null);
      for (const r of data ?? []) { if (r.email) emails.add(r.email); }
      continue;
    }

    if (token === "Referenti alimentari") {
      const { data } = await db.from("operatori").select("email").eq("referente_alimentari", true).eq("attivo", true).not("email", "is", null);
      for (const r of data ?? []) { if (r.email) emails.add(r.email); }
      continue;
    }

    if (token === "Referenti casa") {
      const { data } = await db.from("operatori").select("email").eq("referente_casa", true).eq("attivo", true).not("email", "is", null);
      for (const r of data ?? []) { if (r.email) emails.add(r.email); }
      continue;
    }

    if (token === "Referenti moda") {
      const { data } = await db.from("operatori").select("email").eq("referente_moda", true).eq("attivo", true).not("email", "is", null);
      for (const r of data ?? []) { if (r.email) emails.add(r.email); }
      continue;
    }

    if (token === "Referenti cosmesi") {
      const { data } = await db.from("operatori").select("email").eq("referente_cosmesi", true).eq("attivo", true).not("email", "is", null);
      for (const r of data ?? []) { if (r.email) emails.add(r.email); }
      continue;
    }

    if (token === "Referente del settore della campagna") {
      const settoreMap: Record<string, string> = {
        A: "referente_alimentari",
        C: "referente_casa",
        M: "referente_moda",
        N: "referente_cosmesi",
      };
      const settore = context?.settore ?? "";
      const colonna = settoreMap[settore.toUpperCase()];
      if (colonna) {
        const { data } = await db.from("operatori").select("email").eq(colonna, true).eq("attivo", true).not("email", "is", null);
        for (const r of data ?? []) { if (r.email) emails.add(r.email); }
      }
      continue;
    }

    if (token === "Operatori degli empori aderenti") {
      if (context?.emporio) {
        const { data } = await db.from("operatori").select("email").ilike("emporio", context.emporio).eq("attivo", true).not("email", "is", null);
        for (const r of data ?? []) { if (r.email) emails.add(r.email); }
      }
      continue;
    }

    // Cerca per nome
    const { data } = await db.from("operatori").select("email, nome").eq("attivo", true).not("email", "is", null);
    for (const r of data ?? []) {
      if ((r.nome ?? "").toLowerCase().includes(token.toLowerCase()) && r.email) {
        emails.add(r.email);
      }
    }
  }

  return [...emails];
}

// ── getPushSubs ───────────────────────────────────────────────────────────────

export async function getPushSubs(db: any, operatorIds: string[]): Promise<PushSub[]> {
  if (!operatorIds.length) return [];
  const { data } = await db
    .from("push_subscriptions")
    .select("operatore_id, endpoint, subscription")
    .in("operatore_id", operatorIds)
    .not("endpoint", "is", null);
  return (data ?? []) as PushSub[];
}

// ── sendPushBatch ─────────────────────────────────────────────────────────────

export async function sendPushBatch(
  db: any,
  subs: PushSub[],
  payload: object,
  vapid: VapidConfig,
  log: string[],
): Promise<{ sent: number; failed: number }> {
  if (!subs.length || !vapid.pub || !vapid.priv) return { sent: 0, failed: 0 };

  webpush.setVapidDetails(vapid.subject, vapid.pub, vapid.priv);
  const payloadStr = JSON.stringify(payload);

  const results = await Promise.allSettled(
    subs.map(sub =>
      webpush.sendNotification(
        sub.subscription as webpush.PushSubscription,
        payloadStr,
        { urgency: "normal", TTL: 86400 },
      )
    )
  );

  let sent = 0, failed = 0;
  const now = new Date().toISOString();

  for (let i = 0; i < results.length; i++) {
    const r = results[i];
    const sub = subs[i];
    if (r.status === "fulfilled") {
      sent++;
      await db.from("push_subscriptions")
        .update({ last_push_at: now })
        .eq("endpoint", sub.endpoint);
    } else {
      const e = r.reason as { statusCode?: number; message?: string };
      if (e?.statusCode === 404 || e?.statusCode === 410) {
        await db.from("push_subscriptions").delete().eq("endpoint", sub.endpoint);
        log.push(`token rimosso: ${sub.endpoint.slice(0, 60)}`);
      } else {
        failed++;
        log.push(`push_err(${e?.statusCode}): ${(e?.message ?? String(r.reason)).slice(0, 100)}`);
      }
    }
  }

  return { sent, failed };
}

// ── sendEmailViaResend ────────────────────────────────────────────────────────

export async function sendEmailViaResend(
  to: string,
  subject: string,
  html: string,
): Promise<void> {
  const apiKey = Deno.env.get("RESEND_API_KEY");
  if (!apiKey) return;
  try {
    await fetch("https://api.resend.com/emails", {
      method: "POST",
      headers: {
        "Authorization": `Bearer ${apiKey}`,
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        from: "M361 Empori <notifiche@meridiano361.it>",
        to: [to],
        subject,
        html,
      }),
    });
  } catch (_) { /* silently fail */ }
}

// ── resolveAndSend ────────────────────────────────────────────────────────────

export async function resolveAndSend(
  db: any,
  rule: NotificaRule,
  vapid: VapidConfig,
  log: string[],
  payload: { title: string; body: string; url?: string; tag?: string },
  context?: { emporio?: string; settore?: string },
): Promise<{ sent: number; failed: number; emails: number }> {
  const dest = rule.destinatari ?? "Tutti gli operatori";
  const canale = rule.canale ?? "push";

  let sent = 0, failed = 0, emails = 0;

  // Push
  if (canale === "push" || canale === "entrambi") {
    const opIds = await resolveOperatorIds(db, dest, context);
    log.push(`[${rule.id}] push→ ${opIds.length} operatori`);
    if (opIds.length) {
      const subs = await getPushSubs(db, opIds);
      const r = await sendPushBatch(db, subs, payload, vapid, log);
      sent += r.sent;
      failed += r.failed;
    }
  }

  // Email
  if (canale === "email" || canale === "entrambi") {
    const emailList = await resolveEmails(db, dest, context);
    log.push(`[${rule.id}] email→ ${emailList.length} indirizzi`);
    for (const addr of emailList) {
      await sendEmailViaResend(addr, payload.title, `<p>${payload.body}</p>`);
      emails++;
    }
  }

  return { sent, failed, emails };
}
