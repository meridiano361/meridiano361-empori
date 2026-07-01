-- Fix: disabilita RLS su campagne_commerciali e concede accesso ad anon.
-- Il client Supabase usa la chiave anon (non Supabase Auth), quindi la
-- policy FOR authenticated non copriva le chiamate reali dell'app.
-- Coerente con prodotti_scadenza e le altre tabelle del progetto.

ALTER TABLE campagne_commerciali DISABLE ROW LEVEL SECURITY;
GRANT ALL ON campagne_commerciali TO anon, authenticated;
GRANT USAGE, SELECT ON SEQUENCE campagne_commerciali_id_seq TO anon;
