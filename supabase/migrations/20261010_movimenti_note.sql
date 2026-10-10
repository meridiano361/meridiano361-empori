-- Aggiunge campo note a movimenti_tessera (es. "Da cartacea")
ALTER TABLE movimenti_tessera ADD COLUMN IF NOT EXISTS note TEXT;
