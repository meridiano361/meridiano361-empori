-- Cicli completati tessera digitale
-- 1) Rimuove il vincolo timbri_attuali <= 12 (serve overflow temporaneo per il reset manuale)
ALTER TABLE tessere DROP CONSTRAINT IF EXISTS tessere_timbri_attuali_check;
ALTER TABLE tessere ADD CONSTRAINT tessere_timbri_attuali_check CHECK (timbri_attuali >= 0);

-- 2) Aggiunge contatore cicli completati
ALTER TABLE tessere ADD COLUMN IF NOT EXISTS cicli_completati INTEGER NOT NULL DEFAULT 0;
