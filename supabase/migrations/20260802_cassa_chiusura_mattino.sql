ALTER TABLE cassa_giorni ADD COLUMN IF NOT EXISTS mat_scontrini    INTEGER;
ALTER TABLE cassa_giorni ADD COLUMN IF NOT EXISTS mat_ora_chiusura TEXT;
ALTER TABLE cassa_giorni ADD COLUMN IF NOT EXISTS pom_ora_chiusura TEXT;
