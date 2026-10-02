-- Modalità di acquisizione del consenso privacy: 'offline' (cartacea) o 'online' (link)
ALTER TABLE clienti ADD COLUMN IF NOT EXISTS consenso_privacy_modalita varchar DEFAULT 'offline';
