-- Inserisce preferenza timbrate (push abilitato) per tutti gli operatori che non ce l'hanno ancora
INSERT INTO operatore_notif_prefs (operatore_id, tipo, abilitato, email_abilitato)
SELECT o.id, 'timbrate', true, false
FROM operatori o
WHERE NOT EXISTS (
  SELECT 1 FROM operatore_notif_prefs p
  WHERE p.operatore_id = o.id AND p.tipo = 'timbrate'
);
