-- ══════════════════════════════════════════════════════════════════════════════
-- RLS Security — meridiano361-empori
-- Eseguire NEL SUPABASE SQL EDITOR (una volta sola)
-- ══════════════════════════════════════════════════════════════════════════════

-- ── 1. FUNZIONI HELPER (SECURITY DEFINER: bypassano RLS per leggere operatori) ──

CREATE OR REPLACE FUNCTION is_active_operatore()
RETURNS boolean LANGUAGE sql SECURITY DEFINER STABLE
SET search_path = public AS $$
  SELECT EXISTS (
    SELECT 1 FROM operatori
    WHERE auth_id = auth.uid() AND attivo = true
  );
$$;

CREATE OR REPLACE FUNCTION my_emporio()
RETURNS text LANGUAGE sql SECURITY DEFINER STABLE
SET search_path = public AS $$
  SELECT emporio FROM operatori
  WHERE auth_id = auth.uid() AND attivo = true
  LIMIT 1;
$$;

CREATE OR REPLACE FUNCTION is_admin_user()
RETURNS boolean LANGUAGE sql SECURITY DEFINER STABLE
SET search_path = public AS $$
  SELECT EXISTS (
    SELECT 1 FROM operatori
    WHERE auth_id = auth.uid()
      AND attivo = true
      AND (
        ruolo = 'admin'
        OR email IN ('emilio.mazzolari@gmail.com', 'e.mazzolari@meridiano361.it')
      )
  );
$$;

-- ── 2. FUNZIONE PUBBLICA per carta.html (restituisce solo i dati della tessera) ──

CREATE OR REPLACE FUNCTION get_tessera_pubblica(
  p_token text DEFAULT NULL,
  p_slug  text DEFAULT NULL
)
RETURNS json LANGUAGE sql SECURITY DEFINER STABLE
SET search_path = public AS $$
  SELECT json_build_object(
    'id',             t.id,
    'token',          t.token,
    'slug',           t.slug,
    'codice_tessera', t.codice_tessera,
    'tipo',           t.tipo,
    'timbri_attuali', t.timbri_attuali,
    'saldo_sconto',   t.saldo_sconto,
    'totale_spesa',   t.totale_spesa,
    'cliente_id',     t.cliente_id,
    'emporio',        t.emporio,
    'created_at',     t.created_at,
    'updated_at',     t.updated_at,
    'nome',           c.nome,
    'cognome',        c.cognome
  )
  FROM tessere t
  JOIN clienti c ON c.id = t.cliente_id
  WHERE
    (p_token IS NOT NULL AND t.token = p_token)
    OR
    (p_slug IS NOT NULL AND t.slug = p_slug)
  LIMIT 1;
$$;

GRANT EXECUTE ON FUNCTION get_tessera_pubblica TO anon;
GRANT EXECUTE ON FUNCTION get_tessera_pubblica TO authenticated;

-- ── 3. clienti ────────────────────────────────────────────────────────────────

ALTER TABLE clienti ENABLE ROW LEVEL SECURITY;

CREATE POLICY "clienti_select" ON clienti FOR SELECT TO authenticated
  USING (
    is_admin_user()
    OR emporio IS NULL
    OR emporio = my_emporio()
  );

CREATE POLICY "clienti_insert" ON clienti FOR INSERT TO authenticated
  WITH CHECK (
    is_admin_user()
    OR emporio IS NULL
    OR emporio = my_emporio()
  );

CREATE POLICY "clienti_update" ON clienti FOR UPDATE TO authenticated
  USING (is_admin_user() OR emporio IS NULL OR emporio = my_emporio())
  WITH CHECK (is_admin_user() OR emporio IS NULL OR emporio = my_emporio());

CREATE POLICY "clienti_delete" ON clienti FOR DELETE TO authenticated
  USING (is_admin_user() OR emporio IS NULL OR emporio = my_emporio());

-- ── 4. tessere ────────────────────────────────────────────────────────────────

ALTER TABLE tessere ENABLE ROW LEVEL SECURITY;

