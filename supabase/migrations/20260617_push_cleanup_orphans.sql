-- Rimuovi subscription push orfane (operatore_nome vuoto e operatore_id null).
-- Queste vengono create quando l'utente registra la push prima di avere
-- una sessione completa (user.nome mancante in localStorage).
DELETE FROM push_subscriptions
WHERE (operatore_nome IS NULL OR operatore_nome = '')
  AND operatore_id IS NULL;
