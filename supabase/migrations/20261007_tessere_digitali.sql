-- Tessere Digitali: token pubblico + saldo sconto + storico movimenti

ALTER TABLE tessere
  ADD COLUMN IF NOT EXISTS token UUID DEFAULT gen_random_uuid(),
  ADD COLUMN IF NOT EXISTS totale_spesa NUMERIC(10,2) DEFAULT 0,
  ADD COLUMN IF NOT EXISTS saldo_sconto NUMERIC(10,2) DEFAULT 0;

UPDATE tessere SET token = gen_random_uuid() WHERE token IS NULL;

CREATE TABLE IF NOT EXISTS movimenti_tessera (
  id BIGSERIAL PRIMARY KEY,
  tessera_id BIGINT NOT NULL REFERENCES tessere(id) ON DELETE CASCADE,
  importo NUMERIC(10,2) NOT NULL,
  timbri_aggiunti INT NOT NULL DEFAULT 0,
  sconto_generato NUMERIC(10,2) DEFAULT 0,
  operatore TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

ALTER TABLE movimenti_tessera ENABLE ROW LEVEL SECURITY;
CREATE POLICY "allow_all_movimenti" ON movimenti_tessera
  FOR ALL TO anon, authenticated USING (true) WITH CHECK (true);
