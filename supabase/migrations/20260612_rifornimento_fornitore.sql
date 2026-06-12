-- Aggiunge colonna fornitore al catalogo e popola dai dati esistenti
ALTER TABLE rifornimento_catalogo ADD COLUMN IF NOT EXISTS fornitore TEXT NOT NULL DEFAULT '';

UPDATE rifornimento_catalogo SET fornitore = 'Altromercato' WHERE source_sheet = 'ALI AM' AND fornitore = '';
UPDATE rifornimento_catalogo SET fornitore = 'Libera Terra'  WHERE source_sheet = 'ALI LT' AND fornitore = '';
UPDATE rifornimento_catalogo SET fornitore = 'Hub VR'        WHERE source_sheet = 'ALI VR' AND fornitore = '';
UPDATE rifornimento_catalogo SET fornitore = 'Hub VA'        WHERE source_sheet = 'ALI VA' AND fornitore = '';
