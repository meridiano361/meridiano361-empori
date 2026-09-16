-- Preventivi clienti
CREATE TABLE IF NOT EXISTS preventivi (
  id                 bigserial    PRIMARY KEY,
  created_at         timestamptz  NOT NULL DEFAULT now(),
  numero_preventivo  text         NOT NULL,
  tipo_ordine        text         NOT NULL DEFAULT 'standard',
  emporio            text         NOT NULL,
  canale             text,
  operatore          text,
  data_preventivo    date         NOT NULL,
  cliente_nome       text,
  cliente_cognome    text,
  cliente_cellulare  text,
  cliente_email      text,
  wa_attivo          boolean      NOT NULL DEFAULT true,
  modalita_consegna  text         NOT NULL DEFAULT 'Ritiro',
  totale             numeric(10,2) NOT NULL DEFAULT 0,
  acconto            numeric(10,2) NOT NULL DEFAULT 0,
  da_pagare          numeric(10,2) NOT NULL DEFAULT 0,
  note               text,
  articoli           jsonb        NOT NULL DEFAULT '[]',
  titolo             text,
  stato              text         NOT NULL DEFAULT 'bozza',
  ordine_id          text,
  data_modifica      timestamptz  NOT NULL DEFAULT now()
);

ALTER TABLE preventivi ENABLE ROW LEVEL SECURITY;

CREATE POLICY "anon_all_preventivi" ON preventivi
  FOR ALL TO anon USING (true) WITH CHECK (true);

GRANT SELECT, INSERT, UPDATE, DELETE ON preventivi TO anon;
GRANT USAGE, SELECT ON SEQUENCE preventivi_id_seq TO anon;
