-- Aggiunge tipo_cliente e campi persona di riferimento per aziende
-- Default 'privato' per retro-compatibilità con ordini esistenti.

ALTER TABLE public.ordini_incorso
  ADD COLUMN IF NOT EXISTS tipo_cliente       text NOT NULL DEFAULT 'privato',
  ADD COLUMN IF NOT EXISTS ref_nome           text,
  ADD COLUMN IF NOT EXISTS ref_cognome        text;

ALTER TABLE public.ordini_archiviati
  ADD COLUMN IF NOT EXISTS tipo_cliente       text NOT NULL DEFAULT 'privato',
  ADD COLUMN IF NOT EXISTS ref_nome           text,
  ADD COLUMN IF NOT EXISTS ref_cognome        text;

-- Backfill: ordini con cliente_cognome vuoto erano già aziende
UPDATE public.ordini_incorso
  SET tipo_cliente = 'azienda'
  WHERE (cliente_cognome IS NULL OR cliente_cognome = '');

UPDATE public.ordini_archiviati
  SET tipo_cliente = 'azienda'
  WHERE (cliente_cognome IS NULL OR cliente_cognome = '');
