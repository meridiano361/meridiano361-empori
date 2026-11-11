-- Aggiunge policy RLS per authenticated su tessera_config
-- Le policy anon esistenti coprono la lettura pubblica (carta.html),
-- queste coprono la scrittura dal pannello admin.

CREATE POLICY "auth_update_tessera_config" ON public.tessera_config
  FOR UPDATE TO authenticated USING (is_admin_user()) WITH CHECK (is_admin_user());

CREATE POLICY "auth_insert_tessera_config" ON public.tessera_config
  FOR INSERT TO authenticated WITH CHECK (is_admin_user());
