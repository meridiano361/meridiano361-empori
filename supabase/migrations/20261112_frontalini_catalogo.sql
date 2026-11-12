-- Catalogo prodotti per la stampa dei frontalini
-- Separato da prezzi_da_fare che è solo una checklist.
-- unita: 'g','kg','ml','L','pz' o NULL (da confermare)

CREATE TABLE IF NOT EXISTS public.frontalini_catalogo (
  id              BIGSERIAL PRIMARY KEY,
  codice          TEXT,
  descrizione     TEXT NOT NULL,
  peso            NUMERIC,
  unita           TEXT CHECK (unita IN ('g','kg','ml','L','pz') OR unita IS NULL),
  prezzo          NUMERIC,
  fornitore       TEXT,
  marchio         TEXT,
  bio             BOOLEAN NOT NULL DEFAULT FALSE,
  senza_glutine   BOOLEAN NOT NULL DEFAULT FALSE,
  vegano          BOOLEAN NOT NULL DEFAULT FALSE,
  solidale_italiano BOOLEAN NOT NULL DEFAULT FALSE,
  note            TEXT,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

ALTER TABLE public.frontalini_catalogo ENABLE ROW LEVEL SECURITY;

CREATE POLICY "read_frontalini_catalogo" ON public.frontalini_catalogo
  FOR SELECT TO authenticated USING (true);

CREATE POLICY "admin_write_frontalini_catalogo" ON public.frontalini_catalogo
  FOR ALL TO authenticated
  USING (is_admin_user()) WITH CHECK (is_admin_user());

-- Trigger updated_at
CREATE OR REPLACE FUNCTION public.set_updated_at()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN NEW.updated_at = NOW(); RETURN NEW; END;
$$;

CREATE TRIGGER frontalini_catalogo_updated_at
  BEFORE UPDATE ON public.frontalini_catalogo
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();
