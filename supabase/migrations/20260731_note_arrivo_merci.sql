ALTER TABLE cassa_giorni ADD COLUMN IF NOT EXISTS note_arrivo_merci TEXT;
ALTER TABLE cassa_giorni ADD COLUMN IF NOT EXISTS meteo_mattino TEXT;
ALTER TABLE cassa_giorni ADD COLUMN IF NOT EXISTS meteo_pomeriggio TEXT;
