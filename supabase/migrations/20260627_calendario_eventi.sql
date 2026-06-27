CREATE TABLE IF NOT EXISTS calendario_eventi (
  id          bigserial PRIMARY KEY,
  titolo      text NOT NULL,
  data        date NOT NULL,
  data_fine   date,
  categoria   text NOT NULL DEFAULT 'altro',
  colore      text NOT NULL DEFAULT '#3b82f6',
  note        text,
  created_at  timestamptz DEFAULT now()
);

ALTER TABLE calendario_eventi ENABLE ROW LEVEL SECURITY;

CREATE POLICY "allow_all_authenticated_calendario" ON calendario_eventi
  FOR ALL TO authenticated USING (true) WITH CHECK (true);

GRANT SELECT, INSERT, UPDATE, DELETE ON calendario_eventi TO authenticated;
GRANT USAGE, SELECT ON SEQUENCE calendario_eventi_id_seq TO authenticated;
