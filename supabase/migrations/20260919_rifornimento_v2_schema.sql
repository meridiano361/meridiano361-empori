-- ═══════════════════════════════════════════════════════════════
-- RIFORNIMENTO v2 — schema aggiornato
-- Stati: bozza → definitiva → evasa
-- ═══════════════════════════════════════════════════════════════

-- ── 1. rifornimento_proposte: nuovi campi ───────────────────────
ALTER TABLE rifornimento_proposte
  ADD COLUMN IF NOT EXISTS versione   INTEGER     NOT NULL DEFAULT 1,
  ADD COLUMN IF NOT EXISTS evasa_at   TIMESTAMPTZ,
  ADD COLUMN IF NOT EXISTS evasa_da   TEXT,
  ADD COLUMN IF NOT EXISTS evasa_note TEXT;

-- Migra stati precedenti ai nuovi valori
UPDATE rifornimento_proposte SET status = 'definitiva' WHERE status = 'inviata';
UPDATE rifornimento_proposte SET status = 'evasa'      WHERE status IN ('letta', 'archiviata');

-- ── 2. rifornimento_proposte_righe: pvp + ordinamento ──────────
ALTER TABLE rifornimento_proposte_righe
  ADD COLUMN IF NOT EXISTS pvp        NUMERIC(10,2),
  ADD COLUMN IF NOT EXISTS fornitore  TEXT NOT NULL DEFAULT '',
  ADD COLUMN IF NOT EXISTS category   TEXT NOT NULL DEFAULT '',
  ADD COLUMN IF NOT EXISTS sort_order INT  NOT NULL DEFAULT 0;

-- ── 3. Tabella autorizzazioni responsabili ──────────────────────
CREATE TABLE IF NOT EXISTS rifornimento_autorizzati (
  id           BIGSERIAL    PRIMARY KEY,
  operatore_id BIGINT       NOT NULL,
  emporio      TEXT         NOT NULL,
  created_at   TIMESTAMPTZ  NOT NULL DEFAULT now(),
  created_by   TEXT         NOT NULL DEFAULT '',
  UNIQUE(operatore_id, emporio)
);

ALTER TABLE rifornimento_autorizzati ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS rif_aut_select ON rifornimento_autorizzati;
DROP POLICY IF EXISTS rif_aut_all    ON rifornimento_autorizzati;
CREATE POLICY rif_aut_select ON rifornimento_autorizzati FOR SELECT USING (true);
CREATE POLICY rif_aut_all    ON rifornimento_autorizzati FOR ALL   USING (true);

-- ── 4. Log notifiche ────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS rifornimento_notif_log (
  id           BIGSERIAL    PRIMARY KEY,
  proposta_id  BIGINT       NOT NULL,
  versione     INTEGER,
  tipo         TEXT         NOT NULL,  -- push | email
  evento       TEXT         NOT NULL,  -- nuova | modificata | evasa
  destinatario TEXT,
  stato        TEXT         NOT NULL,  -- sent | failed | skipped
  sent_at      TIMESTAMPTZ  NOT NULL DEFAULT now()
);

ALTER TABLE rifornimento_notif_log ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS rif_notif_log_all ON rifornimento_notif_log;
CREATE POLICY rif_notif_log_all ON rifornimento_notif_log FOR ALL USING (true);
