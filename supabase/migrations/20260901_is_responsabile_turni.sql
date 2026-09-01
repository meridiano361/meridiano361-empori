-- Aggiunge flag eccezionale per consentire la modifica dei turni
-- a operatori con ruolo non incluso in RUOLI_FULL (es. ruolo = 'emporio').

ALTER TABLE operatori
  ADD COLUMN IF NOT EXISTS is_responsabile_turni boolean NOT NULL DEFAULT false;

-- Abilita subito per reggioemilia
UPDATE operatori
  SET is_responsabile_turni = true
  WHERE email = 'reggioemilia@meridiano361.it';
