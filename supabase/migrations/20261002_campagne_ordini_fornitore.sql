-- Date ordini a fornitore per campagna commerciale
ALTER TABLE campagne_commerciali ADD COLUMN IF NOT EXISTS data_inizio_ordini date;
ALTER TABLE campagne_commerciali ADD COLUMN IF NOT EXISTS data_fine_ordini date;
