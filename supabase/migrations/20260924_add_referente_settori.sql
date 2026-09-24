-- Aggiunge i campi referente settori merceologici alla tabella operatori.
-- Un operatore può essere referente per più settori contemporaneamente.
-- I referenti hanno accesso alla sezione Rifornimento/Richiesta di Fornitura.
ALTER TABLE operatori
  ADD COLUMN IF NOT EXISTS referente_alimentari  boolean NOT NULL DEFAULT false,
  ADD COLUMN IF NOT EXISTS referente_casa        boolean NOT NULL DEFAULT false,
  ADD COLUMN IF NOT EXISTS referente_moda        boolean NOT NULL DEFAULT false,
  ADD COLUMN IF NOT EXISTS referente_cosmesi     boolean NOT NULL DEFAULT false,
  ADD COLUMN IF NOT EXISTS referente_ricorrenze  boolean NOT NULL DEFAULT false,
  ADD COLUMN IF NOT EXISTS referente_contabilita boolean NOT NULL DEFAULT false;
