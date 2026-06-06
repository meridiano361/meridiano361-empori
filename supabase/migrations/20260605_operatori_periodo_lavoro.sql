-- Aggiunge data_inizio e data_fine alla tabella operatori
-- per supportare contratti a tempo determinato (dipendenti e SCU).
-- Le colonne sono nullable: NULL = nessun limite temporale (tempo indeterminato).

ALTER TABLE operatori
  ADD COLUMN IF NOT EXISTS data_inizio date DEFAULT NULL,
  ADD COLUMN IF NOT EXISTS data_fine   date DEFAULT NULL;

COMMENT ON COLUMN operatori.data_inizio IS 'Primo giorno di lavoro. NULL = nessun limite di inizio.';
COMMENT ON COLUMN operatori.data_fine   IS 'Ultimo giorno di lavoro. NULL = tempo indeterminato.';
