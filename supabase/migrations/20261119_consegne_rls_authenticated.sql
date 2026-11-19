-- Aggiungi policy RLS per il ruolo authenticated (utenti con sessione Supabase Auth)
CREATE POLICY "consegne_auth_select" ON consegne FOR SELECT TO authenticated USING (true);
CREATE POLICY "consegne_auth_insert" ON consegne FOR INSERT TO authenticated WITH CHECK (true);
CREATE POLICY "consegne_auth_update" ON consegne FOR UPDATE TO authenticated USING (true) WITH CHECK (true);
CREATE POLICY "consegne_auth_delete" ON consegne FOR DELETE TO authenticated USING (true);
