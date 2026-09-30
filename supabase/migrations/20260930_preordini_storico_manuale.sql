CREATE TABLE IF NOT EXISTS preordini_storico_manuale (
  codice           TEXT     NOT NULL,
  emporio_codice   TEXT     NOT NULL,
  anno             SMALLINT NOT NULL,
  acquistato       INT,
  venduto          INT,
  updated_at       TIMESTAMPTZ DEFAULT NOW(),
  PRIMARY KEY (codice, emporio_codice, anno)
);

ALTER TABLE preordini_storico_manuale ENABLE ROW LEVEL SECURITY;

CREATE POLICY "storico_manuale_read"
  ON preordini_storico_manuale FOR SELECT TO authenticated USING (true);

CREATE POLICY "storico_manuale_write"
  ON preordini_storico_manuale FOR ALL TO authenticated USING (true) WITH CHECK (true);
