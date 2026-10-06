-- Fix RLS: preordini_foto e preordini_allegati usavano TO authenticated
-- ma l'app gira con chiave anon → le query ritornavano sempre vuote.
-- Aggiunge policy anon e grant necessari.

-- ── preordini_foto ────────────────────────────────────────────────────────────
DROP POLICY IF EXISTS "preordini_foto_select" ON preordini_foto;
DROP POLICY IF EXISTS "preordini_foto_all"    ON preordini_foto;

CREATE POLICY "preordini_foto_all"
  ON preordini_foto FOR ALL TO anon, authenticated USING (true) WITH CHECK (true);

GRANT SELECT, INSERT, UPDATE, DELETE ON preordini_foto TO anon;

-- ── preordini_allegati ────────────────────────────────────────────────────────
DROP POLICY IF EXISTS "allegati_read"   ON preordini_allegati;
DROP POLICY IF EXISTS "allegati_insert" ON preordini_allegati;
DROP POLICY IF EXISTS "allegati_delete" ON preordini_allegati;

CREATE POLICY "allegati_all"
  ON preordini_allegati FOR ALL TO anon, authenticated USING (true) WITH CHECK (true);

GRANT SELECT, INSERT, UPDATE, DELETE ON preordini_allegati TO anon;
