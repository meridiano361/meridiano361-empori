-- Fix 1: aggiungi vincolo UNIQUE(proposal_id, product_code) necessario per l'upsert
ALTER TABLE rifornimento_proposte_righe
  ADD CONSTRAINT uq_rifornimento_righe_proposal_product
  UNIQUE (proposal_id, product_code);

-- Fix 2: rimuovi il FK su catalog_product_id che puntava a rifornimento_catalogo
-- (la pagina usa prodotti_catalogo, non rifornimento_catalogo)
ALTER TABLE rifornimento_proposte_righe
  DROP CONSTRAINT IF EXISTS rifornimento_proposte_righe_catalog_product_id_fkey;
