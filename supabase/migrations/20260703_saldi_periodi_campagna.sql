-- Periodi di saldo a livello campagna (date valide per tutti i prodotti)
CREATE TABLE IF NOT EXISTS saldi_campagna_periodi (
  id          SERIAL PRIMARY KEY,
  campagna_id INTEGER NOT NULL REFERENCES saldi_campagne(id) ON DELETE CASCADE,
  numero      INTEGER NOT NULL,
  data_inizio DATE,
  data_fine   DATE,
  UNIQUE(campagna_id, numero)
);
ALTER TABLE saldi_campagna_periodi ENABLE ROW LEVEL SECURITY;
CREATE POLICY "saldi_campagna_periodi anon" ON saldi_campagna_periodi
  FOR ALL TO anon USING (true) WITH CHECK (true);

-- Sconto per prodotto × periodo campagna
CREATE TABLE IF NOT EXISTS saldi_sconti (
  id                  SERIAL PRIMARY KEY,
  prodotto_id         INTEGER NOT NULL REFERENCES saldi_prodotti(id) ON DELETE CASCADE,
  campagna_periodo_id INTEGER NOT NULL REFERENCES saldi_campagna_periodi(id) ON DELETE CASCADE,
  sconto_pct          NUMERIC(5,2) NOT NULL DEFAULT 0,
  UNIQUE(prodotto_id, campagna_periodo_id)
);
ALTER TABLE saldi_sconti ENABLE ROW LEVEL SECURITY;
CREATE POLICY "saldi_sconti anon" ON saldi_sconti
  FOR ALL TO anon USING (true) WITH CHECK (true);
