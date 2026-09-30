ALTER TABLE ordini_incorso    ADD COLUMN IF NOT EXISTS note_cliente TEXT;
ALTER TABLE ordini_archiviati ADD COLUMN IF NOT EXISTS note_cliente TEXT;
