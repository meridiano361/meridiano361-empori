-- Rimuove duplicati da prodotti_catalogo mantenendo il record con id minore
-- per ogni gruppo (codice, descrizione)
DELETE FROM public.prodotti_catalogo
WHERE id NOT IN (
  SELECT MIN(id)
  FROM public.prodotti_catalogo
  GROUP BY COALESCE(codice, ''), UPPER(TRIM(descrizione))
);

-- Aggiunge vincolo unique per prevenire futuri duplicati
-- (su descrizione, che è sempre valorizzata)
CREATE UNIQUE INDEX IF NOT EXISTS prodotti_catalogo_descrizione_unique
  ON public.prodotti_catalogo (UPPER(TRIM(descrizione)));
