-- Aggiunge colonne per omaggi (incassi non riscossi) per aliquota IVA
ALTER TABLE public.cassa_giorni
  ADD COLUMN IF NOT EXISTS iva_om_22     numeric(10,2),
  ADD COLUMN IF NOT EXISTS iva_om_10     numeric(10,2),
  ADD COLUMN IF NOT EXISTS iva_om_4      numeric(10,2),
  ADD COLUMN IF NOT EXISTS iva_om_esente numeric(10,2);
