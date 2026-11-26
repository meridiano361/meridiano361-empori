ALTER TABLE ordini_incorso    ADD COLUMN IF NOT EXISTS modifiche_log jsonb NOT NULL DEFAULT '[]'::jsonb;
ALTER TABLE ordini_archiviati ADD COLUMN IF NOT EXISTS modifiche_log jsonb NOT NULL DEFAULT '[]'::jsonb;
