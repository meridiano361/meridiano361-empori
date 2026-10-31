-- Tabella push subscriptions per i clienti con tessera digitale Ambassador
-- Usata per inviare il promemoria sconto compleanno il 1° del mese

CREATE TABLE IF NOT EXISTS tessera_push_subscriptions (
  id           BIGSERIAL    PRIMARY KEY,
  created_at   TIMESTAMPTZ  NOT NULL DEFAULT now(),
  tessera_id   TEXT         NOT NULL,
  endpoint     TEXT         NOT NULL UNIQUE,
  subscription JSONB        NOT NULL
);

ALTER TABLE tessera_push_subscriptions ENABLE ROW LEVEL SECURITY;

-- Anon può inserire/aggiornare (il cliente salva la propria subscription)
CREATE POLICY "tessera_push_insert" ON tessera_push_subscriptions
  FOR INSERT WITH CHECK (true);
CREATE POLICY "tessera_push_upsert" ON tessera_push_subscriptions
  FOR UPDATE USING (true);
CREATE POLICY "tessera_push_select" ON tessera_push_subscriptions
  FOR SELECT USING (true);
