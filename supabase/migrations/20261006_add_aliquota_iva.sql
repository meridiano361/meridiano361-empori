-- Aggiunge aliquota IVA per riga prodotto (4, 10, 22 %)
-- Default 10% (alimentari confezionati standard)
ALTER TABLE preordini_righe
  ADD COLUMN IF NOT EXISTS aliquota_iva INTEGER NOT NULL DEFAULT 10;
