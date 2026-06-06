-- ── Permessi tabella turni per utenti autenticati ──────────────────────────
-- L'app usa Supabase Auth (signInWithPassword in login.html).
-- Le richieste dal client avvengono col ruolo 'authenticated'.
-- Questo file garantisce che INSERT/UPDATE/DELETE su turni siano autorizzati.
--
-- Eseguire UNA VOLTA in Supabase SQL Editor.

-- 1. Disabilita RLS se era attiva senza policy (causa "violates row-level security")
--    L'enforcement dei permessi è gestito lato client in turni.html.
ALTER TABLE public.turni DISABLE ROW LEVEL SECURITY;

-- 2. Grants espliciti
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE public.turni TO authenticated;
GRANT SELECT                          ON TABLE public.turni TO anon;

-- 3. Stesse garanzie per le tabelle di lettura usate dai volontari
GRANT SELECT ON TABLE public.operatori      TO authenticated, anon;
GRANT SELECT ON TABLE public.turni_orari    TO authenticated, anon;
GRANT SELECT ON TABLE public.orari_emporio  TO authenticated, anon;

-- 4. Forza reload schema PostgREST
NOTIFY pgrst, 'reload schema';

SELECT 'grants applicati: turni (full), operatori/turni_orari/orari_emporio (select)' AS stato;
