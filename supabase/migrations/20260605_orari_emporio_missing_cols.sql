-- Migration: aggiungi colonne mancanti a orari_emporio
-- Corregge:
--   - error: column "orari_emporio.settimana" does not exist
--   - could not find the "sera_chiusura" column of "orari_emporio" in the schema cache
--
-- Sicuro da eseguire più volte grazie a IF NOT EXISTS.
-- Eseguire su Supabase → SQL Editor, poi verificare che i save funzionino.

-- 1. Colonna settimana: numero settimana ISO (1–53), usata per livello='settimanale'
ALTER TABLE public.orari_emporio
  ADD COLUMN IF NOT EXISTS settimana INTEGER;

-- 2. Colonna sera_chiusura: orario di chiusura fascia serale (formato HH:MM)
ALTER TABLE public.orari_emporio
  ADD COLUMN IF NOT EXISTS sera_chiusura TIME;

-- 3. Refresh schema cache PostgREST/Supabase
--    (necessario dopo ogni ALTER TABLE; senza questo le nuove colonne restano invisibili all'API)
NOTIFY pgrst, 'reload schema';
