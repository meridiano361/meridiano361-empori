-- Cron job: promemoria compilazione foglio presenze, penultimo giorno del mese alle 09:00 ora italiana.
-- Gira alle 07:00 UTC (= 09:00 CEST, estate) e alle 08:00 UTC (= 09:00 CET, inverno).
-- La Edge Function controlla internamente ora e giorno e si auto-ignora se le condizioni non sono soddisfatte.

DO $$ BEGIN
  IF EXISTS (SELECT 1 FROM cron.job WHERE jobname = 'm361-presenze-reminder') THEN
    PERFORM cron.unschedule('m361-presenze-reminder');
  END IF;
END $$;

SELECT cron.schedule(
  'm361-presenze-reminder',
  '0 7,8 * * *',
  $$
    SELECT net.http_post(
      url                  => 'https://hsalynvxazxqtmsvjrzc.supabase.co/functions/v1/send-presenze-reminder',
      headers              => '{"Content-Type":"application/json","Authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhzYWx5bnZ4YXp4cXRtc3ZqcnpjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Nzc3MjQ3MjcsImV4cCI6MjA5MzMwMDcyN30.JW4nsMrrfuI8BTg4bn2v74seVJ-_prfxZ1PQp5T18a8"}'::jsonb,
      body                 => '{}'::jsonb,
      timeout_milliseconds => 15000
    )
  $$
);

-- Verifica:
-- SELECT jobname, schedule, active FROM cron.job WHERE jobname = 'm361-presenze-reminder';
-- Test manuale:
-- SELECT net.http_post(url=>'...send-presenze-reminder?dryrun=1', headers=>..., body=>'{}'::jsonb);
