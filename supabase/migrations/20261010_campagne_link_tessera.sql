-- Link visibile ai clienti con tessera digitale nella sezione Promo
ALTER TABLE campagne_commerciali ADD COLUMN IF NOT EXISTS link_tessera TEXT;
