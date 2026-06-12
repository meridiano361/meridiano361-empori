import { createClient } from "jsr:@supabase/supabase-js@2";

const CORS = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") return new Response(null, { headers: CORS });

  let body: { email?: string };
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

  const { data, error } = await db.auth.admin.inviteUserByEmail(email, {
    redirectTo: Deno.env.get("APP_URL") ?? "https://meridiano361-empori.vercel.app",
  });

  if (error) {
    return new Response(JSON.stringify({ error: error.message }), { status: 400, headers: CORS });
  }

  return new Response(JSON.stringify({ ok: true, user_id: data.user?.id }), {
    headers: { "Content-Type": "application/json", ...CORS },
  });
});
