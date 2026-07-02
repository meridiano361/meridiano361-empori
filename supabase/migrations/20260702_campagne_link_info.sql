-- Aggiunge il campo link_info a campagne_commerciali.
-- Contiene un URL con le info operative della campagna (es. Google Drive, PDF, ecc.).

ALTER TABLE campagne_commerciali
  ADD COLUMN IF NOT EXISTS link_info TEXT;

NOTIFY pgrst, 'reload schema';
