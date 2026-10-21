import { createClient } from "jsr:@supabase/supabase-js@2";
import { italyNow } from "../_shared/notifiche_lib.ts";

const CORS = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

function formatPhone(tel: string): string {
  const clean = tel.replace(/\s+/g, "").replace(/^00/, "+");
  if (clean.startsWith("+")) return clean;
  if (/^3\d{8,9}$/.test(clean)) return `+39${clean}`;
  return `+${clean}`;
}

async function sendWaTemplate(
  phoneNumberId: string,
  accessToken: string,
  to: string,
  templateName: string,
  langCode: string,
  nomeCliente: string,
): Promise<{ ok: boolean; msgId?: string; error?: string }> {
  const res = await fetch(`https://graph.facebook.com/v19.0/${phoneNumberId}/messages`, {
    method: "POST",
    headers: {
      "Authorization": `Bearer ${accessToken}`,
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      messaging_product: "whatsapp",
      to,
      type: "template",
      template: {
        name: templateName,
        language: { code: langCode },
        components: [{
          type: "body",
          parameters: [{ type: "text", text: nomeCliente }],
        }],
      },
    }),
  });

  const data = await res.json();
  if (!res.ok) {
    return { ok: false, error: data?.error?.message ?? `HTTP ${res.status}` };
  }
  return { ok: true, msgId: data?.messages?.[0]?.id };
}

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") return new Response(null, { headers: CORS });

  const WA_PHONE_ID = Deno.env.get("WA_PHONE_NUMBER_ID") ?? "";
  const WA_TOKEN    = Deno.env.get("WA_ACCESS_TOKEN")    ?? "";
  const WA_TPL_STD  = Deno.env.get("WA_TEMPLATE_COMPLEANNO")     ?? "m361_auguri_compleanno";
  const WA_TPL_AMB  = Deno.env.get("WA_TEMPLATE_COMPLEANNO_AMB") ?? "m361_auguri_ambassador";
  const WA_LANG     = Deno.env.get("WA_TEMPLATE_LANG")   ?? "it";

  const urlObj = new URL(req.url);
  const dryrun = urlObj.searchParams.get("dryrun") === "1";
  const force  = dryrun || urlObj.searchParams.get("force") === "1";

  const { hour, day, month, year } = italyNow();

  if (!force && hour !== 9) {
    return new Response(
      JSON.stringify({ skipped: true, reason: `ora italiana: ${hour}h (non le 9:00)` }),
      { headers: { "Content-Type": "application/json", ...CORS } },
    );
  }

  if (!WA_PHONE_ID || !WA_TOKEN) {
    return new Response(
      JSON.stringify({ error: "WA_PHONE_NUMBER_ID o WA_ACCESS_TOKEN mancanti — configurare i secrets Supabase" }),
      { status: 500, headers: { "Content-Type": "application/json", ...CORS } },
    );
  }

  const db = createClient(
    Deno.env.get("SUPABASE_URL")!,
    Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
  );

  const log: string[] = [];

  // Clienti con compleanno oggi e numero di telefono
  const { data: clientiRaw, error: bdErr } = await db
    .from("clienti")
    .select("id, nome, cognome, data_nascita, telefono")
    .not("data_nascita", "is", null)
    .not("telefono", "is", null);

  if (bdErr) {
    return new Response(
      JSON.stringify({ error: bdErr.message }),
      { status: 500, headers: { "Content-Type": "application/json", ...CORS } },
    );
  }

  type Cliente = { id: number; nome: string; cognome: string | null; data_nascita: string; telefono: string };

  const oggiCompleanno = ((clientiRaw ?? []) as Cliente[]).filter((c) => {
    const d = new Date(c.data_nascita);
    return d.getDate() === day && (d.getMonth() + 1) === month;
  });

  if (!oggiCompleanno.length) {
    return new Response(
      JSON.stringify({ skipped: true, reason: "nessun compleanno oggi", date: `${day}/${month}` }),
      { headers: { "Content-Type": "application/json", ...CORS } },
    );
  }

  // Evita duplicati: salta chi ha già ricevuto il WA quest'anno
  const clienteIds = oggiCompleanno.map((c) => c.id);
  const { data: waLogRaw } = await db
    .from("birthday_wa_log")
    .select("cliente_id")
    .in("cliente_id", clienteIds)
    .eq("anno", year);

  const giàInviati = new Set(((waLogRaw ?? []) as { cliente_id: number }[]).map((r) => String(r.cliente_id)));
  const daInviare = oggiCompleanno.filter((c) => !giàInviati.has(String(c.id)));

  log.push(`Compleanni oggi: ${oggiCompleanno.length} | Già inviati: ${giàInviati.size} | Da inviare: ${daInviare.length}`);

  if (!daInviare.length) {
    return new Response(
      JSON.stringify({ skipped: true, reason: "WA già inviato a tutti con compleanno oggi", date: `${day}/${month}`, log }),
      { headers: { "Content-Type": "application/json", ...CORS } },
    );
  }

  // Tipo tessera (standard vs ambassador)
  const { data: tessereRows } = await db
    .from("tessere")
    .select("cliente_id, tipo")
    .in("cliente_id", daInviare.map((c) => c.id));

  const tipoMap = new Map<string, string>(
    ((tessereRows ?? []) as { cliente_id: number; tipo: string }[]).map((t) => [String(t.cliente_id), t.tipo])
  );

  const results = {
    sent: 0, failed: 0,
    dryrun,
    date: `${day}/${month}`,
    log,
    dettagli: [] as { nome: string; esito: string; errore?: string }[],
  };

  for (const c of daInviare) {
    const nomeCompleto = `${(c.nome || "").trim()} ${(c.cognome || "").trim()}`.trim();
    const nomeTemplate = (c.nome || c.cognome || "").trim();
    const tipo = tipoMap.get(String(c.id)) ?? "standard";
    const template = tipo === "ambassador" ? WA_TPL_AMB : WA_TPL_STD;
    const tel = formatPhone(c.telefono);

    if (dryrun) {
      results.sent++;
      results.dettagli.push({ nome: nomeCompleto, esito: "dryrun" });
      log.push(`DRYRUN: ${nomeCompleto} → ${tel} (${template})`);
      await db.from("birthday_wa_log").upsert({
        cliente_id: c.id, anno: year,
        data_invio: new Date().toISOString(),
        telefono: tel, template, esito: "dryrun",
      }, { onConflict: "cliente_id,anno" });
      continue;
    }

    const waResult = await sendWaTemplate(WA_PHONE_ID, WA_TOKEN, tel, template, WA_LANG, nomeTemplate);

    if (waResult.ok) {
      results.sent++;
      results.dettagli.push({ nome: nomeCompleto, esito: "ok" });
      log.push(`OK: ${nomeCompleto} → ${tel} (msgId: ${waResult.msgId})`);
    } else {
      results.failed++;
      results.dettagli.push({ nome: nomeCompleto, esito: "errore", errore: waResult.error });
      log.push(`ERRORE: ${nomeCompleto} → ${tel}: ${waResult.error}`);
    }

    await db.from("birthday_wa_log").upsert({
      cliente_id: c.id, anno: year,
      data_invio: new Date().toISOString(),
      telefono: tel, template,
      wa_msg_id: waResult.msgId ?? null,
      esito: waResult.ok ? "ok" : "errore",
      errore_msg: waResult.error ?? null,
    }, { onConflict: "cliente_id,anno" });
  }

  return new Response(JSON.stringify(results, null, 2), {
    headers: { "Content-Type": "application/json", ...CORS },
  });
});
