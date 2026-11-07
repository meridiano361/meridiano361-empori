-- Separa il catalogo prodotti (Cose) dalla lista della spesa attiva (Lista)
-- in_lista=true → il prodotto è nella lista da acquistare corrente
-- in_lista=false → il prodotto è solo nel catalogo (Cose)
ALTER TABLE lista_spesa_voci
  ADD COLUMN IF NOT EXISTS in_lista boolean not null default false;
