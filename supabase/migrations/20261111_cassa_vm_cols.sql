-- Aggiunge colonne usate nella Vista Mensile (Controllo Cassa)
ALTER TABLE cassa_giorni ADD COLUMN IF NOT EXISTS meteo_note text;
ALTER TABLE cassa_giorni ADD COLUMN IF NOT EXISTS note_amm   text;
