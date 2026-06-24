-- ─────────────────────────────────────────────────────────────────────────────
-- 20260623_login_assets.sql
-- Storage bucket per immagini login + valori default per tutte le
-- impostazioni di personalizzazione della pagina di accesso.
-- ─────────────────────────────────────────────────────────────────────────────

-- ── Storage bucket pubblico per le immagini della pagina login ───────────────
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
  'login-assets',
  'login-assets',
  true,
  5242880,
  ARRAY['image/jpeg','image/jpg','image/png','image/webp','image/gif','image/svg+xml']
)
ON CONFLICT (id) DO NOTHING;

-- Lettura pubblica (la login la usa senza autenticazione)
DO $$ BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE schemaname = 'storage' AND tablename = 'objects'
      AND policyname = 'login_assets_public_read'
  ) THEN
    CREATE POLICY "login_assets_public_read" ON storage.objects
      FOR SELECT USING (bucket_id = 'login-assets');
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE schemaname = 'storage' AND tablename = 'objects'
      AND policyname = 'login_assets_auth_insert'
  ) THEN
    CREATE POLICY "login_assets_auth_insert" ON storage.objects
      FOR INSERT TO authenticated WITH CHECK (bucket_id = 'login-assets');
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE schemaname = 'storage' AND tablename = 'objects'
      AND policyname = 'login_assets_auth_delete'
  ) THEN
    CREATE POLICY "login_assets_auth_delete" ON storage.objects
      FOR DELETE TO authenticated USING (bucket_id = 'login-assets');
  END IF;
END $$;

-- ── Valori di default per tutte le impostazioni di personalizzazione login ────
INSERT INTO public.app_settings (key, value) VALUES
  ('login_left_bg_color',  '#B5453A'),
  ('login_left_image_url', ''),
  ('login_left_logo_url',  ''),
  ('login_title',          'Gestire l''emporio, con cura.'),
  ('login_btn_text',       'Accedi'),
  ('login_btn_color',      '#B5453A'),
  ('login_link1_text',     'Richiedi credenziali di accesso'),
  ('login_link1_url',      '/richiedi-accesso.html'),
  ('login_link2_text',     'Ho dimenticato la password')
ON CONFLICT (key) DO NOTHING;

-- Aggiorna il testo caption al nuovo default
UPDATE public.app_settings
SET value = 'Il portale riservato agli operatori degli empori di Meridiano 361',
    updated_at = now()
WHERE key = 'login_caption'
  AND value IN ('', 'piattaforma gestione empori');
