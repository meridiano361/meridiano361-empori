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

-- Lettura pubblica
CREATE POLICY "info-operative public read"
ON storage.objects FOR SELECT TO anon
USING (bucket_id = 'info-operative');

-- Upload per utenti autenticati via anon key
CREATE POLICY "info-operative anon upload"
ON storage.objects FOR INSERT TO anon
WITH CHECK (bucket_id = 'info-operative');

-- Eliminazione (opzionale, per rimuovere file vecchi)
CREATE POLICY "info-operative anon delete"
ON storage.objects FOR DELETE TO anon
USING (bucket_id = 'info-operative');
