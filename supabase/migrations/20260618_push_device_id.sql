-- Aggiunge le colonne mancanti a push_subscriptions
ALTER TABLE push_subscriptions
  ADD COLUMN IF NOT EXISTS device_id   text,
  ADD COLUMN IF NOT EXISTS platform    text,
  ADD COLUMN IF NOT EXISTS last_seen_at timestamptz,
  ADD COLUMN IF NOT EXISTS updated_at   timestamptz;
