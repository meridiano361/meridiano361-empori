-- Disabilita RLS sulle tabelle materiali (app interna, auth gestita lato app)
-- Senza questo, UPDATE/DELETE con chiave anon vengono bloccati silenziosamente
ALTER TABLE materiali_file      DISABLE ROW LEVEL SECURITY;
ALTER TABLE materiali_cartelle  DISABLE ROW LEVEL SECURITY;
