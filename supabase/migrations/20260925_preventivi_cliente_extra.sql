-- Dati aggiuntivi cliente per preventivi azienda/no profit
-- Contiene: indirizzo, email[], pec[], telefono, cellulare[], partita_iva, codice_fiscale, codice_univoco
ALTER TABLE preventivi
  ADD COLUMN IF NOT EXISTS cliente_extra JSONB;
