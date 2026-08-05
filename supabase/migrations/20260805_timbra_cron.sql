-- Registra il cron ogni minuto per send-timbra-reminder.
-- Era rimasto commentato nella migration precedente (20260802_push_timbra_log.sql).

DO $$ BEGIN
  IF EXISTS (SELECT 1 FROM cron.job WHERE jobname = 'm361-timbra-reminder') THEN
    PERFORM cron.unschedule('m361-timbra-reminder');
  END IF;
END $$;

SELECT cron.schedule(
  'm361-timbra-reminder',
  '* * * * *',
  $$
    SELECT net.http_post(
      url                  => 'https://hsalynvxazxqtmsvjrzc.supabase.co/functions/v1/send-timbra-reminder',
      headers              => '{"Content-Type":"application/json","Authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhzYWx5bnZ4YXp4cXRtc3ZqcnpjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Nzc3MjQ3MjcsImV4cCI6MjA5MzMwMDcyN30.JW4nsMrrfuI8BTg4bn2v74seVJ-_prfxZ1PQp5T18a8"}'::jsonb,
      body                 => '{}'::jsonb,
      timeout_milliseconds => 10000
    )
  $$
);

-- Verifica:
-- SELECT jobname, schedule, active FROM cron.job
-- WHERE jobname IN ('m361-turno-reminder', 'm361-timbra-reminder');
