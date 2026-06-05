-- ── Normalizza email operatori a lowercase ────────────────────────────────
-- Eseguire UNA SOLA VOLTA in Supabase SQL Editor.
-- Prima mostra eventuali duplicati per revisione manuale, poi normalizza.

-- 1. Audit: mostra email duplicate (da risolvere manualmente se presenti)
SELECT lower(trim(email)) AS email_norm, count(*) AS occorrenze, array_agg(id) AS ids, array_agg(nome) AS nomi
FROM operatori
WHERE email IS NOT NULL
GROUP BY lower(trim(email))
HAVING count(*) > 1;

-- 2. Normalizza tutte le email a lowercase/trim (safe se non ci sono duplicati)
UPDATE operatori
SET email = lower(trim(email))
WHERE email IS NOT NULL
  AND email <> lower(trim(email));

-- 3. Forza reload schema PostgREST (buona pratica dopo modifiche ai dati)
NOTIFY pgrst, 'reload schema';
