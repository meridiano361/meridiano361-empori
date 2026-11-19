-- Walid (fattorino): blocca sezioni mancanti e disabilita notifiche non pertinenti

-- Sezioni mancanti → nasconde
INSERT INTO utenti_permessi (utente_id, sezione, può_vedere, può_operare)
VALUES
  ('136ee9da-b60f-403b-b7fc-13b0aba5f061', 'analisi-commerciale', false, false),
  ('136ee9da-b60f-403b-b7fc-13b0aba5f061', 'archiviati',          false, false),
  ('136ee9da-b60f-403b-b7fc-13b0aba5f061', 'nuovo_ordine',        false, false),
  ('136ee9da-b60f-403b-b7fc-13b0aba5f061', 'preordini',           false, false),
  ('136ee9da-b60f-403b-b7fc-13b0aba5f061', 'rifornimento',        false, false)
ON CONFLICT DO NOTHING;

-- Notifiche: disabilita tutto tranne le consegne (gestite da send-consegne-reminder)
INSERT INTO operatore_notif_prefs (operatore_id, tipo, abilitato, email_abilitato)
VALUES
  ('136ee9da-b60f-403b-b7fc-13b0aba5f061', 'generali',  false, false),
  ('136ee9da-b60f-403b-b7fc-13b0aba5f061', 'ordini',    false, false),
  ('136ee9da-b60f-403b-b7fc-13b0aba5f061', 'timbrate',  false, false),
  ('136ee9da-b60f-403b-b7fc-13b0aba5f061', 'turni',     false, false)
ON CONFLICT DO NOTHING;
