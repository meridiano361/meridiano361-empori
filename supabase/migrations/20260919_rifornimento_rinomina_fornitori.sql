-- Rinomina fornitori hub → nomi completi nel catalogo rifornimento
UPDATE rifornimento_catalogo SET fornitore = 'Vasetti Riccardo' WHERE fornitore = 'Hub VR';
UPDATE rifornimento_catalogo SET fornitore = 'Valdibella'       WHERE fornitore = 'Hub VA';
