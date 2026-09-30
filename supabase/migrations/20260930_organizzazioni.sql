-- Organizzazioni di appartenenza degli empori
CREATE TABLE IF NOT EXISTS organizzazioni (
  id      UUID    DEFAULT gen_random_uuid() PRIMARY KEY,
  codice  TEXT    NOT NULL UNIQUE,
  nome    TEXT    NOT NULL,
  colore  TEXT    NOT NULL DEFAULT '#1e293b',
  ordine  INT     NOT NULL DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE organizzazioni ENABLE ROW LEVEL SECURITY;
CREATE POLICY "org_read"   ON organizzazioni FOR SELECT TO authenticated USING (true);
CREATE POLICY "org_write"  ON organizzazioni FOR ALL   TO authenticated USING (true) WITH CHECK (true);

-- Configurazione master degli empori
CREATE TABLE IF NOT EXISTS empori_config (
  id               UUID    DEFAULT gen_random_uuid() PRIMARY KEY,
  codice           TEXT    NOT NULL UNIQUE,   -- 'cremona', 'mantova', 'mantova_d', …
  nome             TEXT    NOT NULL,
  nome_breve       TEXT,
  organizzazione_id UUID   REFERENCES organizzazioni(id),
  colore           TEXT    DEFAULT '#64748b',
  codice_demetra   TEXT,
  ordine           INT     NOT NULL DEFAULT 0,
  attivo           BOOLEAN NOT NULL DEFAULT true,
  created_at       TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE empori_config ENABLE ROW LEVEL SECURITY;
CREATE POLICY "emp_conf_read"  ON empori_config FOR SELECT TO authenticated USING (true);
CREATE POLICY "emp_conf_write" ON empori_config FOR ALL   TO authenticated USING (true) WITH CHECK (true);

-- Seed organizzazioni
INSERT INTO organizzazioni (codice, nome, colore, ordine) VALUES
  ('meridiano361', 'MERIDIANO361', '#1e293b', 0),
  ('mappamondo',   'Mappamondo',   '#1d4ed8', 1)
ON CONFLICT (codice) DO NOTHING;

-- Seed empori
INSERT INTO empori_config (codice, nome, nome_breve, organizzazione_id, colore, codice_demetra, ordine) VALUES
  ('cremona',       'Cremona',       'CR',  (SELECT id FROM organizzazioni WHERE codice='meridiano361'), '#B5453A', '410721', 0),
  ('casalmaggiore', 'Casalmaggiore', 'CA',  (SELECT id FROM organizzazioni WHERE codice='meridiano361'), '#D97706', '410722', 1),
  ('viadana',       'Viadana',       'VI',  (SELECT id FROM organizzazioni WHERE codice='meridiano361'), '#2563EB', '410723', 2),
  ('reggioemilia',  'Reggio Emilia', 'RE',  (SELECT id FROM organizzazioni WHERE codice='meridiano361'), '#7C3AED', '410701', 3),
  ('mantova',       'Mantova U.',    'MNU', (SELECT id FROM organizzazioni WHERE codice='mappamondo'),   '#0891b2', NULL,     4),
  ('mantova_d',     'Mantova D.',    'MND', (SELECT id FROM organizzazioni WHERE codice='mappamondo'),   '#0e7490', NULL,     5)
ON CONFLICT (codice) DO UPDATE SET
  nome             = EXCLUDED.nome,
  nome_breve       = EXCLUDED.nome_breve,
  organizzazione_id = EXCLUDED.organizzazione_id,
  colore           = EXCLUDED.colore,
  codice_demetra   = EXCLUDED.codice_demetra,
  ordine           = EXCLUDED.ordine;
