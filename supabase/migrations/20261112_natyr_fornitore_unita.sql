-- Tutti i prodotti con marchio Natyr (case-insensitive):
-- fornitore = 'Altromercato', unita = 'ml'

UPDATE public.frontalini_catalogo
SET
  fornitore = 'Altromercato',
  unita     = 'ml'
WHERE LOWER(marchio) = 'natyr';
