-- Tabella recensioni tessera digitale
-- Una riga per acquisto (token + data_acquisto = unique).
-- Anon insert per pagina pubblica; authenticated select/delete per operatori.

DO $$
BEGIN
  IF NOT EXISTS (SELECT FROM information_schema.tables
                 WHERE table_schema = 'public' AND table_name = 'tessera_recensioni') THEN

    CREATE TABLE public.tessera_recensioni (
      id            uuid DEFAULT gen_random_uuid() PRIMARY KEY,
      tessera_token text NOT NULL,
      emporio       text,
      nome_cliente  text,
      rating        integer NOT NULL CHECK (rating BETWEEN 1 AND 5),
      data_acquisto date,
      created_at    timestamptz DEFAULT now(),
      CONSTRAINT tessera_recensioni_token_data_unique UNIQUE (tessera_token, data_acquisto)
    );

    ALTER TABLE public.tessera_recensioni ENABLE ROW LEVEL SECURITY;

    CREATE POLICY "anon_insert_reviews" ON public.tessera_recensioni
      FOR INSERT TO anon WITH CHECK (true);
    CREATE POLICY "anon_select_reviews" ON public.tessera_recensioni
      FOR SELECT TO anon USING (true);
    CREATE POLICY "anon_delete_reviews" ON public.tessera_recensioni
      FOR DELETE TO anon USING (true);

  ELSE
    -- Aggiornamento schema esistente (v1 → v2)
    ALTER TABLE public.tessera_recensioni DROP CONSTRAINT IF EXISTS tessera_recensioni_token_unique;
    ALTER TABLE public.tessera_recensioni DROP COLUMN   IF EXISTS updated_at;
    ALTER TABLE public.tessera_recensioni ADD  COLUMN   IF NOT EXISTS data_acquisto date;
    ALTER TABLE public.tessera_recensioni DROP CONSTRAINT IF EXISTS tessera_recensioni_token_data_unique;
    ALTER TABLE public.tessera_recensioni ADD  CONSTRAINT tessera_recensioni_token_data_unique
      UNIQUE (tessera_token, data_acquisto);
  END IF;
END $$;
