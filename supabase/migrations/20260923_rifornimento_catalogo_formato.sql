-- Aggiunge quantità e unità di misura al catalogo (es. 500 g, 1 kg, 750 ml)
ALTER TABLE rifornimento_catalogo ADD COLUMN IF NOT EXISTS quantita  NUMERIC;
ALTER TABLE rifornimento_catalogo ADD COLUMN IF NOT EXISTS unita_misura TEXT;
