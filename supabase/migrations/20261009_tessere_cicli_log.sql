-- Log delle date di completamento ciclo per calcolare durata media per cliente
CREATE TABLE IF NOT EXISTS tessere_cicli_log (
  id            BIGSERIAL    PRIMARY KEY,
  tessera_id    UUID         NOT NULL REFERENCES tessere(id) ON DELETE CASCADE,
  ciclo_numero  INTEGER      NOT NULL,
  completato_at TIMESTAMPTZ  NOT NULL DEFAULT now()
);

ALTER TABLE tessere_cicli_log ENABLE ROW LEVEL SECURITY;

CREATE POLICY "cicli_log_auth" ON tessere_cicli_log
  FOR ALL TO authenticated
  USING (is_active_operatore())
  WITH CHECK (is_active_operatore());

-- Indice per query per tessera
CREATE INDEX IF NOT EXISTS idx_cicli_log_tessera ON tessere_cicli_log(tessera_id, ciclo_numero);
