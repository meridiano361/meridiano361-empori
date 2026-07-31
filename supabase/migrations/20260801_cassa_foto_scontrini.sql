-- Colonne per foto scontrini di chiusura (RF e POS) per mattino e pomeriggio
ALTER TABLE cassa_giorni ADD COLUMN IF NOT EXISTS mat_foto_rf  TEXT;
ALTER TABLE cassa_giorni ADD COLUMN IF NOT EXISTS mat_foto_pos TEXT;
ALTER TABLE cassa_giorni ADD COLUMN IF NOT EXISTS pom_foto_rf  TEXT;
ALTER TABLE cassa_giorni ADD COLUMN IF NOT EXISTS pom_foto_pos TEXT;

-- Bucket storage per le foto (pubblico, max 10 MB per file, solo immagini)
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES ('cassa-foto', 'cassa-foto', true, 10485760, ARRAY['image/jpeg','image/png','image/webp','image/heic','image/heif'])
ON CONFLICT (id) DO NOTHING;

-- Policy: lettura pubblica
DO $$ BEGIN
  IF NOT EXISTS (SELECT FROM pg_policies WHERE policyname = 'cassa_foto_select' AND schemaname = 'storage') THEN
    CREATE POLICY "cassa_foto_select" ON storage.objects
      FOR SELECT TO public USING (bucket_id = 'cassa-foto');
  END IF;
END $$;

-- Policy: upload per utenti autenticati
DO $$ BEGIN
  IF NOT EXISTS (SELECT FROM pg_policies WHERE policyname = 'cassa_foto_insert' AND schemaname = 'storage') THEN
    CREATE POLICY "cassa_foto_insert" ON storage.objects
      FOR INSERT TO authenticated WITH CHECK (bucket_id = 'cassa-foto');
  END IF;
END $$;

-- Policy: eliminazione per utenti autenticati
DO $$ BEGIN
  IF NOT EXISTS (SELECT FROM pg_policies WHERE policyname = 'cassa_foto_delete' AND schemaname = 'storage') THEN
    CREATE POLICY "cassa_foto_delete" ON storage.objects
      FOR DELETE TO authenticated USING (bucket_id = 'cassa-foto');
  END IF;
END $$;
