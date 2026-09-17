-- Aggiunge colonne per conteggio contanti inizio turno (calcolatrice indipendente)
ALTER TABLE cassa_giorni
  ADD COLUMN IF NOT EXISTS mat_ini_contanti NUMERIC,
  ADD COLUMN IF NOT EXISTS pom_ini_contanti NUMERIC;
