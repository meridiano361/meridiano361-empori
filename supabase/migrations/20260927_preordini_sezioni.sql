-- Tabella sezioni (es. Pasqua, Natale) per raggruppare le campagne
CREATE TABLE IF NOT EXISTS preordini_sezioni (
  id         uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  nome       text NOT NULL,
  ordine     int  DEFAULT 0,
  created_at timestamptz DEFAULT now()
);

-- Aggiunge sezione_id a preordini_campagne
ALTER TABLE preordini_campagne
  ADD COLUMN IF NOT EXISTS sezione_id uuid REFERENCES preordini_sezioni(id) ON DELETE SET NULL;

-- RLS
ALTER TABLE preordini_sezioni ENABLE ROW LEVEL SECURITY;
DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename='preordini_sezioni' AND policyname='preordini_sezioni_all') THEN
    CREATE POLICY preordini_sezioni_all ON preordini_sezioni FOR ALL TO public USING (true) WITH CHECK (true);
  END IF;
END $$;

-- Sezioni iniziali
INSERT INTO preordini_sezioni (nome, ordine)
SELECT 'Pasqua', 0 WHERE NOT EXISTS (SELECT 1 FROM preordini_sezioni WHERE nome = 'Pasqua');

INSERT INTO preordini_sezioni (nome, ordine)
SELECT 'Natale', 1 WHERE NOT EXISTS (SELECT 1 FROM preordini_sezioni WHERE nome = 'Natale');

-- Collega campagne esistenti alle sezioni
UPDATE preordini_campagne
SET sezione_id = (SELECT id FROM preordini_sezioni WHERE nome = 'Pasqua')
WHERE nome LIKE 'Pasqua%' AND sezione_id IS NULL;

UPDATE preordini_campagne
SET sezione_id = (SELECT id FROM preordini_sezioni WHERE nome = 'Natale')
WHERE nome = 'Natale' AND sezione_id IS NULL;
