-- Ritorna le campagne commerciali attive oggi per l'emporio della tessera
CREATE OR REPLACE FUNCTION get_promo_attive(
  p_emporio text,
  p_data    date DEFAULT CURRENT_DATE
)
RETURNS TABLE(
  id         bigint,
  titolo     text,
  tipologia  text,
  meccanica  text,
  data_inizio date,
  data_fine   date
)
LANGUAGE sql SECURITY DEFINER STABLE
SET search_path = public AS $$
  SELECT id, titolo, tipologia, meccanica, data_inizio, data_fine
  FROM campagne_commerciali
  WHERE
    (data_inizio IS NULL OR data_inizio <= p_data)
    AND (data_fine IS NULL OR data_fine >= p_data)
    AND (
      emporio_scope IS NULL
      OR emporio_scope = p_emporio
    )
    AND (
      pdv_data IS NULL
      OR pdv_data = '{}'::jsonb
      OR (pdv_data -> p_emporio) IS NULL
      OR (pdv_data -> p_emporio ->> 'aderisce')::boolean = true
    )
  ORDER BY data_inizio;
$$;

GRANT EXECUTE ON FUNCTION get_promo_attive TO anon;
GRANT EXECUTE ON FUNCTION get_promo_attive TO authenticated;
