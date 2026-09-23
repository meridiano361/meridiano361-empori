-- Cambia FK rifornimento_proposte_righe.catalog_product_id da RESTRICT a SET NULL
-- così eliminare un prodotto dal catalogo non blocca la delete
ALTER TABLE rifornimento_proposte_righe
  DROP CONSTRAINT rifornimento_proposte_righe_catalog_product_id_fkey;

ALTER TABLE rifornimento_proposte_righe
  ADD CONSTRAINT rifornimento_proposte_righe_catalog_product_id_fkey
  FOREIGN KEY (catalog_product_id) REFERENCES rifornimento_catalogo(id) ON DELETE SET NULL;
