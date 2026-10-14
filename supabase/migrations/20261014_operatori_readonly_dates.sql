-- Aggiunge range date per sola lettura temporanea degli operatori
ALTER TABLE operatori ADD COLUMN IF NOT EXISTS readonly_da DATE;
ALTER TABLE operatori ADD COLUMN IF NOT EXISTS readonly_a  DATE;
