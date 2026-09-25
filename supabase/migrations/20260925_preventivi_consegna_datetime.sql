-- Data e ora opzionali per ritiro/spedizione preventivo
ALTER TABLE preventivi
  ADD COLUMN IF NOT EXISTS consegna_data DATE,
  ADD COLUMN IF NOT EXISTS consegna_ora  TIME;
