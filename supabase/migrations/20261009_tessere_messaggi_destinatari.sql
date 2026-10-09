-- Aggiunge colonna destinatari a tessere_messaggi
ALTER TABLE tessere_messaggi ADD COLUMN IF NOT EXISTS destinatari TEXT NOT NULL DEFAULT 'tutti';
