-- Destinatari del messaggio WA: tutti, standard, ambassador, wa, news
ALTER TABLE tessere_messaggi ADD COLUMN IF NOT EXISTS destinatari varchar DEFAULT 'tutti';
