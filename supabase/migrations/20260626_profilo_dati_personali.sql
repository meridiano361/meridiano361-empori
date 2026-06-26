-- Dati anagrafici personali sull'operatore (modificabili dall'operatore stesso)
ALTER TABLE operatori
  ADD COLUMN IF NOT EXISTS data_nascita        date,
  ADD COLUMN IF NOT EXISTS luogo_nascita       text,
  ADD COLUMN IF NOT EXISTS codice_fiscale      text,
  ADD COLUMN IF NOT EXISTS residenza_indirizzo text,
  ADD COLUMN IF NOT EXISTS residenza_citta     text,
  ADD COLUMN IF NOT EXISTS residenza_cap       text,
  ADD COLUMN IF NOT EXISTS residenza_provincia text;

-- Permessi: operatore può aggiornare solo i propri dati personali
GRANT UPDATE (telefono, email, data_nascita, luogo_nascita, codice_fiscale,
              residenza_indirizzo, residenza_citta, residenza_cap, residenza_provincia)
  ON operatori TO anon;

-- Permessi notifiche (email_abilitato aggiunto nella migrazione precedente)
GRANT UPDATE (abilitato, email_abilitato) ON operatore_notif_prefs TO anon;
GRANT INSERT ON operatore_notif_prefs TO anon;

-- Richieste / segnalazioni degli operatori all'admin
CREATE TABLE IF NOT EXISTS richieste_operatore (
  id             bigserial    PRIMARY KEY,
  created_at     timestamptz  NOT NULL DEFAULT now(),
  operatore_id   uuid,
  operatore_nome text         NOT NULL DEFAULT '',
  categoria      text         NOT NULL DEFAULT 'altro',
  testo          text         NOT NULL,
  stato          text         NOT NULL DEFAULT 'aperta',
  letta          boolean      NOT NULL DEFAULT false
);

ALTER TABLE richieste_operatore ENABLE ROW LEVEL SECURITY;

CREATE POLICY "anon_insert_richiesta" ON richieste_operatore
  FOR INSERT TO anon WITH CHECK (true);

CREATE POLICY "anon_select_richiesta" ON richieste_operatore
  FOR SELECT TO anon USING (true);

GRANT INSERT, SELECT ON richieste_operatore TO anon;
GRANT USAGE, SELECT ON SEQUENCE richieste_operatore_id_seq TO anon;
