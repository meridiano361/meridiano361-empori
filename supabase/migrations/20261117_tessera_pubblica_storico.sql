-- Aggiunge movimenti_list e cicli_list a get_tessera_pubblica
-- Permette alla carta digitale di mostrare lo storico acquisti e timbri

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
    'timbri_cartacea',          t.timbri_cartacea,
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
    'citta',                    c.citta,
    'provincia',                c.provincia,
    'telefono',                 c.telefono,
    'email',                    c.email,
    'sconto_compleanno_anno',   t.sconto_compleanno_anno,
    'sconti_compleanno_totali', t.sconti_compleanno_totali,
    'sconti_tessera_usati', (
      SELECT COUNT(*) FROM tessere_sconti s
      WHERE s.tessera_id = t.id AND s.tipo = 'tessera'
    ),
    'sconti_tessera_list', (
      SELECT COALESCE(
        json_agg(
          json_build_object('data', s.data_utilizzo, 'valore', s.valore_sconto)
          ORDER BY s.data_utilizzo DESC
        ),
        '[]'::json
      )
      FROM tessere_sconti s
      WHERE s.tessera_id = t.id AND s.tipo = 'tessera'
    ),
    'sconti_compleanno_list', (
      SELECT COALESCE(
        json_agg(
          json_build_object('data', s.data_utilizzo, 'valore', s.valore_sconto)
          ORDER BY s.data_utilizzo DESC
        ),
        '[]'::json
      )
      FROM tessere_sconti s
      WHERE s.tessera_id = t.id AND s.tipo = 'compleanno'
    ),
    'movimenti_list', (
      SELECT COALESCE(
        json_agg(
          json_build_object(
            'data',    m.created_at,
            'importo', m.importo,
            'timbri',  m.timbri_aggiunti,
            'sconto',  m.sconto_generato
          )
          ORDER BY m.created_at DESC
        ),
        '[]'::json
      )
      FROM (
        SELECT created_at, importo, timbri_aggiunti, sconto_generato
        FROM movimenti_tessera
        WHERE tessera_id = t.id
        ORDER BY created_at DESC
        LIMIT 200
      ) m
    ),
    'cicli_list', (
      SELECT COALESCE(
        json_agg(
          json_build_object('ciclo', cl.ciclo_numero, 'data', cl.completato_at)
          ORDER BY cl.completato_at DESC
        ),
        '[]'::json
      )
      FROM tessere_cicli_log cl
      WHERE cl.tessera_id = t.id
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
