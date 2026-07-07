-- Aggiunge campo link_esterno separato dal link_info (allegato file)
ALTER TABLE campagne_commerciali ADD COLUMN IF NOT EXISTS link_esterno TEXT;
