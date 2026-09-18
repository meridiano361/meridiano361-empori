-- Dati settimanali per macro-categoria: pezzi venduti e venduto I.E.
-- Compilati ogni lunedì dall'operatore per la settimana appena conclusa.

CREATE TABLE IF NOT EXISTS cassa_settimane_categorie (
  id              BIGSERIAL    PRIMARY KEY,
  emporio         TEXT         NOT NULL,
  iso_year        INTEGER      NOT NULL,
  settimana_iso   INTEGER      NOT NULL,

  -- Alimentari
  ali_pezzi          INTEGER,
  ali_pezzi_25       INTEGER,
  ali_venduto_ie     NUMERIC(10,2),
  ali_venduto_ie_25  NUMERIC(10,2),

  -- Benessere (ex Cosmetica)
  ben_pezzi          INTEGER,
  ben_pezzi_25       INTEGER,
  ben_venduto_ie     NUMERIC(10,2),
  ben_venduto_ie_25  NUMERIC(10,2),

  -- Casa
  cas_pezzi          INTEGER,
  cas_pezzi_25       INTEGER,
  cas_venduto_ie     NUMERIC(10,2),
  cas_venduto_ie_25  NUMERIC(10,2),

  -- Moda
  mod_pezzi          INTEGER,
  mod_pezzi_25       INTEGER,
  mod_venduto_ie     NUMERIC(10,2),
  mod_venduto_ie_25  NUMERIC(10,2),

  -- Altro
  alt_pezzi          INTEGER,
  alt_pezzi_25       INTEGER,
  alt_venduto_ie     NUMERIC(10,2),
  alt_venduto_ie_25  NUMERIC(10,2),

  updated_at      TIMESTAMPTZ  DEFAULT now(),

  UNIQUE(emporio, iso_year, settimana_iso)
);

ALTER TABLE cassa_settimane_categorie ENABLE ROW LEVEL SECURITY;
CREATE POLICY "cat_select" ON cassa_settimane_categorie FOR SELECT USING (true);
CREATE POLICY "cat_insert" ON cassa_settimane_categorie FOR INSERT WITH CHECK (true);
CREATE POLICY "cat_update" ON cassa_settimane_categorie FOR UPDATE USING (true);
