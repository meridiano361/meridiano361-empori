-- Tabella di configurazione per tutte le regole di notifica automatica dell'app.
-- Ogni riga rappresenta una regola (chi riceve cosa, quando, su quale canale).
-- Le edge function leggono il flag "attiva" prima di inviare.

CREATE TABLE IF NOT EXISTS notifiche_config (
  id               TEXT PRIMARY KEY,
  nome             TEXT NOT NULL,
  descrizione      TEXT,
  attiva           BOOLEAN NOT NULL DEFAULT true,
  canale           TEXT NOT NULL,   -- 'email' | 'push' | 'entrambi'
  destinatari      TEXT NOT NULL,   -- descrizione human-readable
  evento           TEXT NOT NULL,   -- 'campagna' | 'scadenza_prodotti' | 'turno' | 'pezzi' | 'presenza' | 'fornitura'
  giorni_anticipo  INTEGER,         -- NULL se non applicabile
  updated_at       TIMESTAMPTZ NOT NULL DEFAULT now()
);

ALTER TABLE notifiche_config ENABLE ROW LEVEL SECURITY;
CREATE POLICY "notifiche_config_read"   ON notifiche_config FOR SELECT USING (true);
CREATE POLICY "notifiche_config_update" ON notifiche_config FOR UPDATE USING (true);

INSERT INTO notifiche_config
  (id, nome, descrizione, attiva, canale, destinatari, evento, giorni_anticipo)
VALUES
  ('campagna_email_3g',  'Email campagna – 3 giorni prima',
   'Email di promemoria a tutti gli operatori attivi degli empori aderenti, 3 giorni prima dell''inizio della campagna.',
   true, 'email', 'Tutti gli operatori (empori aderenti)', 'campagna', 3),

  ('campagna_push_1g',   'Push campagna – 1 giorno prima',
   'Notifica push a tutti gli operatori attivi degli empori aderenti, 1 giorno prima dell''inizio della campagna.',
   true, 'push', 'Tutti gli operatori (empori aderenti)', 'campagna', 1),

  ('campagna_push_3g',   'Push campagna – 3 giorni prima',
   'Notifica push ai responsabili emporio degli empori aderenti, 3 giorni prima dell''inizio della campagna.',
   true, 'push', 'Solo responsabili emporio', 'campagna', 3),

  ('scadenza_email',     'Email prodotti in scadenza',
   'Email ai responsabili acquisti quando un prodotto si avvicina alla scadenza (soglie: 30, 14, 1 giorno).',
   true, 'email', 'Responsabili acquisti', 'scadenza_prodotti', NULL),

  ('scadenza_push_30g',  'Push scadenza – 30 giorni',
   'Notifica push ai responsabili acquisti e responsabili emporio 30 giorni prima della scadenza.',
   true, 'push', 'Responsabili acquisti + responsabili emporio', 'scadenza_prodotti', 30),

  ('scadenza_push_14g',  'Push scadenza – 14 giorni',
   'Notifica push ai responsabili acquisti e responsabili emporio 14 giorni prima della scadenza.',
   true, 'push', 'Responsabili acquisti + responsabili emporio', 'scadenza_prodotti', 14),

  ('scadenza_push_1g',   'Push scadenza – 1 giorno',
   'Notifica push ai responsabili acquisti e responsabili emporio il giorno prima della scadenza.',
   true, 'push', 'Responsabili acquisti + responsabili emporio', 'scadenza_prodotti', 1),

  ('pezzi_push',         'Push pezzi settimanali',
   'Notifica push agli operatori per ricordare l''inserimento del conteggio pezzi settimanale.',
   true, 'push', 'Tutti gli operatori', 'pezzi', NULL),

  ('timbra_push',        'Push promemoria timbratura',
   'Notifica push di promemoria quando un operatore non ha ancora timbrato.',
   true, 'push', 'Operatori con turno attivo', 'turno', NULL),

  ('turno_push',         'Push turno imminente',
   'Notifica push quando sta per iniziare un turno assegnato.',
   true, 'push', 'Operatori con turno assegnato', 'turno', NULL),

  ('presenza_push',      'Push promemoria presenze',
   'Notifica push per la compilazione delle presenze.',
   true, 'push', 'Responsabili', 'presenza', NULL),

  ('fornitura_push',     'Push richiesta di fornitura',
   'Notifica push al responsabile acquisti quando arriva una nuova richiesta di fornitura.',
   true, 'push', 'Responsabili acquisti', 'fornitura', NULL)

ON CONFLICT (id) DO NOTHING;
