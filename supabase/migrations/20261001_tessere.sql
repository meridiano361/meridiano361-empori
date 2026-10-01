-- ── Tessere Fedeltà ─────────────────────────────────────────────────────────

-- Extend clienti with missing contact fields
ALTER TABLE clienti ADD COLUMN IF NOT EXISTS data_nascita DATE;
ALTER TABLE clienti ADD COLUMN IF NOT EXISTS citta TEXT;
ALTER TABLE clienti ADD COLUMN IF NOT EXISTS provincia TEXT;

-- Main tessere table
CREATE TABLE IF NOT EXISTS tessere (
  id                          UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  cliente_id                  BIGINT      NOT NULL REFERENCES clienti(id) ON DELETE CASCADE,
  tipo                        TEXT        NOT NULL CHECK (tipo IN ('standard', 'ambassador')),
  emporio                     TEXT        NOT NULL,
  codice_tessera              TEXT,
  data_emissione              DATE,
  timbri_attuali              INTEGER     NOT NULL DEFAULT 0 CHECK (timbri_attuali >= 0 AND timbri_attuali <= 12),
  data_inizio_ciclo_corrente  DATE,
  ha_whatsapp                 BOOLEAN     NOT NULL DEFAULT false,
  vuole_news_whatsapp         BOOLEAN     NOT NULL DEFAULT false,
  in_lista_broadcast_whatsapp BOOLEAN     NOT NULL DEFAULT false,
  messaggio_benvenuto_inviato BOOLEAN     NOT NULL DEFAULT false,
  note                        TEXT,
  created_at                  TIMESTAMPTZ DEFAULT now(),
  updated_at                  TIMESTAMPTZ DEFAULT now()
);

-- Completed card cycles / discount redemption history
CREATE TABLE IF NOT EXISTS tessere_sconti (
  id                   UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  tessera_id           UUID        NOT NULL REFERENCES tessere(id) ON DELETE CASCADE,
  data_inizio_ciclo    DATE,
  data_utilizzo        DATE        NOT NULL,
  giorni_completamento INTEGER,
  valore_sconto        TEXT        NOT NULL,
  note                 TEXT,
  created_at           TIMESTAMPTZ DEFAULT now()
);

-- WA message templates
CREATE TABLE IF NOT EXISTS tessere_messaggi (
  id         UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  tipo       TEXT        NOT NULL,
  titolo     TEXT        NOT NULL,
  testo      TEXT        NOT NULL,
  ordine     INTEGER     DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

-- RLS policies
ALTER TABLE tessere          ENABLE ROW LEVEL SECURITY;
ALTER TABLE tessere_sconti   ENABLE ROW LEVEL SECURITY;
ALTER TABLE tessere_messaggi ENABLE ROW LEVEL SECURITY;

CREATE POLICY "anon_all_tessere"          ON tessere          FOR ALL TO anon USING (true) WITH CHECK (true);
CREATE POLICY "anon_all_tessere_sconti"   ON tessere_sconti   FOR ALL TO anon USING (true) WITH CHECK (true);
CREATE POLICY "anon_all_tessere_messaggi" ON tessere_messaggi FOR ALL TO anon USING (true) WITH CHECK (true);

GRANT SELECT, INSERT, UPDATE, DELETE ON tessere          TO anon;
GRANT SELECT, INSERT, UPDATE, DELETE ON tessere_sconti   TO anon;
GRANT SELECT, INSERT, UPDATE, DELETE ON tessere_messaggi TO anon;

-- Default WA message templates
INSERT INTO tessere_messaggi (tipo, titolo, testo, ordine) VALUES
  ('benvenuto',              'Benvenuto',
   'Benvenuta/o in Meridiano 361! Siamo felici di averti tra i nostri clienti fedeli. Con la tua tessera accumuli punti ad ogni acquisto e ricevi sconti esclusivi. A presto!', 1),
  ('compleanno',             'Auguri di compleanno',
   'Tanti auguri di buon compleanno da tutto il team di Meridiano 361! Speriamo che il tuo giorno speciale sia pieno di gioia. A presto in negozio!', 2),
  ('compleanno_ambassador',  'Auguri Ambassador + 10% sconto',
   'Tanti auguri di buon compleanno! Come Ambassador di Meridiano 361, in questo mese puoi usufruire del 10% di sconto su una spesa a tua scelta. Vieni a trovarci!', 3),
  ('completamento',          'Tessera completa - sconto disponibile',
   'La tua tessera Meridiano 361 e completa! Hai guadagnato il tuo sconto. Vieni in negozio per utilizzarlo al tuo prossimo acquisto. Grazie per la tua fedelta!', 4);
