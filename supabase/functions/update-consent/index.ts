import { createClient } from "jsr:@supabase/supabase-js@2";

const CORS = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Methods": "GET, POST, OPTIONS",
  "Access-Control-Allow-Headers": "Content-Type, Authorization",
  "Content-Type": "application/json",
};

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") return new Response(null, { headers: CORS });

  const db = createClient(
    Deno.env.get("SUPABASE_URL")!,
    Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
  );

  // GET ?t=TOKEN → restituisce info cliente (per mostrare il nome nella pagina)
  if (req.method === "GET") {
    const url = new URL(req.url);
    const token = url.searchParams.get("t");
    if (!token) return new Response(JSON.stringify({ error: "Token mancante" }), { status: 400, headers: CORS });

    const { data, error } = await db
      .from("clienti")
      .select("id, nome, cognome, data_nascita, citta, email, telefono, emporio, consenso_privacy, consenso_privacy_data")
      .eq("consent_token", token)
      .single();

    if (error || !data) return new Response(JSON.stringify({ error: "Link non valido" }), { status: 404, headers: CORS });

    return new Response(JSON.stringify({
      nome: data.nome,
      cognome: data.cognome,
      data_nascita: data.data_nascita,
      citta: data.citta,
      email: data.email,
      telefono: data.telefono,
      emporio: data.emporio,
      consenso_privacy: data.consenso_privacy,
      consenso_privacy_data: data.consenso_privacy_data,
    }), { headers: CORS });
  }

  // POST { token } → registra il consenso
  if (req.method === "POST") {
    const { token } = await req.json().catch(() => ({})) as { token?: string };
    if (!token) return new Response(JSON.stringify({ error: "Token mancante" }), { status: 400, headers: CORS });

    const { data: existing, error: findErr } = await db
      .from("clienti")
      .select("id, nome, cognome, consenso_privacy")
      .eq("consent_token", token)
      .single();

    if (findErr || !existing) return new Response(JSON.stringify({ error: "Link non valido" }), { status: 404, headers: CORS });

    if (existing.consenso_privacy) {
      return new Response(JSON.stringify({ ok: true, already: true, nome: existing.nome }), { headers: CORS });
    }

    const { error: updErr } = await db
      .from("clienti")
      .update({
        consenso_privacy: true,
        consenso_privacy_modalita: "online",
        consenso_privacy_data: new Date().toISOString(),
      })
      .eq("consent_token", token);

    if (updErr) return new Response(JSON.stringify({ error: "Errore aggiornamento" }), { status: 500, headers: CORS });

    return new Response(JSON.stringify({ ok: true, already: false, nome: existing.nome }), { headers: CORS });
  }

  return new Response(JSON.stringify({ error: "Method not allowed" }), { status: 405, headers: CORS });
});
