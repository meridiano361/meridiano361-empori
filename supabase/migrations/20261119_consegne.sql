-- ══════════════════════════════════════════════════════════════════════
-- Consegne fattorino — 2026-11-19
-- Tabella per pianificare trasferimenti tra empori, consegne a clienti
-- privati e ad aziende.
-- ══════════════════════════════════════════════════════════════════════

CREATE TABLE IF NOT EXISTS consegne (
  id                           uuid         PRIMARY KEY DEFAULT gen_random_uuid(),
  created_at                   timestamptz  NOT NULL DEFAULT now(),
  updated_at                   timestamptz  NOT NULL DEFAULT now(),

  -- Pianificazione temporale
  data_consegna                date         NOT NULL,
  ora_prevista                 time,
  ora_fine                     time,            -- fine fascia oraria

  -- Emporio mittente
  emporio_partenza             text         NOT NULL,

  -- Tipo di destinazione
  tipo_destinazione            text         NOT NULL DEFAULT 'cliente'
                               CHECK (tipo_destinazione IN ('emporio','cliente','azienda')),

  -- Destinazione: emporio (trasferimento)
  emporio_destinazione         text,

  -- Destinazione: cliente / azienda
  destinatario_nome            text,
  destinatario_telefono        text,
  destinatario_indirizzo       text,
  destinatario_citta           text,
  destinatario_cap             text,
  destinatario_note_indirizzo  text,

  -- Merce
  merce                        text,
  colli                        integer,
  note_merce                   text,

  -- Assegnazione
  fattorino                    text,

  -- Stato del ciclo di vita della consegna
  stato                        text         NOT NULL DEFAULT 'da_programmare'
                               CHECK (stato IN (
                                 'da_programmare','programmato','in_consegna',
                                 'consegnato','rinviato','annullato'
                               )),
  completato_at                timestamptz,
  rinviato_at                  timestamptz,
  data_rinvio                  date,
  motivo                       text,          -- motivo rinvio/annullamento

  -- Note operative generali
  note                         text,

  -- Metadata
  creato_da                    text           -- email dell'operatore che ha creato
);

-- ── Indici ───────────────────────────────────────────────────────────
CREATE INDEX IF NOT EXISTS idx_consegne_data     ON consegne(data_consegna);
CREATE INDEX IF NOT EXISTS idx_consegne_stato    ON consegne(stato);
CREATE INDEX IF NOT EXISTS idx_consegne_partenza ON consegne(emporio_partenza);
CREATE INDEX IF NOT EXISTS idx_consegne_fatt     ON consegne(fattorino);

-- ── Trigger updated_at ───────────────────────────────────────────────
CREATE OR REPLACE FUNCTION _consegne_set_updated_at()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN NEW.updated_at = now(); RETURN NEW; END;
$$;

DROP TRIGGER IF EXISTS trg_consegne_updated_at ON consegne;
CREATE TRIGGER trg_consegne_updated_at
  BEFORE UPDATE ON consegne
  FOR EACH ROW EXECUTE FUNCTION _consegne_set_updated_at();

-- ── RLS ──────────────────────────────────────────────────────────────
ALTER TABLE consegne ENABLE ROW LEVEL SECURITY;

-- Fase 1: accesso riservato agli admin (is_admin_user = ruolo admin
--         oppure email emilio.mazzolari@gmail.com / e.mazzolari@meridiano361.it).
--
-- Fase 2 (futuro): per estendere l'accesso al fattorino o ad altri
--   operatori autorizzati, modificare le policy aggiungendo condizioni
--   come:  OR (auth.uid() IN (SELECT auth_id FROM operatori WHERE ...))
--   oppure usando una colonna dedicata su operatori (es. can_consegne BOOLEAN).

DROP POLICY IF EXISTS consegne_select ON consegne;
DROP POLICY IF EXISTS consegne_insert ON consegne;
DROP POLICY IF EXISTS consegne_update ON consegne;
DROP POLICY IF EXISTS consegne_delete ON consegne;

CREATE POLICY consegne_select ON consegne FOR SELECT  USING     (is_admin_user());
CREATE POLICY consegne_insert ON consegne FOR INSERT  WITH CHECK (is_admin_user());
CREATE POLICY consegne_update ON consegne FOR UPDATE  USING     (is_admin_user()) WITH CHECK (is_admin_user());
CREATE POLICY consegne_delete ON consegne FOR DELETE  USING     (is_admin_user());
