ALTER TABLE preordini_campagne ADD COLUMN IF NOT EXISTS scaglioni     JSONB;
ALTER TABLE preordini_campagne ADD COLUMN IF NOT EXISTS data_consegna DATE;
ALTER TABLE preordini_campagne ADD COLUMN IF NOT EXISTS data_apertura DATE;
