-- Dettaglio IVA esente (JSON array con tipo/importo/specifica)
ALTER TABLE cassa_giorni ADD COLUMN IF NOT EXISTS iva_esente_dettaglio JSONB;

-- Controllo amministrativo per scheda IVA
ALTER TABLE cassa_giorni ADD COLUMN IF NOT EXISTS iva_admin_ok BOOLEAN DEFAULT FALSE;
ALTER TABLE cassa_giorni ADD COLUMN IF NOT EXISTS iva_admin_note TEXT;
