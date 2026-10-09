-- Fix to_slug: applicare lower() prima del regexp per non perdere lettere maiuscole
-- Bug: 'Chiara' → '_hiara' perché 'C' non è in [a-z0-9]
CREATE OR REPLACE FUNCTION to_slug(txt TEXT) RETURNS TEXT AS $$
  SELECT regexp_replace(
    trim(both '_' from regexp_replace(lower(unaccent(txt)), '[^a-z0-9]+', '_', 'g')),
    '_+', '_', 'g'
  )
$$ LANGUAGE SQL IMMUTABLE;

-- Rigenera tutti gli slug: prima azzera per evitare conflitti di unicità,
-- poi assegna i nuovi valori corretti con deduplicazione.
BEGIN;

-- Step 1: azzera tutti gli slug
UPDATE tessere SET slug = NULL;

-- Step 2: rigenera con la funzione corretta
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

COMMIT;
