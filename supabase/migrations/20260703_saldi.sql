-- Sezione Saldi: prodotti importati da CSV/XLSX con periodi di sconto.

CREATE TABLE IF NOT EXISTS saldi_prodotti (
  id            BIGSERIAL PRIMARY KEY,
  emporio       TEXT NOT NULL,
  codice        TEXT,
  nome_prodotto TEXT NOT NULL,
  qta           INTEGER NOT NULL DEFAULT 0,
  prezzo        NUMERIC(10,2) NOT NULL DEFAULT 0,
  created_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS saldi_periodi (
  id           BIGSERIAL PRIMARY KEY,
  prodotto_id  BIGINT NOT NULL REFERENCES saldi_prodotti(id) ON DELETE CASCADE,
  data_inizio  DATE NOT NULL,
  data_fine    DATE NOT NULL,
  sconto_pct   NUMERIC(5,2) NOT NULL CHECK (sconto_pct > 0 AND sconto_pct <= 100),
  created_at   TIMESTAMPTZ NOT NULL DEFAULT now(),
  CONSTRAINT periodi_date_check CHECK (data_fine >= data_inizio)
);

CREATE INDEX IF NOT EXISTS saldi_prodotti_emporio_idx ON saldi_prodotti(emporio);
CREATE INDEX IF NOT EXISTS saldi_periodi_prodotto_idx ON saldi_periodi(prodotto_id);

GRANT ALL ON saldi_prodotti TO anon;
GRANT ALL ON saldi_periodi  TO anon;
GRANT USAGE, SELECT ON SEQUENCE saldi_prodotti_id_seq TO anon;
GRANT USAGE, SELECT ON SEQUENCE saldi_periodi_id_seq  TO anon;

NOTIFY pgrst, 'reload schema';
