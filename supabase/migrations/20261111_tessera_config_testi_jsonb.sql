-- Aggiunge colonna JSONB per tutti i testi configurabili della tessera
ALTER TABLE public.tessera_config ADD COLUMN IF NOT EXISTS testi jsonb DEFAULT '{}';
