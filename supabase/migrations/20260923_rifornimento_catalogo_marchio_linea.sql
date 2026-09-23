-- Aggiunge marchio e linea al catalogo rifornimento
ALTER TABLE rifornimento_catalogo ADD COLUMN IF NOT EXISTS marchio TEXT;
ALTER TABLE rifornimento_catalogo ADD COLUMN IF NOT EXISTS linea   TEXT;
