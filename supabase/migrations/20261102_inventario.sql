-- Tabelle inventario: sessioni di scansione + righe prodotti
CREATE TABLE IF NOT EXISTS public.inventario_sessioni (
  id          bigserial    PRIMARY KEY,
  emporio     text         NOT NULL,
  operatore   text,
  note        text,
  created_at  timestamptz  NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.inventario_righe (
  id           bigserial      PRIMARY KEY,
  sessione_id  bigint         NOT NULL REFERENCES public.inventario_sessioni(id) ON DELETE CASCADE,
  codice_barre text,
  descrizione  text,
  quantita     numeric(10,3)  NOT NULL DEFAULT 1,
  created_at   timestamptz    NOT NULL DEFAULT now()
);

ALTER TABLE public.inventario_sessioni ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.inventario_righe    ENABLE ROW LEVEL SECURITY;

CREATE POLICY "inventario_sessioni_auth" ON public.inventario_sessioni
  FOR ALL TO authenticated USING (true) WITH CHECK (true);

CREATE POLICY "inventario_righe_auth" ON public.inventario_righe
  FOR ALL TO authenticated USING (true) WITH CHECK (true);
