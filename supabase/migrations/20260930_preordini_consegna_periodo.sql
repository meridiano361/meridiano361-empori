-- Supporto periodo di consegna (es. 20 gen – 10 feb)
ALTER TABLE preordini_campagne
  ADD COLUMN IF NOT EXISTS data_consegna_fine DATE;
