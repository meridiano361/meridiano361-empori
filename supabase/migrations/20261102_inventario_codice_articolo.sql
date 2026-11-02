-- Aggiunge colonna codice_articolo a inventario_righe
ALTER TABLE public.inventario_righe
  ADD COLUMN IF NOT EXISTS codice_articolo text;
