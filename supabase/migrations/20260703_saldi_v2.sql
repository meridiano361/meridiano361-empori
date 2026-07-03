-- Saldi v2: tabelle campagne + flag prezzato (negozio / online / non presente online)

CREATE TABLE IF NOT EXISTS saldi_campagne (
  id         BIGSERIAL PRIMARY KEY,
  emporio    TEXT NOT NULL,
  nome       TEXT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

ALTER TABLE saldi_prodotti ADD COLUMN IF NOT EXISTS campagna_id        BIGINT  REFERENCES saldi_campagne(id) ON DELETE CASCADE;
ALTER TABLE saldi_prodotti ADD COLUMN IF NOT EXISTS prezzato_negozio   BOOLEAN NOT NULL DEFAULT false;
ALTER TABLE saldi_prodotti ADD COLUMN IF NOT EXISTS prezzato_online     BOOLEAN NOT NULL DEFAULT false;
ALTER TABLE saldi_prodotti ADD COLUMN IF NOT EXISTS non_presente_online BOOLEAN NOT NULL DEFAULT false;

CREATE INDEX IF NOT EXISTS saldi_campagne_emporio_idx ON saldi_campagne(emporio);

GRANT ALL ON saldi_campagne TO anon;
GRANT USAGE, SELECT ON SEQUENCE saldi_campagne_id_seq TO anon;

-- Crea campagna di default per gli empori che hanno già prodotti
INSERT INTO saldi_campagne (emporio, nome)
SELECT DISTINCT emporio, 'Saldi'
FROM saldi_prodotti
WHERE emporio IS NOT NULL AND emporio != '';

-- Assegna i prodotti esistenti alla loro campagna di default
UPDATE saldi_prodotti p
SET campagna_id = c.id
FROM saldi_campagne c
WHERE c.emporio = p.emporio AND p.campagna_id IS NULL;

NOTIFY pgrst, 'reload schema';
