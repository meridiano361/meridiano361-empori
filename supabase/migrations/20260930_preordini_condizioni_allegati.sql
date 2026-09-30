-- Condizioni commerciali note sul preordine
ALTER TABLE preordini_campagne
  ADD COLUMN IF NOT EXISTS note_commerciali TEXT;

-- Allegati per preordine (file caricati su Storage bucket 'preordini-allegati')
CREATE TABLE IF NOT EXISTS preordini_allegati (
  id            UUID        DEFAULT gen_random_uuid() PRIMARY KEY,
  campagna_id   UUID        NOT NULL,
  nome          TEXT        NOT NULL,
  url           TEXT        NOT NULL,
  storage_path  TEXT,
  tipo_mime     TEXT,
  dimensione    BIGINT,
  created_at    TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE preordini_allegati ENABLE ROW LEVEL SECURITY;

CREATE POLICY "allegati_read"
  ON preordini_allegati FOR SELECT TO authenticated USING (true);

CREATE POLICY "allegati_insert"
  ON preordini_allegati FOR INSERT TO authenticated WITH CHECK (true);

CREATE POLICY "allegati_delete"
  ON preordini_allegati FOR DELETE TO authenticated USING (true);

-- NOTA: creare manualmente il bucket 'preordini-allegati' in Supabase Dashboard
-- Storage > New bucket > nome: preordini-allegati > Public bucket: SI
