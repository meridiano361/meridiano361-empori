-- Fix: rimozione zero finale errato dai numeri di cellulare
-- 675 clienti (principalmente tessere 2020-21) avevano uno 0 in eccesso alla fine del telefono
-- es. 32979197060 → 3297919706
-- Correzione già applicata via script il 21/10/2026; questa migration è per tracciabilità.

UPDATE clienti
SET telefono = left(telefono, length(telefono) - 1)
WHERE telefono ~ '^3[0-9]{9}0$';
