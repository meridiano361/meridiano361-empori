-- Fix: tessere con tipo='standard' che appartengono a clienti ambassador.
-- Un cliente è ambassador se ha almeno una tessera con tipo='ambassador'.
-- Questo update corregge le tessere standard create per errore (es. via conversione digitale).

UPDATE tessere t_std
SET tipo = 'ambassador'
WHERE t_std.tipo = 'standard'
  AND EXISTS (
    SELECT 1 FROM tessere t_amb
    WHERE t_amb.cliente_id = t_std.cliente_id
      AND t_amb.tipo = 'ambassador'
  );
