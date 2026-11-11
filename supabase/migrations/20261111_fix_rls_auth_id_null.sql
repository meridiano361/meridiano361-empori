-- Fix: is_admin_user / is_active_operatore / my_emporio falliscono se auth_id è NULL
-- Aggiunge fallback su email dal JWT, così funzionano anche prima che auth_id sia popolato.
-- Backfilla anche auth_id per i record esistenti.

CREATE OR REPLACE FUNCTION is_active_operatore()
RETURNS boolean LANGUAGE sql SECURITY DEFINER STABLE
SET search_path = public AS $$
  SELECT EXISTS (
    SELECT 1 FROM operatori
    WHERE (auth_id = auth.uid() OR email = auth.jwt()->>'email')
      AND attivo = true
  );
$$;

CREATE OR REPLACE FUNCTION my_emporio()
RETURNS text LANGUAGE sql SECURITY DEFINER STABLE
SET search_path = public AS $$
  SELECT emporio FROM operatori
  WHERE (auth_id = auth.uid() OR email = auth.jwt()->>'email')
    AND attivo = true
  LIMIT 1;
$$;

CREATE OR REPLACE FUNCTION is_admin_user()
RETURNS boolean LANGUAGE sql SECURITY DEFINER STABLE
SET search_path = public AS $$
  SELECT EXISTS (
    SELECT 1 FROM operatori
    WHERE (auth_id = auth.uid() OR email = auth.jwt()->>'email')
      AND attivo = true
      AND (
        ruolo = 'admin'
        OR email IN ('emilio.mazzolari@gmail.com', 'e.mazzolari@meridiano361.it')
      )
  );
$$;

-- Backfill auth_id per operatori che hanno un account ma auth_id non ancora popolato
UPDATE operatori o
SET auth_id = u.id
FROM auth.users u
WHERE o.email = u.email
  AND o.auth_id IS NULL;
