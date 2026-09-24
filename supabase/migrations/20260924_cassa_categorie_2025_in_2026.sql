-- Copia i dati 2025 di cassa_settimane_categorie nelle colonne _25 delle righe iso_year=2026
-- Necessario per mostrare il confronto 2025 nella vista settimanale 2026
-- Eseguire DOPO 20260924_cassa_settimane_cremona_2025_gen_ott.sql

INSERT INTO cassa_settimane_categorie
  (emporio, iso_year, settimana_iso,
   ali_pezzi_25,      ali_venduto_ie_25,
   ben_pezzi_25,      ben_venduto_ie_25,
   cas_pezzi_25,      cas_venduto_ie_25,
   mod_pezzi_25,      mod_venduto_ie_25,
   alt_pezzi_25,      alt_venduto_ie_25)
SELECT
  emporio,
  iso_year + 1,
  settimana_iso,
  ali_pezzi,      ali_venduto_ie,
  ben_pezzi,      ben_venduto_ie,
  cas_pezzi,      cas_venduto_ie,
  mod_pezzi,      mod_venduto_ie,
  alt_pezzi,      alt_venduto_ie
FROM cassa_settimane_categorie
WHERE emporio = 'Cremona' AND iso_year = 2025
ON CONFLICT (emporio, iso_year, settimana_iso) DO UPDATE SET
  ali_pezzi_25      = EXCLUDED.ali_pezzi_25,
  ali_venduto_ie_25 = EXCLUDED.ali_venduto_ie_25,
  ben_pezzi_25      = EXCLUDED.ben_pezzi_25,
  ben_venduto_ie_25 = EXCLUDED.ben_venduto_ie_25,
  cas_pezzi_25      = EXCLUDED.cas_pezzi_25,
  cas_venduto_ie_25 = EXCLUDED.cas_venduto_ie_25,
  mod_pezzi_25      = EXCLUDED.mod_pezzi_25,
  mod_venduto_ie_25 = EXCLUDED.mod_venduto_ie_25,
  alt_pezzi_25      = EXCLUDED.alt_pezzi_25,
  alt_venduto_ie_25 = EXCLUDED.alt_venduto_ie_25,
  updated_at        = now();
