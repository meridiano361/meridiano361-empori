-- Colonne per le foto degli scontrini delle spese (mattino e pomeriggio)
ALTER TABLE cassa_giorni ADD COLUMN IF NOT EXISTS mat_foto_spese TEXT;
ALTER TABLE cassa_giorni ADD COLUMN IF NOT EXISTS pom_foto_spese TEXT;
