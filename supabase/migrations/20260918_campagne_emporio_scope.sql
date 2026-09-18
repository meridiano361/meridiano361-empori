-- Aggiunge colonna per definire l'ambito dell'evento:
-- NULL = tutti gli empori, altrimenti nome dell'emporio specifico (es. 'Cremona')
ALTER TABLE campagne_commerciali ADD COLUMN IF NOT EXISTS emporio_scope TEXT;
