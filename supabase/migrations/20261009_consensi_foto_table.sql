-- Tabella per multiple foto consenso cartaceo per cliente
CREATE TABLE IF NOT EXISTS consensi_foto (
  id          UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  cliente_id  BIGINT      NOT NULL REFERENCES clienti(id) ON DELETE CASCADE,
  path        TEXT        NOT NULL,
  uploaded_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

ALTER TABLE consensi_foto ENABLE ROW LEVEL SECURITY;

CREATE POLICY "consensi_foto_auth_all" ON consensi_foto
  FOR ALL TO authenticated
  USING (is_active_operatore())
  WITH CHECK (is_active_operatore());
