-- Aggiunge il sottotipo per i preventivi natalizi (privato, azienda, no_profit, altro)
ALTER TABLE preventivi
  ADD COLUMN IF NOT EXISTS sottotipo_natale TEXT;
