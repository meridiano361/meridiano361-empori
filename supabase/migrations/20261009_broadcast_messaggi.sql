-- Messaggi broadcast WhatsApp programmati
CREATE TABLE IF NOT EXISTS broadcast_messaggi (
  id          UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  emporio     TEXT,
  titolo      TEXT        NOT NULL,
  destinatari TEXT        NOT NULL,
  testo       TEXT        NOT NULL,
  data_invio  TIMESTAMPTZ NOT NULL,
  note        TEXT,
  inviato     BOOLEAN     NOT NULL DEFAULT false,
  inviato_at  TIMESTAMPTZ,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
  created_by  TEXT
);

ALTER TABLE broadcast_messaggi ENABLE ROW LEVEL SECURITY;

CREATE POLICY "broadcast_auth_all" ON broadcast_messaggi
  FOR ALL TO authenticated
  USING (is_active_operatore())
  WITH CHECK (is_active_operatore());
