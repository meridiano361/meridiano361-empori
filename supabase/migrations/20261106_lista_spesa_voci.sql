-- Tabella voci lista spesa per emporio (testo libero, stile listando.it)
CREATE TABLE IF NOT EXISTS lista_spesa_voci (
  id          bigint generated always as identity primary key,
  emporio     text        not null,
  nome        text        not null,
  quantita    numeric,
  unita       text,
  categoria   text,
  acquisito   boolean     not null default false,
  aggiunto_da text,
  created_at  timestamptz not null default now()
);
CREATE INDEX IF NOT EXISTS idx_lsv_emporio_time ON lista_spesa_voci (emporio, created_at DESC);

ALTER TABLE lista_spesa_voci ENABLE ROW LEVEL SECURITY;
CREATE POLICY "allow_all" ON lista_spesa_voci FOR ALL USING (true) WITH CHECK (true);