-- Anon: solo lettura (per carta.html — link fedeltà pubblico)
CREATE POLICY "tessere_anon_select" ON tessere FOR SELECT TO anon
  USING (true);

-- Autenticati: accesso completo filtrato per emporio
CREATE POLICY "tessere_auth_select" ON tessere FOR SELECT TO authenticated
  USING (is_admin_user() OR emporio IS NULL OR emporio = my_emporio());

CREATE POLICY "tessere_auth_insert" ON tessere FOR INSERT TO authenticated
  WITH CHECK (is_admin_user() OR emporio IS NULL OR emporio = my_emporio());

CREATE POLICY "tessere_auth_update" ON tessere FOR UPDATE TO authenticated
  USING (is_admin_user() OR emporio IS NULL OR emporio = my_emporio())
  WITH CHECK (is_admin_user() OR emporio IS NULL OR emporio = my_emporio());

CREATE POLICY "tessere_auth_delete" ON tessere FOR DELETE TO authenticated
  USING (is_admin_user() OR emporio IS NULL OR emporio = my_emporio());

-- ── 5. tessere_sconti ─────────────────────────────────────────────────────────

ALTER TABLE tessere_sconti ENABLE ROW LEVEL SECURITY;

-- Anon: solo lettura (le tessere sono pubbliche, gli sconti sono parte della scheda)
CREATE POLICY "tessere_sconti_anon_select" ON tessere_sconti FOR SELECT TO anon
  USING (true);

CREATE POLICY "tessere_sconti_auth_all" ON tessere_sconti FOR ALL TO authenticated
  USING (is_active_operatore())
  WITH CHECK (is_active_operatore());

-- ── 6. operatori ──────────────────────────────────────────────────────────────

ALTER TABLE operatori ENABLE ROW LEVEL SECURITY;

-- Autenticati: ogni operatore vede sé stesso e i colleghi del suo emporio
CREATE POLICY "operatori_select" ON operatori FOR SELECT TO authenticated
  USING (
    is_admin_user()
    OR auth_id = auth.uid()
    OR (my_emporio() IS NOT NULL AND emporio = my_emporio())
  );

-- Solo admin può scrivere su operatori
CREATE POLICY "operatori_insert" ON operatori FOR INSERT TO authenticated
  WITH CHECK (is_admin_user());

CREATE POLICY "operatori_update" ON operatori FOR UPDATE TO authenticated
  USING (is_admin_user() OR auth_id = auth.uid())
  WITH CHECK (is_admin_user() OR auth_id = auth.uid());

CREATE POLICY "operatori_delete" ON operatori FOR DELETE TO authenticated
  USING (is_admin_user());

-- ── 7. preventivi ─────────────────────────────────────────────────────────────

ALTER TABLE preventivi ENABLE ROW LEVEL SECURITY;

CREATE POLICY "preventivi_auth_all" ON preventivi FOR ALL TO authenticated
  USING (is_active_operatore())
  WITH CHECK (is_active_operatore());

-- ── 8. rifornimento ───────────────────────────────────────────────────────────

ALTER TABLE rifornimento ENABLE ROW LEVEL SECURITY;

CREATE POLICY "rifornimento_auth_all" ON rifornimento FOR ALL TO authenticated
  USING (is_active_operatore())
  WITH CHECK (is_active_operatore());

-- ── 9. rifornimento_proposte ──────────────────────────────────────────────────

ALTER TABLE rifornimento_proposte ENABLE ROW LEVEL SECURITY;

CREATE POLICY "rifornimento_proposte_auth_all" ON rifornimento_proposte FOR ALL TO authenticated
  USING (is_active_operatore())
  WITH CHECK (is_active_operatore());

-- ── 10. info_clienti ──────────────────────────────────────────────────────────

ALTER TABLE info_clienti ENABLE ROW LEVEL SECURITY;

CREATE POLICY "info_clienti_auth_all" ON info_clienti FOR ALL TO authenticated
  USING (is_active_operatore())
  WITH CHECK (is_active_operatore());
