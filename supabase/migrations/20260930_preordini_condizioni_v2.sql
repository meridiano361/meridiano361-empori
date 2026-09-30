-- Soglie per categoria (es. min €1000 per Ricorrenze, min €250 per Vini)
ALTER TABLE preordini_campagne
  ADD COLUMN IF NOT EXISTS soglie_categoria JSONB,
  ADD COLUMN IF NOT EXISTS regola_collo     BOOLEAN DEFAULT false;
-- soglie_categoria: [{id, label, importo_min, descrizione}]
-- regola_collo: se true, ogni referenza con qty>0 deve avere qty >= 1 conf per avere lo sconto
