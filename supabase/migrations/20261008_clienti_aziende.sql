-- Campi aggiuntivi per clienti azienda
ALTER TABLE clienti ADD COLUMN IF NOT EXISTS indirizzo    TEXT;
ALTER TABLE clienti ADD COLUMN IF NOT EXISTS piva         TEXT;
ALTER TABLE clienti ADD COLUMN IF NOT EXISTS cod_fiscale  TEXT;
ALTER TABLE clienti ADD COLUMN IF NOT EXISTS cod_univoco  TEXT;
ALTER TABLE clienti ADD COLUMN IF NOT EXISTS pec          TEXT;
ALTER TABLE clienti ADD COLUMN IF NOT EXISTS cellulare    TEXT;
-- Multi-contatto (usato anche dall'unione clienti)
ALTER TABLE clienti ADD COLUMN IF NOT EXISTS emails_extra   JSONB DEFAULT '[]';
ALTER TABLE clienti ADD COLUMN IF NOT EXISTS telefoni_extra JSONB DEFAULT '[]';
