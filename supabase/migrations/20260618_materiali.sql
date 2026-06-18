-- Bucket storage (pubblico per lettura, restrizione upload gestita a livello app)
INSERT INTO storage.buckets (id, name, public)
VALUES ('materiali', 'materiali', true)
ON CONFLICT (id) DO NOTHING;

-- Policies storage
CREATE POLICY IF NOT EXISTS "materiali_select" ON storage.objects
  FOR SELECT USING (bucket_id = 'materiali');
CREATE POLICY IF NOT EXISTS "materiali_insert" ON storage.objects
  FOR INSERT WITH CHECK (bucket_id = 'materiali');
CREATE POLICY IF NOT EXISTS "materiali_delete" ON storage.objects
  FOR DELETE USING (bucket_id = 'materiali');

-- Tabella cartelle
CREATE TABLE IF NOT EXISTS materiali_cartelle (
  id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  nome text NOT NULL,
  parent_id uuid REFERENCES materiali_cartelle(id) ON DELETE CASCADE,
  ordine int DEFAULT 0,
  created_at timestamptz DEFAULT now()
);

-- Tabella file
CREATE TABLE IF NOT EXISTS materiali_file (
  id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  cartella_id uuid REFERENCES materiali_cartelle(id) ON DELETE SET NULL,
  nome text NOT NULL,
  storage_path text NOT NULL UNIQUE,
  dimensione bigint,
  tipo_mime text,
  created_at timestamptz DEFAULT now(),
  created_by text
);

GRANT ALL ON materiali_cartelle TO anon, authenticated;
GRANT ALL ON materiali_file TO anon, authenticated;
