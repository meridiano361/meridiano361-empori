-- Fix RLS su cassa_giorni: permetti a tutti gli operatori attivi dello stesso emporio
-- di fare SELECT/INSERT/UPDATE/DELETE. Prima drop delle policy esistenti (se presenti).

ALTER TABLE cassa_giorni ENABLE ROW LEVEL SECURITY;

-- Rimuovi policy esistenti (ignora errori se non esistono)
DO $$ BEGIN
  DROP POLICY IF EXISTS "cassa_giorni_select"          ON cassa_giorni;
  DROP POLICY IF EXISTS "cassa_giorni_insert"          ON cassa_giorni;
  DROP POLICY IF EXISTS "cassa_giorni_update"          ON cassa_giorni;
  DROP POLICY IF EXISTS "cassa_giorni_delete"          ON cassa_giorni;
  DROP POLICY IF EXISTS "cassa_giorni_all"             ON cassa_giorni;
  DROP POLICY IF EXISTS "Enable read access for all users" ON cassa_giorni;
  DROP POLICY IF EXISTS "Enable insert for authenticated users only" ON cassa_giorni;
  DROP POLICY IF EXISTS "Enable update for authenticated users only" ON cassa_giorni;
EXCEPTION WHEN others THEN NULL;
END $$;

-- SELECT: admin vede tutto, operatori attivi vedono solo il loro emporio
CREATE POLICY "cassa_giorni_select" ON cassa_giorni FOR SELECT TO authenticated
  USING (
    is_admin_user()
    OR (is_active_operatore() AND emporio = my_emporio())
  );

-- INSERT: admin ovunque, operatori attivi solo per il loro emporio
CREATE POLICY "cassa_giorni_insert" ON cassa_giorni FOR INSERT TO authenticated
  WITH CHECK (
    is_admin_user()
    OR (is_active_operatore() AND emporio = my_emporio())
  );

-- UPDATE: stessa logica
CREATE POLICY "cassa_giorni_update" ON cassa_giorni FOR UPDATE TO authenticated
  USING (
    is_admin_user()
    OR (is_active_operatore() AND emporio = my_emporio())
  )
  WITH CHECK (
    is_admin_user()
    OR (is_active_operatore() AND emporio = my_emporio())
  );

-- DELETE: solo admin
CREATE POLICY "cassa_giorni_delete" ON cassa_giorni FOR DELETE TO authenticated
  USING (is_admin_user());
