-- Tabella note per responsabili acquisti: una nota per campagna × emporio
CREATE TABLE IF NOT EXISTS preordini_note_resp (
  id            UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  campagna_id   UUID        NOT NULL REFERENCES preordini_campagne(id) ON DELETE CASCADE,
  emporio_codice TEXT       NOT NULL,
  testo         TEXT,
  updated_at    TIMESTAMPTZ DEFAULT now(),
  UNIQUE(campagna_id, emporio_codice)
);

ALTER TABLE preordini_note_resp ENABLE ROW LEVEL SECURITY;

CREATE POLICY "note_resp_all"
  ON preordini_note_resp FOR ALL TO anon, authenticated
  USING (true) WITH CHECK (true);

GRANT SELECT, INSERT, UPDATE, DELETE ON preordini_note_resp TO anon;
