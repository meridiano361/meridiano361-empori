-- Tabella recensioni tessera digitale
-- Ogni tessera può lasciare una sola valutazione (upsert by tessera_token).
-- Anon insert/update per pagina pubblica; authenticated select per report operatori.

CREATE TABLE IF NOT EXISTS public.tessera_recensioni (
  id            uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  tessera_token text NOT NULL,
  emporio       text,
  nome_cliente  text,
  rating        integer NOT NULL CHECK (rating BETWEEN 1 AND 5),
  created_at    timestamptz DEFAULT now(),
  updated_at    timestamptz DEFAULT now(),
  CONSTRAINT tessera_recensioni_token_unique UNIQUE (tessera_token)
);

ALTER TABLE public.tessera_recensioni ENABLE ROW LEVEL SECURITY;

CREATE POLICY "anon_insert_reviews"  ON public.tessera_recensioni FOR INSERT TO anon            WITH CHECK (true);
CREATE POLICY "anon_update_reviews"  ON public.tessera_recensioni FOR UPDATE TO anon            USING (true) WITH CHECK (true);
CREATE POLICY "auth_select_reviews"  ON public.tessera_recensioni FOR SELECT TO authenticated   USING (true);
CREATE POLICY "auth_delete_reviews"  ON public.tessera_recensioni FOR DELETE TO authenticated   USING (true);
