-- Cron job: notifica push compleanno clienti ogni mattina alle 9:00 ora italiana
-- Gira alle 07:00 UTC (= 09:00 CEST estate) e alle 08:00 UTC (= 09:00 CET inverno)

SELECT cron.schedule(
  'm361-birthday-reminder',
  '0 7,8 * * *',
  $$
    SELECT net.http_post(
      url                  => 'https://hsalynvxazxqtmsvjrzc.supabase.co/functions/v1/send-birthday-reminder',
      headers              => '{"Content-Type":"application/json","Authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhzYWx5bnZ4YXp4cXRtc3ZqcnpjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Nzc3MjQ3MjcsImV4cCI6MjA5MzMwMDcyN30.JW4nsMrrfuI8BTg4bn2v74seVJ-_prfxZ1PQp5T18a8"}'::jsonb,
      body                 => '{}'::jsonb,
      timeout_milliseconds => 30000
    )
  $$
);

-- Verifica:
-- SELECT jobname, schedule, active FROM cron.job WHERE jobname = 'm361-birthday-reminder';
