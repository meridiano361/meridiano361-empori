-- Condizioni commerciali per preventivi (JSONB)
ALTER TABLE preventivi
  ADD COLUMN IF NOT EXISTS condizioni_commerciali JSONB;
