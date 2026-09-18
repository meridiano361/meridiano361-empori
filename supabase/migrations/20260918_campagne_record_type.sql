-- Distingue campagne commerciali da eventi nel calendario commerciale
ALTER TABLE campagne_commerciali
  ADD COLUMN IF NOT EXISTS record_type text DEFAULT 'campagna';
