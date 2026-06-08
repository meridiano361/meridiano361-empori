-- Aggiunge l'operatore/gestionale di Mantova
INSERT INTO operatori (
  nome, emporio, ruolo,
  email, attivo
) VALUES (
  'Emporio Mantova',
  'Mantova',
  'emporio',
  'mantova@meridiano361.it',
  true
)
ON CONFLICT (email) DO UPDATE SET
  emporio = 'Mantova',
  attivo  = true;
