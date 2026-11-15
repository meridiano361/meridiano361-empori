-- Aggiunge sort_order e sito_url a prodotti_catalogo
-- Necessari per compatibilità con la pagina catalogo fornitura (ora unificata)

ALTER TABLE public.prodotti_catalogo
  ADD COLUMN IF NOT EXISTS sort_order  INT  NOT NULL DEFAULT 0,
  ADD COLUMN IF NOT EXISTS sito_url    TEXT;
