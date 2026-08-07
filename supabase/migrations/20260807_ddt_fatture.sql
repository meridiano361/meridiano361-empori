-- DDT / Fatture emesse e pagate in giornata
CREATE TABLE IF NOT EXISTS cassa_ddt_fatture (
  id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  chiave           TEXT NOT NULL,
  emporio          TEXT NOT NULL,
  tipo             TEXT NOT NULL DEFAULT 'ddt' CHECK (tipo IN ('ddt','fattura')),
  numero           TEXT,
  ragione_sociale  TEXT NOT NULL,
  forma_pagamento  TEXT NOT NULL,
  importo          NUMERIC(10,2),
  created_at       TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE cassa_ddt_fatture ENABLE ROW LEVEL SECURITY;
CREATE POLICY "auth read ddt"  ON cassa_ddt_fatture FOR SELECT TO authenticated USING (true);
CREATE POLICY "auth write ddt" ON cassa_ddt_fatture FOR ALL    TO authenticated USING (true) WITH CHECK (true);
