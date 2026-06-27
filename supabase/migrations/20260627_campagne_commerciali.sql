-- Rimuove la tabella vecchia (struttura sbagliata) e crea campagne_commerciali
DROP TABLE IF EXISTS calendario_eventi CASCADE;

CREATE TABLE IF NOT EXISTS campagne_commerciali (
  id          bigserial PRIMARY KEY,
  anno        int  NOT NULL DEFAULT 2026,
  titolo      text NOT NULL,
  settore     text DEFAULT 'G',   -- M=Moda, C=Casa, G=Generale, A=Alimentare, N=Natyr
  tipologia   text,               -- Saldi, Promo, Prenotazione, Focus, Evento, Altro
  meccanica   text,
  data_inizio date,
  data_fine   date,
  -- Per ciascun PDV: { aderisce, azioni, r2026, r2025, r2024, r2023 }
  pdv_data    jsonb NOT NULL DEFAULT '{}',
  created_at  timestamptz DEFAULT now()
);

ALTER TABLE campagne_commerciali ENABLE ROW LEVEL SECURITY;

CREATE POLICY "campagne_commerciali_auth"
  ON campagne_commerciali FOR ALL TO authenticated
  USING (true) WITH CHECK (true);

GRANT SELECT, INSERT, UPDATE, DELETE ON campagne_commerciali TO authenticated;
GRANT USAGE, SELECT ON SEQUENCE campagne_commerciali_id_seq TO authenticated;
