-- Cron: invia promemoria sconto compleanno alle tessere Ambassador il 1° di ogni mese
SELECT cron.schedule(
  'compleanno-ambassador-push',
  '0 8 1 * *',  -- 1° del mese alle 08:00 UTC (09:00 ora italiana)
  $$
  SELECT net.http_post(
    url := 'https://hsalynvxazxqtmsvjrzc.supabase.co/functions/v1/send-compleanno-ambassador',
    headers := jsonb_build_object(
      'Content-Type', 'application/json',
      'Authorization', 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhzYWx5bnZ4YXp4cXRtc3ZqcnpjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Nzc3MjQ3MjcsImV4cCI6MjA5MzMwMDcyN30.JW4nsMrrfuI8BTg4bn2v74seVJ-_prfxZ1PQp5T18a8'
    ),
    body := '{}'::jsonb
  );
  $$
);
