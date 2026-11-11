-- Configurazione parametri tessera digitale (Standard / Ambassador)
CREATE TABLE IF NOT EXISTS public.tessera_config (
  tipo            text PRIMARY KEY CHECK (tipo IN ('standard', 'ambassador')),
  timbri_max      integer NOT NULL DEFAULT 12,
  euro_per_timbro numeric(10,2) NOT NULL DEFAULT 25,
  sconto_ciclo    numeric(10,2) NOT NULL DEFAULT 20,
  colore          text NOT NULL DEFAULT '#B45050',
  stamp_image_url text,
  updated_at      timestamptz DEFAULT now()
);

ALTER TABLE public.tessera_config ENABLE ROW LEVEL SECURITY;

CREATE POLICY "anon_select_tessera_config" ON public.tessera_config
  FOR SELECT TO anon USING (true);
CREATE POLICY "anon_insert_tessera_config" ON public.tessera_config
  FOR INSERT TO anon WITH CHECK (true);
CREATE POLICY "anon_update_tessera_config" ON public.tessera_config
  FOR UPDATE TO anon USING (true) WITH CHECK (true);

INSERT INTO public.tessera_config (tipo, timbri_max, euro_per_timbro, sconto_ciclo, colore, stamp_image_url)
VALUES
  ('standard',   12, 25, 20, '#B45050', '/assets/images/simbolo_m361_std.png'),
  ('ambassador', 12, 30, 25, '#111111', '/assets/images/simbolo_m361.png')
ON CONFLICT (tipo) DO NOTHING;
