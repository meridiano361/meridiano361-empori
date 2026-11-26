-- Migrazione prodotti da frontalini_catalogo → prodotti_catalogo
-- Situazione analizzata:
--   - SALSA TAHINA, SOMMACCO, SUGO ALLA PUTTANESCA: già presenti in PRO (codice HUB*)
--   - 30 null-codice: già tutti presenti in PRO per descrizione
--   - SFERE FONDENTI E PISTACCHIO (6841): unico mancante → lo inseriamo

-- Step 1: inserisci solo SFERE FONDENTI E PISTACCHIO (l'unico davvero mancante in PRO)
INSERT INTO prodotti_catalogo
  (codice, descrizione, prezzo, fornitore, marchio, bio, senza_glutine, vegano,
   solidale_italiano, note, iva, foto_url, pack_size, category, peso, unita, active, source_sheet)
SELECT
  f.codice, f.descrizione, f.prezzo, f.fornitore, f.marchio, f.bio, f.senza_glutine, f.vegano,
  f.solidale_italiano, f.note, f.iva, f.foto_url, f.pack_size, f.category, f.peso, f.unita,
  true, 'Frontalini'
FROM frontalini_catalogo f
WHERE f.codice = '6841';

-- Step 2: elimina i 4 orfani con codice (tutti già presenti in PRO o appena inseriti)
DELETE FROM frontalini_catalogo
WHERE codice IN ('6841', '180BIO', 'VA3313', 'VA3314');

-- Step 3: elimina i 30 senza codice (già tutti presenti in PRO per descrizione)
DELETE FROM frontalini_catalogo
WHERE codice IS NULL;
