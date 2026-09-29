CREATE TABLE IF NOT EXISTS preordini_foto (
  codice   TEXT        NOT NULL PRIMARY KEY,
  data_b64 TEXT        NOT NULL,
  pos_x    SMALLINT    NOT NULL DEFAULT 50,
  pos_y    SMALLINT    NOT NULL DEFAULT 50,
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE preordini_foto ENABLE ROW LEVEL SECURITY;

CREATE POLICY "preordini_foto_select"
  ON preordini_foto FOR SELECT TO authenticated USING (true);

CREATE POLICY "preordini_foto_all"
  ON preordini_foto FOR ALL TO authenticated USING (true) WITH CHECK (true);
