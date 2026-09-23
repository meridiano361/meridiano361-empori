-- Aggiunge supporto stato "evasa" alle proposte rifornimento
ALTER TABLE rifornimento_proposte ADD COLUMN IF NOT EXISTS note_evasione TEXT;
ALTER TABLE rifornimento_proposte ADD COLUMN IF NOT EXISTS evasa_at      TIMESTAMPTZ;
