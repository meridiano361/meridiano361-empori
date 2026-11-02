import { createClient } from "jsr:@supabase/supabase-js@2";

const CORS = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") return new Response(null, { headers: CORS });

  let body: { email: string };
  try { body = await req.json(); }
  catch { return new Response(JSON.stringify({ error: "invalid json" }), { status: 400, headers: CORS }); }

  const { email } = body;
  if (!email) {
    return new Response(JSON.stringify({ error: "email mancante" }), { status: 400, headers: CORS });
  }

  const db = createClient(
    Deno.env.get("SUPABASE_URL")!,
    Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
  );

  // Verifica che l'email esista tra gli operatori attivi
  const { data: op } = await db
    .from("operatori")
    .select("id")
    .ilike("email", email)
    .single();

  if (!op) {
    // Risposta vaga per non rivelare se l'email esiste o meno
    return new Response(JSON.stringify({ ok: true }), {
      headers: { "Content-Type": "application/json", ...CORS },
    });
  }

  // generateLink con service role bypassa il rate limit email di Supabase
  const { error } = await db.auth.admin.generateLink({
    type: "recovery",
    email,
    options: {
      redirectTo: "https://meridiano361-empori.vercel.app/login.html",
    },
  });

  if (error) {
    return new Response(JSON.stringify({ error: error.message }), {
      status: 400,
      headers: { "Content-Type": "application/json", ...CORS },
    });
  }

  return new Response(JSON.stringify({ ok: true }), {
    headers: { "Content-Type": "application/json", ...CORS },
  });
});
