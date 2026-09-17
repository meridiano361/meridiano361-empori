-- Numero scontrini Cremona gen-lug 2026
-- Fonte: Controllo cassa Cremona.xlsx, celle K77:K107 dei fogli mensili
-- 163 record

UPDATE cassa_giorni SET global_scontrini = CASE chiave
  WHEN 'Cremona_2026_1_5' THEN to_jsonb(24)
  WHEN 'Cremona_2026_1_7' THEN to_jsonb(28)
  WHEN 'Cremona_2026_1_8' THEN to_jsonb(14)
  WHEN 'Cremona_2026_1_9' THEN to_jsonb(27)
  WHEN 'Cremona_2026_1_10' THEN to_jsonb(37)
  WHEN 'Cremona_2026_1_12' THEN to_jsonb(5)
  WHEN 'Cremona_2026_1_13' THEN to_jsonb(20)
  WHEN 'Cremona_2026_1_14' THEN to_jsonb(17)
  WHEN 'Cremona_2026_1_15' THEN to_jsonb(16)
  WHEN 'Cremona_2026_1_16' THEN to_jsonb(33)
  WHEN 'Cremona_2026_1_17' THEN to_jsonb(40)
  WHEN 'Cremona_2026_1_19' THEN to_jsonb(5)
  WHEN 'Cremona_2026_1_20' THEN to_jsonb(15)
  WHEN 'Cremona_2026_1_21' THEN to_jsonb(26)
  WHEN 'Cremona_2026_1_22' THEN to_jsonb(24)
  WHEN 'Cremona_2026_1_23' THEN to_jsonb(14)
  WHEN 'Cremona_2026_1_24' THEN to_jsonb(31)
  WHEN 'Cremona_2026_1_26' THEN to_jsonb(3)
  WHEN 'Cremona_2026_1_27' THEN to_jsonb(17)
  WHEN 'Cremona_2026_1_28' THEN to_jsonb(19)
  WHEN 'Cremona_2026_1_30' THEN to_jsonb(15)
  WHEN 'Cremona_2026_1_31' THEN to_jsonb(29)
  WHEN 'Cremona_2026_2_2' THEN to_jsonb(6)
  WHEN 'Cremona_2026_2_3' THEN to_jsonb(13)
  WHEN 'Cremona_2026_2_4' THEN to_jsonb(11)
  WHEN 'Cremona_2026_2_5' THEN to_jsonb(15)
  WHEN 'Cremona_2026_2_6' THEN to_jsonb(12)
  WHEN 'Cremona_2026_2_7' THEN to_jsonb(35)
  WHEN 'Cremona_2026_2_9' THEN to_jsonb(8)
  WHEN 'Cremona_2026_2_10' THEN to_jsonb(21)
  WHEN 'Cremona_2026_2_11' THEN to_jsonb(18)
  WHEN 'Cremona_2026_2_12' THEN to_jsonb(13)
  WHEN 'Cremona_2026_2_13' THEN to_jsonb(14)
  WHEN 'Cremona_2026_2_14' THEN to_jsonb(9)
  WHEN 'Cremona_2026_2_16' THEN to_jsonb(8)
  WHEN 'Cremona_2026_2_17' THEN to_jsonb(16)
  WHEN 'Cremona_2026_2_18' THEN to_jsonb(16)
  WHEN 'Cremona_2026_2_19' THEN to_jsonb(16)
  WHEN 'Cremona_2026_2_20' THEN to_jsonb(43)
  WHEN 'Cremona_2026_2_23' THEN to_jsonb(4)
  WHEN 'Cremona_2026_2_24' THEN to_jsonb(23)
  WHEN 'Cremona_2026_2_25' THEN to_jsonb(15)
  WHEN 'Cremona_2026_2_26' THEN to_jsonb(8)
  WHEN 'Cremona_2026_2_27' THEN to_jsonb(15)
  WHEN 'Cremona_2026_2_28' THEN to_jsonb(36)
  WHEN 'Cremona_2026_3_2' THEN to_jsonb(12)
  WHEN 'Cremona_2026_3_3' THEN to_jsonb(22)
  WHEN 'Cremona_2026_3_4' THEN to_jsonb(20)
  WHEN 'Cremona_2026_3_5' THEN to_jsonb(18)
  WHEN 'Cremona_2026_3_6' THEN to_jsonb(17)
  WHEN 'Cremona_2026_3_7' THEN to_jsonb(19)
  WHEN 'Cremona_2026_3_9' THEN to_jsonb(2)
  WHEN 'Cremona_2026_3_10' THEN to_jsonb(15)
  WHEN 'Cremona_2026_3_11' THEN to_jsonb(21)
  WHEN 'Cremona_2026_3_12' THEN to_jsonb(13)
  WHEN 'Cremona_2026_3_13' THEN to_jsonb(25)
  WHEN 'Cremona_2026_3_14' THEN to_jsonb(27)
  WHEN 'Cremona_2026_3_16' THEN to_jsonb(10)
  WHEN 'Cremona_2026_3_17' THEN to_jsonb(25)
  WHEN 'Cremona_2026_3_18' THEN to_jsonb(17)
  WHEN 'Cremona_2026_3_19' THEN to_jsonb(24)
  WHEN 'Cremona_2026_3_20' THEN to_jsonb(20)
  WHEN 'Cremona_2026_3_21' THEN to_jsonb(33)
  WHEN 'Cremona_2026_3_23' THEN to_jsonb(6)
  WHEN 'Cremona_2026_3_24' THEN to_jsonb(18)
  WHEN 'Cremona_2026_3_25' THEN to_jsonb(19)
  WHEN 'Cremona_2026_3_26' THEN to_jsonb(19)
  WHEN 'Cremona_2026_3_27' THEN to_jsonb(28)
  WHEN 'Cremona_2026_4_1' THEN to_jsonb(33)
  WHEN 'Cremona_2026_4_2' THEN to_jsonb(27)
  WHEN 'Cremona_2026_4_3' THEN to_jsonb(37)
  WHEN 'Cremona_2026_4_4' THEN to_jsonb(25)
  WHEN 'Cremona_2026_4_7' THEN to_jsonb(11)
  WHEN 'Cremona_2026_4_8' THEN to_jsonb(10)
  WHEN 'Cremona_2026_4_9' THEN to_jsonb(14)
  WHEN 'Cremona_2026_4_10' THEN to_jsonb(18)
  WHEN 'Cremona_2026_4_11' THEN to_jsonb(33)
  WHEN 'Cremona_2026_4_13' THEN to_jsonb(4)
  WHEN 'Cremona_2026_4_14' THEN to_jsonb(13)
  WHEN 'Cremona_2026_4_15' THEN to_jsonb(24)
  WHEN 'Cremona_2026_4_16' THEN to_jsonb(17)
  WHEN 'Cremona_2026_4_17' THEN to_jsonb(10)
  WHEN 'Cremona_2026_4_18' THEN to_jsonb(18)
  WHEN 'Cremona_2026_4_20' THEN to_jsonb(8)
  WHEN 'Cremona_2026_4_21' THEN to_jsonb(19)
  WHEN 'Cremona_2026_4_22' THEN to_jsonb(18)
  WHEN 'Cremona_2026_4_23' THEN to_jsonb(18)
  WHEN 'Cremona_2026_4_24' THEN to_jsonb(24)
  WHEN 'Cremona_2026_4_27' THEN to_jsonb(6)
  WHEN 'Cremona_2026_4_28' THEN to_jsonb(17)
  WHEN 'Cremona_2026_4_29' THEN to_jsonb(21)
  WHEN 'Cremona_2026_4_30' THEN to_jsonb(18)
  WHEN 'Cremona_2026_5_2' THEN to_jsonb(26)
  WHEN 'Cremona_2026_5_4' THEN to_jsonb(10)
  WHEN 'Cremona_2026_5_5' THEN to_jsonb(16)
  WHEN 'Cremona_2026_5_6' THEN to_jsonb(15)
  WHEN 'Cremona_2026_5_7' THEN to_jsonb(21)
  WHEN 'Cremona_2026_5_8' THEN to_jsonb(19)
  WHEN 'Cremona_2026_5_9' THEN to_jsonb(14)
  WHEN 'Cremona_2026_5_11' THEN to_jsonb(3)
  WHEN 'Cremona_2026_5_12' THEN to_jsonb(14)
  WHEN 'Cremona_2026_5_13' THEN to_jsonb(14)
  WHEN 'Cremona_2026_5_14' THEN to_jsonb(18)
  WHEN 'Cremona_2026_5_15' THEN to_jsonb(19)
  WHEN 'Cremona_2026_5_16' THEN to_jsonb(26)
  WHEN 'Cremona_2026_5_18' THEN to_jsonb(4)
  WHEN 'Cremona_2026_5_19' THEN to_jsonb(20)
  WHEN 'Cremona_2026_5_20' THEN to_jsonb(14)
  WHEN 'Cremona_2026_5_21' THEN to_jsonb(16)
  WHEN 'Cremona_2026_5_22' THEN to_jsonb(6)
  WHEN 'Cremona_2026_5_23' THEN to_jsonb(21)
  WHEN 'Cremona_2026_5_25' THEN to_jsonb(5)
  WHEN 'Cremona_2026_5_26' THEN to_jsonb(15)
  WHEN 'Cremona_2026_5_27' THEN to_jsonb(14)
  WHEN 'Cremona_2026_5_28' THEN to_jsonb(11)
  WHEN 'Cremona_2026_5_29' THEN to_jsonb(15)
  WHEN 'Cremona_2026_5_30' THEN to_jsonb(31)
  WHEN 'Cremona_2026_6_1' THEN to_jsonb(1)
  WHEN 'Cremona_2026_6_3' THEN to_jsonb(12)
  WHEN 'Cremona_2026_6_4' THEN to_jsonb(15)
  WHEN 'Cremona_2026_6_5' THEN to_jsonb(15)
  WHEN 'Cremona_2026_6_6' THEN to_jsonb(27)
  WHEN 'Cremona_2026_6_8' THEN to_jsonb(7)
  WHEN 'Cremona_2026_6_9' THEN to_jsonb(17)
  WHEN 'Cremona_2026_6_10' THEN to_jsonb(20)
  WHEN 'Cremona_2026_6_11' THEN to_jsonb(18)
  WHEN 'Cremona_2026_6_12' THEN to_jsonb(15)
  WHEN 'Cremona_2026_6_13' THEN to_jsonb(29)
  WHEN 'Cremona_2026_6_15' THEN to_jsonb(5)
  WHEN 'Cremona_2026_6_16' THEN to_jsonb(14)
  WHEN 'Cremona_2026_6_17' THEN to_jsonb(16)
  WHEN 'Cremona_2026_6_18' THEN to_jsonb(11)
  WHEN 'Cremona_2026_6_19' THEN to_jsonb(6)
  WHEN 'Cremona_2026_6_20' THEN to_jsonb(18)
  WHEN 'Cremona_2026_6_22' THEN to_jsonb(11)
  WHEN 'Cremona_2026_6_23' THEN to_jsonb(19)
  WHEN 'Cremona_2026_6_24' THEN to_jsonb(19)
  WHEN 'Cremona_2026_6_26' THEN to_jsonb(8)
  WHEN 'Cremona_2026_6_27' THEN to_jsonb(14)
  WHEN 'Cremona_2026_6_29' THEN to_jsonb(6)
  WHEN 'Cremona_2026_6_30' THEN to_jsonb(21)
  WHEN 'Cremona_2026_7_1' THEN to_jsonb(17)
  WHEN 'Cremona_2026_7_2' THEN to_jsonb(15)
  WHEN 'Cremona_2026_7_6' THEN to_jsonb(7)
  WHEN 'Cremona_2026_7_7' THEN to_jsonb(15)
  WHEN 'Cremona_2026_7_8' THEN to_jsonb(15)
  WHEN 'Cremona_2026_7_9' THEN to_jsonb(13)
  WHEN 'Cremona_2026_7_10' THEN to_jsonb(5)
  WHEN 'Cremona_2026_7_11' THEN to_jsonb(23)
  WHEN 'Cremona_2026_7_15' THEN to_jsonb(19)
  WHEN 'Cremona_2026_7_16' THEN to_jsonb(14)
  WHEN 'Cremona_2026_7_17' THEN to_jsonb(7)
  WHEN 'Cremona_2026_7_18' THEN to_jsonb(14)
  WHEN 'Cremona_2026_7_19' THEN to_jsonb(15)
  WHEN 'Cremona_2026_7_21' THEN to_jsonb(15)
  WHEN 'Cremona_2026_7_22' THEN to_jsonb(10)
  WHEN 'Cremona_2026_7_23' THEN to_jsonb(12)
  WHEN 'Cremona_2026_7_24' THEN to_jsonb(9)
  WHEN 'Cremona_2026_7_27' THEN to_jsonb(3)
  WHEN 'Cremona_2026_7_28' THEN to_jsonb(7)
  WHEN 'Cremona_2026_7_29' THEN to_jsonb(17)
  WHEN 'Cremona_2026_7_30' THEN to_jsonb(11)
  WHEN 'Cremona_2026_7_31' THEN to_jsonb(21)
