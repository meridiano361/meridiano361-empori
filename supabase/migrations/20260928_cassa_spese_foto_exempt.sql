-- Colonne per segnalare che la foto dello scontrino non è necessaria (o già trasmessa)
ALTER TABLE cassa_giorni ADD COLUMN IF NOT EXISTS mat_spese_foto_exempt BOOLEAN DEFAULT false;
ALTER TABLE cassa_giorni ADD COLUMN IF NOT EXISTS pom_spese_foto_exempt BOOLEAN DEFAULT false;
