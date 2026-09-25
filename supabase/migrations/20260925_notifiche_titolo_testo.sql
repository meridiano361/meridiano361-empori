-- Aggiunge colonna per il titolo personalizzato della notifica
ALTER TABLE notifiche_config
  ADD COLUMN IF NOT EXISTS titolo_notifica TEXT;
