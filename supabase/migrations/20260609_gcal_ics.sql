-- Aggiunge colonne per Google Calendar sync e feed ICS per-operatore.
-- Sicuro da rieseguire: tutte le ALTER usano IF NOT EXISTS.

ALTER TABLE operatori ADD COLUMN IF NOT EXISTS gcal_calendar_id TEXT;
ALTER TABLE operatori ADD COLUMN IF NOT EXISTS ics_token        TEXT;

-- Genera token ICS univoci per gli operatori già esistenti
UPDATE operatori
SET ics_token = encode(gen_random_bytes(24), 'hex')
WHERE ics_token IS NULL;
