-- Aggiunge colonna per tracciare i timbri trasferiti da tessera cartacea
ALTER TABLE tessere ADD COLUMN IF NOT EXISTS timbri_cartacea integer NOT NULL DEFAULT 0;

-- Corregge Bertuzzi: 4 timbri erano trasferimento da cartacea, non omaggio
UPDATE tessere
SET timbri_omaggio  = GREATEST(0, timbri_omaggio - 4),
    timbri_cartacea = 4
WHERE cliente_id = (
  SELECT id FROM clienti WHERE nome ILIKE 'Giuliana' AND cognome ILIKE 'Bertuzzi' LIMIT 1
)
AND attiva = true;
