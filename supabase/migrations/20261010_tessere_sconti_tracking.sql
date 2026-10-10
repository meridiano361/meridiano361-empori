-- Tracciamento sconti: tipo su tessere_sconti, campi compleanno su tessere

-- 1. Tipo sconto (tessera = completamento ciclo, compleanno = 10% mese nascita)
ALTER TABLE tessere_sconti ADD COLUMN IF NOT EXISTS tipo text NOT NULL DEFAULT 'tessera';

-- 2. Tracciamento sconto compleanno annuale
ALTER TABLE tessere ADD COLUMN IF NOT EXISTS sconto_compleanno_anno integer;        -- anno in cui è stato usato (es. 2026)
ALTER TABLE tessere ADD COLUMN IF NOT EXISTS sconti_compleanno_totali integer NOT NULL DEFAULT 0;

-- 3. Aggiorna get_tessera_pubblica con nuovi campi + conteggio sconti per tipo
CREATE OR REPLACE FUNCTION get_tessera_pubblica(
  p_token text DEFAULT NULL,
  p_slug  text DEFAULT NULL
)
RETURNS json LANGUAGE sql SECURITY DEFINER STABLE
SET search_path = public AS $$
  SELECT json_build_object(
    'id',                       t.id,
    'token',                    t.token,
    'slug',                     t.slug,
    'codice_tessera',           t.codice_tessera,
    'tipo',                     t.tipo,
    'timbri_attuali',           t.timbri_attuali,
    'timbri_omaggio',           t.timbri_omaggio,
    'cicli_completati',         t.cicli_completati,
    'saldo_sconto',             t.saldo_sconto,
    'totale_spesa',             t.totale_spesa,
    'cliente_id',               t.cliente_id,
    'emporio',                  t.emporio,
    'created_at',               t.created_at,
    'updated_at',               t.updated_at,
    'nome',                     c.nome,
    'cognome',                  c.cognome,
    'data_nascita',             c.data_nascita,
    'sconto_compleanno_anno',   t.sconto_compleanno_anno,
    'sconti_compleanno_totali', t.sconti_compleanno_totali,
    'sconti_tessera_usati',     (
      SELECT COUNT(*) FROM tessere_sconti s
      WHERE s.tessera_id = t.id AND s.tipo = 'tessera'
    )
  )
  FROM tessere t
  JOIN clienti c ON c.id = t.cliente_id
  WHERE
    (p_token IS NOT NULL AND t.token = p_token::uuid)
    OR
    (p_slug IS NOT NULL AND t.slug = p_slug)
  LIMIT 1;
$$;

GRANT EXECUTE ON FUNCTION get_tessera_pubblica TO anon;
GRANT EXECUTE ON FUNCTION get_tessera_pubblica TO authenticated;
