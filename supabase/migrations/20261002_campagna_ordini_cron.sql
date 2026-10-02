-- Cron giornaliero alle 06:00 e 07:00 UTC (= 08:00 ora italiana CET/CEST)
-- Notifica il responsabile acquisti il giorno prima dell'inizio ordini a fornitore.

SELECT cron.schedule(
  'send-campagna-ordini-reminder',
  '0 6,7 * * *',
  $$
    SELECT net.http_post(
      url                  => 'https://hsalynvxazxqtmsvjrzc.supabase.co/functions/v1/send-campagna-reminder',
      headers              => '{"Content-Type":"application/json","Authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhzYWx5bnZ4YXp4cXRtc3ZqcnpjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Nzc3MjQ3MjcsImV4cCI6MjA5MzMwMDcyN30.JW4nsMrrfuI8BTg4bn2v74seVJ-_prfxZ1PQp5T18a8"}'::jsonb,
      body                 => '{"solo_ordini":true}'::jsonb,
      timeout_milliseconds => 30000
    )
  $$
);

-- Verifica:
-- SELECT jobname, schedule, active FROM cron.job WHERE jobname = 'send-campagna-ordini-reminder';
