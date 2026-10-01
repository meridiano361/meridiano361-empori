-- Aggiunge data di rinnovo alla tessera fedeltà
ALTER TABLE tessere ADD COLUMN IF NOT EXISTS data_rinnovo date;
