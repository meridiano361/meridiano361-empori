-- Rimuove le righe 'Cremona' (parziali/errate) e rinomina 'cremona' → 'Cremona'
BEGIN;

DELETE FROM cassa_settimane_categorie
WHERE emporio = 'Cremona';

UPDATE cassa_settimane_categorie
SET emporio = 'Cremona'
WHERE emporio = 'cremona';

COMMIT;
