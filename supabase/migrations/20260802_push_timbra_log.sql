-- Tabella di log per le notifiche "timbra entrata/uscita"
-- Garantisce che ogni operatore riceva al massimo 1 push per fascia+tipo al giorno.
CREATE TABLE IF NOT EXISTS push_timbra_log (
  id           bigserial PRIMARY KEY,
  operatore_id uuid        NOT NULL,
  data         date        NOT NULL,
  fascia       text        NOT NULL,  -- 'mattina' | 'pomeriggio' | 'sera'
  tipo         text        NOT NULL,  -- 'entrata' | 'uscita'
  emporio      text,
  sent_at      timestamptz NOT NULL DEFAULT now(),
  UNIQUE (operatore_id, data, fascia, tipo)
);

-- Pulizia automatica: elimina log più vecchi di 30 giorni
CREATE INDEX IF NOT EXISTS push_timbra_log_data_idx ON push_timbra_log (data);

-- Grant lettura/scrittura alla Edge Function (service role lo bypassa, ma per sicurezza)
GRANT SELECT, INSERT, DELETE ON push_timbra_log TO authenticated, anon;
GRANT USAGE, SELECT ON SEQUENCE push_timbra_log_id_seq TO authenticated, anon;

-- ─────────────────────────────────────────────────────────────────────────────
-- ISTRUZIONE CRON — eseguire manualmente nel Supabase SQL Editor
-- ─────────────────────────────────────────────────────────────────────────────
-- Il job lancia la Edge Function ogni minuto. La funzione controlla se l'ora
-- italiana corrente coincide con l'inizio o la fine di un turno. Se non c'è
-- corrispondenza (la maggioranza dei casi), torna subito senza fare nulla.
--
-- SELECT cron.schedule(
--   'm361-timbra-reminder',
--   '* * * * *',
--   $$
--     SELECT net.http_post(
--       url     => 'https://hsalynvxazxqtmsvjrzc.supabase.co/functions/v1/send-timbra-reminder',
--       headers => '{"Content-Type":"application/json","Authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhzYWx5bnZ4YXp4cXRtc3ZqcnpjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Nzc3MjQ3MjcsImV4cCI6MjA5MzMwMDcyN30.JW4nsMrrfuI8BTg4bn2v74seVJ-_prfxZ1PQp5T18a8"}'::jsonb,
--       body    => '{}'::jsonb
--     )
--   $$
-- );
--
-- Per verificare:
--   SELECT jobname, schedule FROM cron.job WHERE jobname = 'm361-timbra-reminder';
-- Per rimuovere:
--   SELECT cron.unschedule('m361-timbra-reminder');
