-- Rimuove tessere digitali duplicate: mantiene quella con più timbri (o la più vecchia a parità)
DELETE FROM tessere
WHERE id IN (
  SELECT id FROM (
    SELECT
      t.id,
      ROW_NUMBER() OVER (
        PARTITION BY t.cliente_id, t.tipo
        ORDER BY t.timbri_attuali DESC NULLS LAST, t.created_at ASC
      ) AS rn
    FROM tessere t
    WHERE t.ha_carta_digitale = true
      AND t.attiva IS NOT FALSE
  ) ranked
  WHERE rn > 1
);

-- Aggiunge vincolo univoco: un solo digitale attivo per cliente+tipo
CREATE UNIQUE INDEX IF NOT EXISTS tessere_digitali_cliente_tipo_unique
ON tessere (cliente_id, tipo)
WHERE ha_carta_digitale = true AND attiva IS NOT FALSE;
