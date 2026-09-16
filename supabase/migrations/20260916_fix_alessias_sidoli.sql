-- Fix "AlessiaS Sidoli" → "Alessia Sidoli" (operatrice usava nome storpiato per evitare conflitti)

-- 1. Tabella operatori
UPDATE operatori
SET nome = 'Alessia Sidoli'
WHERE nome = 'AlessiaS Sidoli';

-- 2. Colonna operatori (JSONB array) nella tabella turni
UPDATE turni
SET operatori = (
  SELECT jsonb_agg(
    CASE
      WHEN op->>'nome' = 'AlessiaS Sidoli'
      THEN jsonb_set(op, '{nome}', '"Alessia Sidoli"')
      ELSE op
    END
  )
  FROM jsonb_array_elements(operatori) AS op
)
WHERE operatori IS NOT NULL AND operatori::text LIKE '%AlessiaS Sidoli%';

-- 3. Colonna assenze (JSONB object) nella tabella turni: i nomi sono nelle chiavi
UPDATE turni
SET assenze = (
  SELECT jsonb_object_agg(
    replace(key, 'AlessiaS Sidoli', 'Alessia Sidoli'),
    value
  )
  FROM jsonb_each(assenze)
)
WHERE assenze IS NOT NULL AND assenze::text LIKE '%AlessiaS Sidoli%';
