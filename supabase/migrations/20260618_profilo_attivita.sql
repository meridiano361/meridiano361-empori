-- Attività personali nel calendario profilo operatore
CREATE TABLE IF NOT EXISTS profilo_attivita (
  id            uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  operatore_id  uuid,
  operatore_nome text NOT NULL,
  data          date NOT NULL,
  titolo        text NOT NULL,
  tipo          text DEFAULT 'altro',   -- ufficio | formazione | uscita | riposo | altro
  ora_inizio    time,
  ora_fine      time,
  note          text,
  created_at    timestamptz DEFAULT now()
);

GRANT ALL ON profilo_attivita TO anon, authenticated;
ALTER TABLE profilo_attivita DISABLE ROW LEVEL SECURITY;

CREATE INDEX IF NOT EXISTS idx_profilo_attivita_op_data
  ON profilo_attivita (operatore_id, data);
