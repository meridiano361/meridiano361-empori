-- Cron job: ogni giorno alle 17:00 ora italiana ricorda di caricare la foto
-- dello scontrino se ci sono spese senza foto.
--
-- 15:00 UTC = 17:00 CEST (estate, UTC+2)
-- 16:00 UTC = 17:00 CET  (inverno, UTC+1)
-- La Edge Function verifica internamente l'ora italiana e si ignora se non è le 17.
--
-- ISTRUZIONE: eseguire nel Supabase SQL Editor (richiede pg_cron e pg_net).

SELECT cron.schedule(
  'm361-foto-spese-reminder',
  '0 15,16 * * *',
  $$
    SELECT net.http_post(
      url     => 'https://hsalynvxazxqtmsvjrzc.supabase.co/functions/v1/send-foto-spese-reminder',
      headers => '{"Content-Type":"application/json","Authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhzYWx5bnZ4YXp4cXRtc3ZqcnpjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Nzc3MjQ3MjcsImV4cCI6MjA5MzMwMDcyN30.JW4nsMrrfuI8BTg4bn2v74seVJ-_prfxZ1PQp5T18a8"}'::jsonb,
      body    => '{}'::jsonb
    )
  $$
);

-- Per verificare: SELECT jobname, schedule FROM cron.job WHERE jobname = 'm361-foto-spese-reminder';
-- Per rimuovere: SELECT cron.unschedule('m361-foto-spese-reminder');
