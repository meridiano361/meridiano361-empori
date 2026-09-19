-- Aggiunge canale di prenotazione e stato pagamento alla tabella prenotazioni
ALTER TABLE prenotazioni
  ADD COLUMN IF NOT EXISTS canale TEXT,
  ADD COLUMN IF NOT EXISTS pagato BOOLEAN NOT NULL DEFAULT false;

GRANT UPDATE (canale, pagato) ON prenotazioni TO anon;
