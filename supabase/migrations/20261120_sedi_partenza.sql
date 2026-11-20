-- Tabella sedi di partenza per consegne
CREATE TABLE IF NOT EXISTS sedi_partenza (
  id        serial PRIMARY KEY,
  nome      text NOT NULL,
  indirizzo text,
  comune    text,
  attiva    boolean NOT NULL DEFAULT true,
  ordine    int NOT NULL DEFAULT 0
);

-- Dati iniziali
INSERT INTO sedi_partenza (nome, indirizzo, comune, attiva, ordine) VALUES
  ('Emporio Cremona',       'Via Massarotti 7',              'Cremona',       true, 10),
  ('Emporio Casalmaggiore', 'Via Roma 12',                   'Casalmaggiore', true, 20),
  ('Emporio Mantova',       '',                              'Mantova',       true, 30),
  ('Emporio Reggio Emilia', 'Via Don Giovanni Verità 8',     'Reggio Emilia', true, 40),
  ('Emporio Viadana',       '',                              'Viadana',       true, 50),
  ('Ufficio Cremona',       '',                              'Cremona',       true, 60),
  ('Sede Reggio Emilia',    'Via Don Giovanni Verità 8',     'Reggio Emilia', true, 70)
ON CONFLICT DO NOTHING;

-- RLS: tutti possono leggere, solo authenticated possono modificare
ALTER TABLE sedi_partenza ENABLE ROW LEVEL SECURITY;
CREATE POLICY "sedi_partenza_read"   ON sedi_partenza FOR SELECT USING (true);
CREATE POLICY "sedi_partenza_insert" ON sedi_partenza FOR INSERT TO authenticated WITH CHECK (true);
CREATE POLICY "sedi_partenza_update" ON sedi_partenza FOR UPDATE TO authenticated USING (true) WITH CHECK (true);
CREATE POLICY "sedi_partenza_delete" ON sedi_partenza FOR DELETE TO authenticated USING (true);
