-- Aggiunge il flag per pausa retribuita CCNL per operatore
ALTER TABLE operatori
  ADD COLUMN IF NOT EXISTS pausa_retribuita boolean DEFAULT false;
