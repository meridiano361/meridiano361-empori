-- 1. Elimina record con giorno=0 (dati corrotti, nessun dato reale)
DELETE FROM cassa_giorni
WHERE chiave IN (
  'Cremona_2026_1_0',
  'Cremona_2026_2_0',
  'Cremona_2026_3_0',
  'Cremona_2026_4_0',
  'Cremona_2026_5_0',
  'Cremona_2026_6_0',
  'Cremona_2026_7_0',
  'Cremona_2026_8_0'
);

-- 2. Numero scontrini Cremona agosto 2026
-- Fonte: Controllo cassa Cremona.xlsx K77:K107 foglio 08_26
-- 19 record

UPDATE cassa_giorni SET global_scontrini = CASE chiave
  WHEN 'Cremona_2026_8_1' THEN to_jsonb(16)
  WHEN 'Cremona_2026_8_3' THEN to_jsonb(9)
  WHEN 'Cremona_2026_8_4' THEN to_jsonb(13)
  WHEN 'Cremona_2026_8_5' THEN to_jsonb(19)
  WHEN 'Cremona_2026_8_6' THEN to_jsonb(13)
  WHEN 'Cremona_2026_8_7' THEN to_jsonb(8)
  WHEN 'Cremona_2026_8_8' THEN to_jsonb(10)
  WHEN 'Cremona_2026_8_17' THEN to_jsonb(4)
  WHEN 'Cremona_2026_8_18' THEN to_jsonb(12)
  WHEN 'Cremona_2026_8_19' THEN to_jsonb(9)
  WHEN 'Cremona_2026_8_20' THEN to_jsonb(11)
  WHEN 'Cremona_2026_8_21' THEN to_jsonb(2)
  WHEN 'Cremona_2026_8_22' THEN to_jsonb(19)
  WHEN 'Cremona_2026_8_24' THEN to_jsonb(4)
  WHEN 'Cremona_2026_8_25' THEN to_jsonb(22)
  WHEN 'Cremona_2026_8_26' THEN to_jsonb(9)
  WHEN 'Cremona_2026_8_27' THEN to_jsonb(6)
  WHEN 'Cremona_2026_8_28' THEN to_jsonb(7)
  WHEN 'Cremona_2026_8_29' THEN to_jsonb(16)
END
WHERE chiave IN (
  'Cremona_2026_8_1',
  'Cremona_2026_8_3',
  'Cremona_2026_8_4',
  'Cremona_2026_8_5',
  'Cremona_2026_8_6',
  'Cremona_2026_8_7',
  'Cremona_2026_8_8',
  'Cremona_2026_8_17',
  'Cremona_2026_8_18',
  'Cremona_2026_8_19',
  'Cremona_2026_8_20',
  'Cremona_2026_8_21',
  'Cremona_2026_8_22',
  'Cremona_2026_8_24',
  'Cremona_2026_8_25',
  'Cremona_2026_8_26',
  'Cremona_2026_8_27',
  'Cremona_2026_8_28',
  'Cremona_2026_8_29'
);