END
WHERE chiave IN (
  'Cremona_2026_1_5',
  'Cremona_2026_1_7',
  'Cremona_2026_1_8',
  'Cremona_2026_1_9',
  'Cremona_2026_1_10',
  'Cremona_2026_1_12',
  'Cremona_2026_1_13',
  'Cremona_2026_1_14',
  'Cremona_2026_1_15',
  'Cremona_2026_1_16',
  'Cremona_2026_1_17',
  'Cremona_2026_1_19',
  'Cremona_2026_1_20',
  'Cremona_2026_1_21',
  'Cremona_2026_1_22',
  'Cremona_2026_1_23',
  'Cremona_2026_1_24',
  'Cremona_2026_1_26',
  'Cremona_2026_1_27',
  'Cremona_2026_1_28',
  'Cremona_2026_1_30',
  'Cremona_2026_1_31',
  'Cremona_2026_2_2',
  'Cremona_2026_2_3',
  'Cremona_2026_2_4',
  'Cremona_2026_2_5',
  'Cremona_2026_2_6',
  'Cremona_2026_2_7',
  'Cremona_2026_2_9',
  'Cremona_2026_2_10',
  'Cremona_2026_2_11',
  'Cremona_2026_2_12',
  'Cremona_2026_2_13',
  'Cremona_2026_2_14',
  'Cremona_2026_2_16',
  'Cremona_2026_2_17',
  'Cremona_2026_2_18',
  'Cremona_2026_2_19',
  'Cremona_2026_2_20',
  'Cremona_2026_2_23',
  'Cremona_2026_2_24',
  'Cremona_2026_2_25',
  'Cremona_2026_2_26',
  'Cremona_2026_2_27',
  'Cremona_2026_2_28',
  'Cremona_2026_3_2',
  'Cremona_2026_3_3',
  'Cremona_2026_3_4',
  'Cremona_2026_3_5',
  'Cremona_2026_3_6',
  'Cremona_2026_3_7',
  'Cremona_2026_3_9',
  'Cremona_2026_3_10',
  'Cremona_2026_3_11',
  'Cremona_2026_3_12',
  'Cremona_2026_3_13',
  'Cremona_2026_3_14',
  'Cremona_2026_3_16',
  'Cremona_2026_3_17',
  'Cremona_2026_3_18',
  'Cremona_2026_3_19',
  'Cremona_2026_3_20',
  'Cremona_2026_3_21',
  'Cremona_2026_3_23',
  'Cremona_2026_3_24',
  'Cremona_2026_3_25',
  'Cremona_2026_3_26',
  'Cremona_2026_3_27',
  'Cremona_2026_4_1',
  'Cremona_2026_4_2',
  'Cremona_2026_4_3',
  'Cremona_2026_4_4',
  'Cremona_2026_4_7',
  'Cremona_2026_4_8',
  'Cremona_2026_4_9',
  'Cremona_2026_4_10',
  'Cremona_2026_4_11',
  'Cremona_2026_4_13',
  'Cremona_2026_4_14',
  'Cremona_2026_4_15',
  'Cremona_2026_4_16',
  'Cremona_2026_4_17',
  'Cremona_2026_4_18',
  'Cremona_2026_4_20',
  'Cremona_2026_4_21',
  'Cremona_2026_4_22',
  'Cremona_2026_4_23',
  'Cremona_2026_4_24',
  'Cremona_2026_4_27',
  'Cremona_2026_4_28',
  'Cremona_2026_4_29',
  'Cremona_2026_4_30',
  'Cremona_2026_5_2',
  'Cremona_2026_5_4',
  'Cremona_2026_5_5',
  'Cremona_2026_5_6',
  'Cremona_2026_5_7',
  'Cremona_2026_5_8',
  'Cremona_2026_5_9',
  'Cremona_2026_5_11',
  'Cremona_2026_5_12',
  'Cremona_2026_5_13',
  'Cremona_2026_5_14',
  'Cremona_2026_5_15',
  'Cremona_2026_5_16',
  'Cremona_2026_5_18',
  'Cremona_2026_5_19',
  'Cremona_2026_5_20',
  'Cremona_2026_5_21',
  'Cremona_2026_5_22',
  'Cremona_2026_5_23',
  'Cremona_2026_5_25',
  'Cremona_2026_5_26',
  'Cremona_2026_5_27',
  'Cremona_2026_5_28',
  'Cremona_2026_5_29',
  'Cremona_2026_5_30',
  'Cremona_2026_6_1',
  'Cremona_2026_6_3',
  'Cremona_2026_6_4',
  'Cremona_2026_6_5',
  'Cremona_2026_6_6',
  'Cremona_2026_6_8',
  'Cremona_2026_6_9',
  'Cremona_2026_6_10',
  'Cremona_2026_6_11',
  'Cremona_2026_6_12',
  'Cremona_2026_6_13',
  'Cremona_2026_6_15',
  'Cremona_2026_6_16',
  'Cremona_2026_6_17',
  'Cremona_2026_6_18',
  'Cremona_2026_6_19',
  'Cremona_2026_6_20',
  'Cremona_2026_6_22',
  'Cremona_2026_6_23',
  'Cremona_2026_6_24',
  'Cremona_2026_6_26',
  'Cremona_2026_6_27',
  'Cremona_2026_6_29',
  'Cremona_2026_6_30',
  'Cremona_2026_7_1',
  'Cremona_2026_7_2',
  'Cremona_2026_7_6',
  'Cremona_2026_7_7',
  'Cremona_2026_7_8',
  'Cremona_2026_7_9',
  'Cremona_2026_7_10',
  'Cremona_2026_7_11',
  'Cremona_2026_7_15',
  'Cremona_2026_7_16',
  'Cremona_2026_7_17',
  'Cremona_2026_7_18',
  'Cremona_2026_7_19',
  'Cremona_2026_7_21',
  'Cremona_2026_7_22',
  'Cremona_2026_7_23',
  'Cremona_2026_7_24',
  'Cremona_2026_7_27',
  'Cremona_2026_7_28',
  'Cremona_2026_7_29',
  'Cremona_2026_7_30',
  'Cremona_2026_7_31'
);
