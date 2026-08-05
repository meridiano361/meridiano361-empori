-- Il client usa la chiave anon (non Supabase Auth), quindi le policy
-- FOR authenticated non coprono le chiamate reali dell'app.
-- Stesso pattern di campagne_commerciali_rls_fix.

ALTER TABLE campagne_prenotazione DISABLE ROW LEVEL SECURITY;
GRANT ALL ON campagne_prenotazione TO anon, authenticated;

ALTER TABLE prenotazioni DISABLE ROW LEVEL SECURITY;
GRANT ALL ON prenotazioni TO anon, authenticated;
GRANT USAGE, SELECT ON SEQUENCE prenotazioni_id_seq TO anon, authenticated;
