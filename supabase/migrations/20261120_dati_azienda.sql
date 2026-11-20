-- Tabella dati azienda (riga singola, id=1)
CREATE TABLE IF NOT EXISTS dati_azienda (
  id              int PRIMARY KEY DEFAULT 1 CHECK (id = 1),
  nome            text,
  tipo            text,
  rea             text,
  registro_imprese text,
  cf_piva         text,
  sdi             text,
  indirizzo       text,
  cap             text,
  citta           text,
  provincia       text,
  telefono        text,
  fax             text,
  pec             text,
  banca           text,
  iban            text,
  updated_at      timestamptz DEFAULT now()
);

-- Riga iniziale con i dati attuali
INSERT INTO dati_azienda (id, nome, tipo, rea, registro_imprese, cf_piva, sdi, indirizzo, cap, citta, provincia, telefono, fax, pec, banca, iban)
VALUES (1,
  'MERIDIANO 361 IMPRESA SOCIALE S.R.L. – SOCIO UNICO',
  'Cooperativa sociale',
  'RE – 317691',
  '02834570356',
  '02834570356',
  'USAL8PV',
  'Via Don Giovanni Verità 8',
  '42124',
  'Reggio nell''Emilia',
  'RE',
  '0522 1301463',
  '0522 550611',
  'meridiano361@pec.confcooperative.it',
  'Emil Banca',
  'IT69L0707212803000000417081'
) ON CONFLICT (id) DO NOTHING;

-- RLS: tutti possono leggere, solo authenticated possono aggiornare
ALTER TABLE dati_azienda ENABLE ROW LEVEL SECURITY;
CREATE POLICY "dati_azienda_read"   ON dati_azienda FOR SELECT USING (true);
CREATE POLICY "dati_azienda_update" ON dati_azienda FOR UPDATE TO authenticated USING (true) WITH CHECK (true);
