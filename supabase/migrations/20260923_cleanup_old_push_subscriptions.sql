-- Rimuove token push non aggiornati da più di 30 giorni
DELETE FROM push_subscriptions
WHERE last_seen_at < NOW() - INTERVAL '30 days'
   OR (last_seen_at IS NULL AND updated_at < NOW() - INTERVAL '30 days');
