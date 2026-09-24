-- Fix policy RLS storage bucket "materiali":
-- le policy CREATE IF NOT EXISTS originali potrebbero essere state skippate se già esistevano,
-- e mancava comunque la policy UPDATE (richiesta da upsert:true nel salvataggio testi).
-- Sostituiamo con una policy unica "FOR ALL" (come già fatto per info-operative).

DROP POLICY IF EXISTS "materiali_select" ON storage.objects;
DROP POLICY IF EXISTS "materiali_insert" ON storage.objects;
DROP POLICY IF EXISTS "materiali_delete" ON storage.objects;
DROP POLICY IF EXISTS "materiali_update" ON storage.objects;
DROP POLICY IF EXISTS "materiali all access"  ON storage.objects;

CREATE POLICY "materiali all access"
ON storage.objects
FOR ALL
USING  (bucket_id = 'materiali')
WITH CHECK (bucket_id = 'materiali');
