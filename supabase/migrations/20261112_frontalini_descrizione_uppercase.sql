-- Converti tutte le descrizioni esistenti in maiuscolo
UPDATE public.frontalini_catalogo
SET descrizione = UPPER(descrizione)
WHERE descrizione <> UPPER(descrizione);
