-- Aggiunge il campo versamenti (versamenti in banca) a cassa_giorni
ALTER TABLE cassa_giorni ADD COLUMN IF NOT EXISTS versamenti NUMERIC(10,2);
