-- Sostituisce le policy semplici con is_active_operatore(), stesso pattern delle altre tabelle
DROP POLICY IF EXISTS "inventario_sessioni_auth" ON public.inventario_sessioni;
DROP POLICY IF EXISTS "inventario_righe_auth"    ON public.inventario_righe;

CREATE POLICY "inventario_sessioni_auth" ON public.inventario_sessioni
  FOR ALL TO authenticated
  USING (is_active_operatore())
  WITH CHECK (is_active_operatore());

CREATE POLICY "inventario_righe_auth" ON public.inventario_righe
  FOR ALL TO authenticated
  USING (is_active_operatore())
  WITH CHECK (is_active_operatore());
