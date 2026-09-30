CREATE TABLE IF NOT EXISTS richieste_ruolo (
  id            UUID        DEFAULT gen_random_uuid() PRIMARY KEY,
  richiedente_id UUID       NOT NULL,
  richiedente_nome TEXT,
  operatore_id  UUID        NOT NULL,
  operatore_nome TEXT,
  ruolo         TEXT        NOT NULL,
  valore        BOOLEAN     NOT NULL DEFAULT true,
  stato         TEXT        NOT NULL DEFAULT 'pending',
  nota          TEXT,
  created_at    TIMESTAMPTZ DEFAULT NOW(),
  updated_at    TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE richieste_ruolo ENABLE ROW LEVEL SECURITY;

CREATE POLICY "richieste_ruolo_read"
  ON richieste_ruolo FOR SELECT TO authenticated USING (true);

CREATE POLICY "richieste_ruolo_insert"
  ON richieste_ruolo FOR INSERT TO authenticated WITH CHECK (true);

CREATE POLICY "richieste_ruolo_update"
  ON richieste_ruolo FOR UPDATE TO authenticated USING (true) WITH CHECK (true);
