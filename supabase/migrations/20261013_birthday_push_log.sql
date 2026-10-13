-- Log invii push di auguri compleanno ai clienti con tessera digitale
CREATE TABLE IF NOT EXISTS birthday_push_log (
  id              BIGSERIAL    PRIMARY KEY,
  created_at      TIMESTAMPTZ  NOT NULL DEFAULT now(),
  cliente_id      BIGINT       NOT NULL,
  tessera_id      TEXT         NOT NULL,
  anno            INT          NOT NULL,
  data_invio      TIMESTAMPTZ  NOT NULL DEFAULT now(),
  n_subscriptions INT          NOT NULL DEFAULT 0,
  n_inviate       INT          NOT NULL DEFAULT 0,
  n_errori        INT          NOT NULL DEFAULT 0,
  esito           TEXT         NOT NULL DEFAULT 'ok',
  UNIQUE (cliente_id, anno)
);

ALTER TABLE birthday_push_log ENABLE ROW LEVEL SECURITY;
CREATE POLICY "bpl_select" ON birthday_push_log FOR SELECT USING (true);
CREATE POLICY "bpl_insert" ON birthday_push_log FOR INSERT WITH CHECK (true);
CREATE POLICY "bpl_update" ON birthday_push_log FOR UPDATE USING (true);

-- Cron: ogni giorno alle 09:00 ora italiana (08:00 UTC)
SELECT cron.schedule(
  'birthday-push-client',
  '0 8 * * *',
  $$
  SELECT net.http_post(
    url := (SELECT value FROM app_settings WHERE key = 'supabase_functions_url') || '/send-birthday-push-client',
    headers := jsonb_build_object(
      'Content-Type', 'application/json',
      'Authorization', 'Bearer ' || (SELECT value FROM app_settings WHERE key = 'supabase_anon_key')
    ),
    body := '{}'::jsonb
  );
  $$
);
