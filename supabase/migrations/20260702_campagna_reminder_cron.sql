-- Cron giornaliero alle 08:00 UTC (10:00 ora italiana) per le notifiche campagne commerciali.
-- Avvisa tutti gli operatori dei PDV aderenti 1 giorno prima dell'inizio.
-- Avvisa i responsabili emporio 3 giorni prima dell'inizio.

SELECT cron.schedule(
  'send-campagna-reminder',
  '0 8 * * *',
  $$
  SELECT net.http_post(
    url     := current_setting('app.supabase_url') || '/functions/v1/send-campagna-reminder',
    headers := jsonb_build_object(
                 'Authorization', 'Bearer ' || current_setting('app.service_role_key'),
                 'Content-Type',  'application/json'
               ),
    body    := '{}'::jsonb
  );
  $$
);
