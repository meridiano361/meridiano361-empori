-- Aggiunge colonna in_prova alla tabella operatori.
-- Un operatore "in prova" è registrato solo per i turni, senza account Supabase Auth.
ALTER TABLE operatori ADD COLUMN IF NOT EXISTS in_prova boolean DEFAULT false;
