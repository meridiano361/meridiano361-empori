-- operatori: disabilita RLS e garantisce accesso completo.
-- L'autenticazione è gestita lato client (Supabase Auth + localStorage).
-- RLS su questa tabella causa login failure ("Accesso negato") perché
-- la SELECT post-auth ritorna 0 righe se non esiste una policy SELECT.

ALTER TABLE public.operatori DISABLE ROW LEVEL SECURITY;

GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE public.operatori TO anon, authenticated;

NOTIFY pgrst, 'reload schema';
