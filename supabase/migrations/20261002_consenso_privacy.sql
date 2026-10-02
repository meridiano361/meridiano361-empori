-- Consenso privacy: token univoco per link e campi di stato
ALTER TABLE clienti ADD COLUMN IF NOT EXISTS consent_token uuid NOT NULL DEFAULT gen_random_uuid();
ALTER TABLE clienti ADD COLUMN IF NOT EXISTS consenso_privacy boolean DEFAULT false;
ALTER TABLE clienti ADD COLUMN IF NOT EXISTS consenso_privacy_data timestamptz;

-- Assicura che i clienti esistenti abbiano un token
UPDATE clienti SET consent_token = gen_random_uuid() WHERE consent_token IS NULL;

-- Indice per ricerca rapida per token
CREATE UNIQUE INDEX IF NOT EXISTS clienti_consent_token_idx ON clienti(consent_token);
