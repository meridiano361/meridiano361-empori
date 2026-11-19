-- Cron: notifica push fattorini con consegne del giorno, alle 8:00 ora italiana
-- Gira alle 06:00 UTC (= 08:00 CEST estate) e alle 07:00 UTC (= 08:00 CET inverno)
-- La funzione scarta l'esecuzione se l'ora italiana non è le 8.

DO $$ BEGIN
  IF EXISTS (SELECT 1 FROM cron.job WHERE jobname = 'm361-consegne-reminder') THEN
    PERFORM cron.unschedule('m361-consegne-reminder');
  END IF;
END $$;

SELECT cron.schedule(
  'm361-consegne-reminder',
  '0 6,7 * * *',
  $$
    SELECT net.http_post(
      url                  => 'https://hsalynvxazxqtmsvjrzc.supabase.co/functions/v1/send-consegne-reminder',
      headers              => '{"Content-Type":"application/json","Authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhzYWx5bnZ4YXp4cXRtc3ZqcnpjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Nzc3MjQ3MjcsImV4cCI6MjA5MzMwMDcyN30.JW4nsMrrfuI8BTg4bn2v74seVJ-_prfxZ1PQp5T18a8"}'::jsonb,
      body                 => '{}'::jsonb,
      timeout_milliseconds => 15000
    )
  $$
);
