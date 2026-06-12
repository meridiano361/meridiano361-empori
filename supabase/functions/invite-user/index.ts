import { createClient } from "jsr:@supabase/supabase-js@2";

const CORS = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

const DEFAULT_PASSWORD = "123456";

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") return new Response(null, { headers: CORS });

  let body: { email?: string; password?: string };
  try { body = await req.json(); }
  catch { return new Response(JSON.stringify({ error: "invalid json" }), { status: 400, headers: CORS }); }

  const { email, password = DEFAULT_PASSWORD } = body;
  if (!email) {
    return new Response(JSON.stringify({ error: "email mancante" }), { status: 400, headers: CORS });
  }

  const db = createClient(
    Deno.env.get("SUPABASE_URL")!,
    Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
  );

  // Prova a creare l'utente con password diretta (nessuna email richiesta)
  const { data, error } = await db.auth.admin.createUser({
    email,
    password,
    email_confirm: true,
  });

  if (error) {
    // Se l'utente esiste già, aggiorna solo la password
    if (error.message?.toLowerCase().includes("already registered") || error.message?.toLowerCase().includes("already been registered")) {
      const { data: list } = await db.auth.admin.listUsers();
      const existing = list?.users?.find((u) => u.email?.toLowerCase() === email.toLowerCase());
      if (existing) {
        const { error: updateErr } = await db.auth.admin.updateUserById(existing.id, { password });
        if (updateErr) {
          return new Response(JSON.stringify({ error: updateErr.message }), { status: 400, headers: CORS });
        }
        return new Response(JSON.stringify({ ok: true, user_id: existing.id, updated: true }), {
          headers: { "Content-Type": "application/json", ...CORS },
        });
      }
    }
    return new Response(JSON.stringify({ error: error.message }), { status: 400, headers: CORS });
  }

  return new Response(JSON.stringify({ ok: true, user_id: data.user?.id, created: true }), {
    headers: { "Content-Type": "application/json", ...CORS },
  });
});
