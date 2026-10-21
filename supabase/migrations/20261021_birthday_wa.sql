-- Log invii WhatsApp automatici auguri compleanno
CREATE TABLE IF NOT EXISTS birthday_wa_log (
  id          BIGSERIAL    PRIMARY KEY,
  created_at  TIMESTAMPTZ  NOT NULL DEFAULT now(),
  cliente_id  BIGINT       NOT NULL,
  anno        INT          NOT NULL,
  data_invio  TIMESTAMPTZ  NOT NULL DEFAULT now(),
  telefono    TEXT,
  template    TEXT,
  wa_msg_id   TEXT,
  esito       TEXT         NOT NULL DEFAULT 'ok',  -- 'ok' | 'errore' | 'dryrun'
  errore_msg  TEXT,
  UNIQUE (cliente_id, anno)
);

ALTER TABLE birthday_wa_log ENABLE ROW LEVEL SECURITY;
CREATE POLICY "bwl_select" ON birthday_wa_log FOR SELECT USING (true);
CREATE POLICY "bwl_insert" ON birthday_wa_log FOR INSERT WITH CHECK (true);
CREATE POLICY "bwl_update" ON birthday_wa_log FOR UPDATE USING (true);

-- Cron: ogni giorno alle 09:00 ora italiana
-- 07:00 UTC = 09:00 CEST (estate) | 08:00 UTC = 09:00 CET (inverno)
-- La funzione controlla l'ora italiana internamente e gira solo alle 9
SELECT cron.schedule(
  'm361-birthday-whatsapp',
  '0 7,8 * * *',
  $$
    SELECT net.http_post(
      url                  => 'https://hsalynvxazxqtmsvjrzc.supabase.co/functions/v1/send-birthday-whatsapp',
      headers              => '{"Content-Type":"application/json","Authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhzYWx5bnZ4YXp4cXRtc3ZqcnpjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Nzc3MjQ3MjcsImV4cCI6MjA5MzMwMDcyN30.JW4nsMrrfuI8BTg4bn2v74seVJ-_prfxZ1PQp5T18a8"}'::jsonb,
      body                 => '{}'::jsonb,
      timeout_milliseconds => 30000
    )
  $$
);

-- Verifica:
-- SELECT jobname, schedule, active FROM cron.job WHERE jobname = 'm361-birthday-whatsapp';
