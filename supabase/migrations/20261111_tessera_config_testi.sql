-- Aggiunge campi testo alla configurazione tessera
ALTER TABLE public.tessera_config ADD COLUMN IF NOT EXISTS titolo            text;
ALTER TABLE public.tessera_config ADD COLUMN IF NOT EXISTS testo_sconto_sub  text;
ALTER TABLE public.tessera_config ADD COLUMN IF NOT EXISTS website_url        text;
ALTER TABLE public.tessera_config ADD COLUMN IF NOT EXISTS website_label      text;

-- Popola i default per le righe esistenti
UPDATE public.tessera_config SET
  titolo           = 'Tessera di',
  testo_sconto_sub = 'su una prossima spesa a tua scelta.',
  website_url      = 'https://www.meridiano361.it',
  website_label    = 'www.meridiano361.it'
WHERE tipo = 'standard' AND titolo IS NULL;

UPDATE public.tessera_config SET
  titolo           = 'TESSERA AMBASSADOR',
  testo_sconto_sub = 'su una prossima spesa a tua scelta.',
  website_url      = 'https://www.meridiano361.it',
  website_label    = 'www.meridiano361.it'
WHERE tipo = 'ambassador' AND titolo IS NULL;
