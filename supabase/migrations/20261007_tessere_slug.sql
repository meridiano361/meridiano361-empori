-- Slug personalizzato per tessere: /tessera/nome_cognome

CREATE EXTENSION IF NOT EXISTS unaccent;

-- Helper immutabile per generare slug da testo libero
CREATE OR REPLACE FUNCTION to_slug(txt TEXT) RETURNS TEXT AS $$
  SELECT lower(regexp_replace(trim(both '_' from regexp_replace(unaccent(txt), '[^a-z0-9]+', '_', 'g')), '_+', '_', 'g'))
$$ LANGUAGE SQL IMMUTABLE;

-- Colonna slug
ALTER TABLE tessere ADD COLUMN IF NOT EXISTS slug TEXT;

-- Genera slug per le tessere esistenti (gestisce duplicati con suffisso _2, _3 …)
WITH base AS (
  SELECT
    t.id,
    to_slug(COALESCE(NULLIF(TRIM(c.nome),''),'x') || '_' || COALESCE(NULLIF(TRIM(c.cognome),''),'x')) AS base_slug,
    t.created_at
  FROM tessere t
  JOIN clienti c ON c.id = t.cliente_id
),
ranked AS (
  SELECT
    id,
    base_slug,
    ROW_NUMBER() OVER (PARTITION BY base_slug ORDER BY created_at) AS rn
  FROM base
)
UPDATE tessere t
SET slug = CASE WHEN r.rn = 1 THEN r.base_slug
                ELSE r.base_slug || '_' || r.rn::text
           END
FROM ranked r
WHERE t.id = r.id;

-- Vincolo di unicità
ALTER TABLE tessere ADD CONSTRAINT tessere_slug_unique UNIQUE (slug);

-- Trigger: assegna slug automaticamente alle nuove tessere
CREATE OR REPLACE FUNCTION assign_tessera_slug()
RETURNS TRIGGER AS $$
DECLARE
  base_slug TEXT;
  final_slug TEXT;
  counter INT := 1;
BEGIN
  IF NEW.slug IS NOT NULL THEN RETURN NEW; END IF;

  SELECT to_slug(
    COALESCE(NULLIF(TRIM(c.nome),''),'x') || '_' ||
    COALESCE(NULLIF(TRIM(c.cognome),''),'x')
  )
  INTO base_slug
  FROM clienti c WHERE c.id = NEW.cliente_id;

  final_slug := base_slug;
  WHILE EXISTS (SELECT 1 FROM tessere WHERE slug = final_slug) LOOP
    counter := counter + 1;
    final_slug := base_slug || '_' || counter::text;
  END LOOP;

  NEW.slug := final_slug;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS before_insert_tessera_slug ON tessere;
CREATE TRIGGER before_insert_tessera_slug
  BEFORE INSERT ON tessere
  FOR EACH ROW
  EXECUTE FUNCTION assign_tessera_slug();
