-- Tabella push subscriptions: salva il dispositivo di ogni operatore
-- per le notifiche push anche quando l'app è chiusa.

CREATE TABLE IF NOT EXISTS push_subscriptions (
  id           BIGSERIAL    PRIMARY KEY,
  created_at   TIMESTAMPTZ  NOT NULL DEFAULT now(),
  operatore_nome TEXT        NOT NULL,
  emporio      TEXT         NOT NULL DEFAULT '',
  endpoint     TEXT         NOT NULL UNIQUE,   -- chiave unica per upsert
  subscription JSONB        NOT NULL           -- intero oggetto PushSubscription
);

ALTER TABLE push_subscriptions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "push_sub_select" ON push_subscriptions FOR SELECT USING (true);
CREATE POLICY "push_sub_insert" ON push_subscriptions FOR INSERT WITH CHECK (true);
CREATE POLICY "push_sub_update" ON push_subscriptions FOR UPDATE USING (true);
CREATE POLICY "push_sub_delete" ON push_subscriptions FOR DELETE USING (true);
