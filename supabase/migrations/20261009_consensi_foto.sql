-- Foto consenso cartaceo: storage privato + colonna su clienti

-- 1. Bucket privato per le foto
INSERT INTO storage.buckets (id, name, public)
VALUES ('consensi-foto', 'consensi-foto', false)
ON CONFLICT (id) DO NOTHING;

-- 2. RLS storage: solo operatori autenticati
DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE policyname = 'consensi_foto_select' AND tablename = 'objects' AND schemaname = 'storage') THEN
    CREATE POLICY "consensi_foto_select" ON storage.objects FOR SELECT TO authenticated USING (bucket_id = 'consensi-foto' AND is_active_operatore());
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE policyname = 'consensi_foto_insert' AND tablename = 'objects' AND schemaname = 'storage') THEN
    CREATE POLICY "consensi_foto_insert" ON storage.objects FOR INSERT TO authenticated WITH CHECK (bucket_id = 'consensi-foto' AND is_active_operatore());
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE policyname = 'consensi_foto_update' AND tablename = 'objects' AND schemaname = 'storage') THEN
    CREATE POLICY "consensi_foto_update" ON storage.objects FOR UPDATE TO authenticated USING (bucket_id = 'consensi-foto' AND is_active_operatore());
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE policyname = 'consensi_foto_delete' AND tablename = 'objects' AND schemaname = 'storage') THEN
    CREATE POLICY "consensi_foto_delete" ON storage.objects FOR DELETE TO authenticated USING (bucket_id = 'consensi-foto' AND is_active_operatore());
  END IF;
END $$;

-- 3. Percorso foto sul cliente
ALTER TABLE clienti ADD COLUMN IF NOT EXISTS foto_consenso_path TEXT;
