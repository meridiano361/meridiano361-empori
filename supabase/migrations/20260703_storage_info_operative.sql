-- Bucket Supabase Storage per allegati info operative campagne

INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
  'info-operative',
  'info-operative',
  true,
  20971520,
  ARRAY[
    'application/pdf',
    'application/msword',
    'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
    'application/vnd.ms-excel',
    'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
  ]
)
ON CONFLICT (id) DO NOTHING;

-- Policy unica per tutte le operazioni (progetto usa anon key senza Supabase Auth)
DROP POLICY IF EXISTS "info-operative public read" ON storage.objects;
DROP POLICY IF EXISTS "info-operative anon upload" ON storage.objects;
DROP POLICY IF EXISTS "info-operative anon delete" ON storage.objects;
DROP POLICY IF EXISTS "info-operative all access" ON storage.objects;

CREATE POLICY "info-operative all access"
ON storage.objects
FOR ALL
USING (bucket_id = 'info-operative')
WITH CHECK (bucket_id = 'info-operative');
