ALTER TABLE campagne_prenotazione ADD COLUMN IF NOT EXISTS fornitori_prenotati JSONB DEFAULT '{}';
