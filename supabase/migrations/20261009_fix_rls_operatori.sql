-- Disabilita RLS su operatori: l'app usa anon key (custom login), non Supabase Auth.
-- auth.uid() è sempre NULL → la policy authenticated-only blocca tutti i SELECT.
ALTER TABLE operatori DISABLE ROW LEVEL SECURITY;
