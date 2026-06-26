-- Aggiunge il campo "cliente" (nome + cognome univoco) alla tabella clienti
ALTER TABLE clienti ADD COLUMN IF NOT EXISTS cliente text;
