-- Cron job: ogni lunedì alle 09:00 ora italiana ricorda agli operatori
-- di compilare i pezzi venduti della settimana appena conclusa.
--
-- 07:00 UTC = 09:00 CEST (estate, UTC+2)
-- 08:00 UTC = 09:00 CET  (inverno, UTC+1)
-- La Edge Function verifica internamente l'ora italiana e si ignora se non è le 9.
--
-- ISTRUZIONE: eseguire nel Supabase SQL Editor (richiede pg_cron e pg_net).

SELECT cron.schedule(
  'm361-pezzi-reminder',
  '0 7,8 * * 1',
  $$
    SELECT net.http_post(
      url     => 'https://hsalynvxazxqtmsvjrzc.supabase.co/functions/v1/send-pezzi-reminder',
      headers => '{"Content-Type":"application/json","Authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhzYWx5bnZ4YXp4cXRtc3ZqcnpjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Nzc3MjQ3MjcsImV4cCI6MjA5MzMwMDcyN30.JW4nsMrrfuI8BTg4bn2v74seVJ-_prfxZ1PQp5T18a8"}'::jsonb,
      body    => '{}'::jsonb
    )
  $$
);

-- Per verificare: SELECT jobname, schedule FROM cron.job WHERE jobname = 'm361-pezzi-reminder';
-- Per rimuovere: SELECT cron.unschedule('m361-pezzi-reminder');
