-- Aggiunge GRANT mancanti per le tabelle inventario (necessari con RLS TO authenticated)
GRANT SELECT, INSERT, UPDATE, DELETE ON public.inventario_sessioni TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.inventario_righe    TO authenticated;
GRANT USAGE, SELECT ON SEQUENCE public.inventario_sessioni_id_seq  TO authenticated;
GRANT USAGE, SELECT ON SEQUENCE public.inventario_righe_id_seq     TO authenticated;
