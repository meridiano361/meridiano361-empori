-- Formato tessera: fisica e/o digitale
ALTER TABLE tessere ADD COLUMN IF NOT EXISTS ha_carta_fisica   boolean DEFAULT true;
ALTER TABLE tessere ADD COLUMN IF NOT EXISTS ha_carta_digitale boolean DEFAULT false;
