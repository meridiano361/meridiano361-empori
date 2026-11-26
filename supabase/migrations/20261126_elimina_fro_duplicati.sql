-- Elimina i 586 prodotti FRO rimasti in frontalini_catalogo
-- che hanno già un corrispondente in prodotti_catalogo (stesso codice)
DELETE FROM frontalini_catalogo f
WHERE f.codice IS NOT NULL
  AND EXISTS (
    SELECT 1 FROM prodotti_catalogo p WHERE p.codice = f.codice
  );
