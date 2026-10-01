-- Permette più tessere per cliente (storico)
ALTER TABLE tessere ADD COLUMN IF NOT EXISTS attiva boolean DEFAULT true;
UPDATE tessere SET attiva = true WHERE attiva IS NULL;

-- Rimuovi vincolo unico su cliente_id se esiste
ALTER TABLE tessere DROP CONSTRAINT IF EXISTS tessere_cliente_id_key;
ALTER TABLE tessere DROP CONSTRAINT IF EXISTS tessere_cliente_id_unique;
ALTER TABLE tessere DROP CONSTRAINT IF EXISTS tessere_pkey_cliente;
