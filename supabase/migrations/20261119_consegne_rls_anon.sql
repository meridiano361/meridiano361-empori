-- Consegne RLS: apri a anon (coerente col resto dell'app)
-- La pagina ha già un auth-guard a livello applicativo.

DROP POLICY IF EXISTS consegne_select ON consegne;
DROP POLICY IF EXISTS consegne_insert ON consegne;
DROP POLICY IF EXISTS consegne_update ON consegne;
DROP POLICY IF EXISTS consegne_delete ON consegne;

CREATE POLICY "consegne_anon_select" ON consegne FOR SELECT TO anon USING (true);
CREATE POLICY "consegne_anon_insert" ON consegne FOR INSERT TO anon WITH CHECK (true);
CREATE POLICY "consegne_anon_update" ON consegne FOR UPDATE TO anon USING (true) WITH CHECK (true);
CREATE POLICY "consegne_anon_delete" ON consegne FOR DELETE TO anon USING (true);
