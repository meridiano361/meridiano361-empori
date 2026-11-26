-- Svuota rifornimento_catalogo: tutti i 209 prodotti sono già in prodotti_catalogo
-- (200 per codice identico, 9 orfani già presenti per descrizione)
DELETE FROM rifornimento_catalogo;
