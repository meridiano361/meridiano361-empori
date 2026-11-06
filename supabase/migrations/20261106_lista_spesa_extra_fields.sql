-- Campi aggiuntivi per lista_spesa_voci: codice, fornitore, lotto, links
ALTER TABLE lista_spesa_voci
  ADD COLUMN IF NOT EXISTS codice    text,
  ADD COLUMN IF NOT EXISTS fornitore text,
  ADD COLUMN IF NOT EXISTS lotto     text,
  ADD COLUMN IF NOT EXISTS links     text[];
