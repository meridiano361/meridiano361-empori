-- Import Tessere Fedeltà da Excel
-- Esegui nel SQL Editor di Supabase

-- STANDARD CLIENTS
DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Maura', 'Pedroni', '3333690180', False, 'maura.pedroni1@gmail.com', 'cremona', '1958-05-12', 'Cremona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Maura' AND cognome='Pedroni' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3013', NULL, False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
    IF tid IS NOT NULL THEN
      INSERT INTO tessere_sconti (tessera_id, data_utilizzo, valore_sconto)
      VALUES (tid, '2026-09-12', '€20');
    END IF;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Viviana', 'Neviani', NULL, False, 'viviana-neviani@hotmail.com', 'cremona', '1990-02-14', 'estero', 'estero')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Viviana' AND cognome='Neviani' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3015', '2026-01-10', False, False)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Paola', 'Villani', '3295386056', False, 'paola.lucia.villani@gmail.com', 'cremona', '1943-09-17', 'Cremona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Paola' AND cognome='Villani' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3016', '2026-01-10', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Elena', 'Mariani', '3393098955', False, 'elenamariani99@gmail.com', 'cremona', '1965-05-27', 'Lissone', 'Monza')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Elena' AND cognome='Mariani' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3019', '2026-01-20', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Elena', 'Pluda', '3405645916', False, 'elena.pl03@libero.it', 'cremona', '1964-02-28', 'Robecco d''Oglio', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Elena' AND cognome='Pluda' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3020', '2026-01-20', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Amedea', 'Orsi', '3382261465', False, 'amedea.orsi@libero.it', 'cremona', '1953-11-09', 'Cremona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Amedea' AND cognome='Orsi' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3021', '2026-01-20', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Maria', 'Compagnini', '3498241423', True, 'mariacompagnini.56@gmail.com', 'cremona', NULL, 'Cremona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Maria' AND cognome='Compagnini' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3022', '2026-01-20', True, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
    IF tid IS NOT NULL THEN
      INSERT INTO tessere_sconti (tessera_id, data_utilizzo, valore_sconto)
      VALUES (tid, '2026-09-21', '€20');
    END IF;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Giancarla', 'Paini', '3395948459', False, 'giancarlapaini@libero.it', 'cremona', '1954-12-31', 'Cremona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Giancarla' AND cognome='Paini' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3023', '2026-01-20', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Ilaria', 'Pini', '3476550736', False, 'ilaria.pini98@gmail.com', 'cremona', '1998-04-17', 'Pieve D''olmi', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Ilaria' AND cognome='Pini' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3024', '2026-01-27', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Marcella', 'Bonelli', '33953331698', False, 'marcibonelli@gmail.com', 'cremona', '1976-10-18', 'Cremona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Marcella' AND cognome='Bonelli' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3025', '2026-01-27', False, False)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Rita', 'Triglia', '3382383922', False, 'redmullet36@gmail.com', 'cremona', '1959-06-03', 'Cremona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Rita' AND cognome='Triglia' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3026', '2026-01-27', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Gerardo', 'Bambino', '3311245710', False, 'gerardo.b@tin.it', 'cremona', '1957-01-10', 'Piacenza', 'Piacenza')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Gerardo' AND cognome='Bambino' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3027', '2026-01-27', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Sibylle', 'Fehr', '3483734645', False, 'barchardtcremona@tin.it', 'cremona', '1965-08-24', 'Cremona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Sibylle' AND cognome='Fehr' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3029', '2026-01-27', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Rita', 'Ardemagni', '3358087105', False, 'rita.ardemagni@gmail.com', 'cremona', '1962-10-05', 'Cremona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Rita' AND cognome='Ardemagni' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3029 BIS', '2026-01-27', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Ave', 'Savi', '3703339746', False, 'ave.savi49@gmail.com', 'cremona', '1949-11-17', 'Cremona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Ave' AND cognome='Savi' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3030', '2026-01-29', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Ivana', 'Gruppi', '3386048176', False, 'ivanagruppi@gmail.com', 'cremona', '1961-08-16', 'Piacenza', 'Piacenza')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Ivana' AND cognome='Gruppi' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3031', '2026-01-30', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Luigi', 'Rizzi', '3334988383', False, 'rizzip374@gmail.com', 'cremona', '1957-06-03', 'Cremona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Luigi' AND cognome='Rizzi' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3032', '2026-01-30', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Luisa', 'Davò', '3384488880', False, 'marialuisadavo@gmail.com', 'cremona', NULL, 'Cremona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Luisa' AND cognome='Davò' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3033', NULL, False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
    IF tid IS NOT NULL THEN
      INSERT INTO tessere_sconti (tessera_id, data_utilizzo, valore_sconto)
      VALUES (tid, '2026-07-01', '€20');
    END IF;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Monica', 'Rebecchi', '3406889815', False, 'monicageordie5@gmail.com', 'cremona', '1976-10-17', 'Cremona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Monica' AND cognome='Rebecchi' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3034', '2026-02-07', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
    IF tid IS NOT NULL THEN
      INSERT INTO tessere_sconti (tessera_id, data_utilizzo, valore_sconto)
      VALUES (tid, '2026-03-17', '€20');
    END IF;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Monica', 'Boi', '3337161364', False, 'moki1301@gmail.com', 'cremona', '1967-04-18', 'Cremona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Monica' AND cognome='Boi' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3035', '2026-01-31', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Martina', '(Bellan?)', NULL, False, NULL, 'cremona', NULL, NULL, NULL)
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Martina' AND cognome='(Bellan?)' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3036', '2026-01-31', False, False)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Sara', 'Polini', '3392616007', False, 'sara.b.polini@gmail.com', 'cremona', '1984-02-14', 'Cremona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Sara' AND cognome='Polini' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3037', '2026-02-07', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Martina', 'Regis', '3485932160', False, 'regis.martina@gmail.com', 'cremona', '1992-03-28', 'Cremona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Martina' AND cognome='Regis' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3038', '2026-02-11', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Maria', 'Caraci Vela', '3338439559', False, 'maria.caraci@unipv.it', 'cremona', '1946-03-11', 'Cremona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Maria' AND cognome='Caraci Vela' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3039', '2026-02-12', False, False)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Kumar', 'Vanelli', '3773799780', False, 'vanellk@gmail.com', 'cremona', '1982-09-21', 'Cremona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Kumar' AND cognome='Vanelli' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3040', '2026-02-12', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Danisa', 'Rossi', '3389579159', False, 'ottaross@gmail.com', 'cremona', '1975-02-18', 'Cremona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Danisa' AND cognome='Rossi' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3041', '2026-02-18', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Chiara', 'De Micheli', '3389199034', False, 'chiarademik@gmail.com', 'cremona', '1971-09-18', 'Cremona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Chiara' AND cognome='De Micheli' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3042', '2026-02-18', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Silvia', 'Ruggeri', '3313023046', False, 'silviaruggeri99@gmail.com', 'cremona', '1999-07-26', 'Cremona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Silvia' AND cognome='Ruggeri' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3043', '2026-02-09', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Graziella', 'Cannizzaro', '3337350826', False, NULL, 'cremona', '1949-01-16', 'Cremona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Graziella' AND cognome='Cannizzaro' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3044', '2026-02-09', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Deenira', 'Bellotti', '3342025018', False, NULL, 'cremona', '1967-05-10', 'Soncino', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Deenira' AND cognome='Bellotti' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3045', '2026-02-09', False, False)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Adriano', 'Bernini', '3928770762', False, 'bernini.adriano@yahoo.it', 'cremona', '1941-10-25', 'Cremona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Adriano' AND cognome='Bernini' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3046', '2026-02-09', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Alina', 'Mardaru', '3884677106', False, 'mardaru84@gmail.com', 'cremona', '1984-12-06', 'Cremona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Alina' AND cognome='Mardaru' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3047', '2026-02-28', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Haureen Terese', 'Lancaster', '3454427508', False, 'maureentereselancester@gmail.com', 'cremona', '1962-06-17', 'Cremona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Haureen Terese' AND cognome='Lancaster' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3048', '2026-03-04', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Laura', 'Galelli', '3703716774', False, 'lauragalelli@gmail.com', 'cremona', '1981-04-13', 'Cremona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Laura' AND cognome='Galelli' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3049', '2026-03-04', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Lorena', 'Fwetto', '3534459888', False, 'lofin1963@gmail.com', 'cremona', '1963-01-09', 'Castelleone', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Lorena' AND cognome='Fwetto' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3050', '2026-03-04', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Macconi', 'Maria', '3391409330', False, 'hillarymacco@hotmail.it', 'cremona', '1985-11-19', 'Cremona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Macconi' AND cognome='Maria' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3051', '2026-03-04', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Caterina', 'Biagiarelli', '3394092556', False, 'catebgl@yahoo.it', 'cremona', '1995-08-04', 'Milano', 'Milano')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Caterina' AND cognome='Biagiarelli' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3052', '2026-03-04', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Maria Paola', 'Gaggia', '3406054532', False, 'mpgaggia@libero.it', 'cremona', '1969-09-20', 'Cremona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Maria Paola' AND cognome='Gaggia' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3053', '2026-03-04', False, False)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Daniela', 'Stroppi', '3488967995', False, 'daniela.stroppi@gmail.com', 'cremona', '1972-05-29', 'Cremona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Daniela' AND cognome='Stroppi' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3054', '2026-03-04', False, False)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Santi', 'Alberto', '3480661202', False, 'alberto.santi@fastpiu.it', 'cremona', '1965-11-11', 'Cremona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Santi' AND cognome='Alberto' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3055', '2026-03-07', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Sara', 'Bonvicini', '3405765374', False, 'sarabonvicini@gmail.com', 'cremona', '1990-06-21', 'Cremnoa', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Sara' AND cognome='Bonvicini' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3056', '2026-03-11', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Maria Rosa', 'Perodi', '3332550086', False, 'mariarosaperodi@gmail.com', 'cremona', '1961-05-11', 'Cremona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Maria Rosa' AND cognome='Perodi' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3057', '2026-03-11', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Gaia', 'Vella', NULL, False, 'gsvella04@gmail.com', 'cremona', '2004-12-13', NULL, NULL)
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Gaia' AND cognome='Vella' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3058', '2026-03-11', False, False)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Lara', 'Terusio', '3312366527', False, 'l.terli@hotmail.com', 'cremona', '1988-09-07', 'Pontevico', 'Brescia')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Lara' AND cognome='Terusio' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3059', '2026-03-11', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Giovanna', 'Mosconi', '3471206693', False, 'giovannamosconi@yahoo.it', 'cremona', '1959-01-15', 'Cremona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Giovanna' AND cognome='Mosconi' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3060', '2026-03-12', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Laura', 'Gerevini', '3475128394', False, 'laura.gerevini@comune.cremona.it', 'cremona', '1966-09-06', 'Cremona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Laura' AND cognome='Gerevini' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3061', '2026-03-07', False, False)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
    IF tid IS NOT NULL THEN
      INSERT INTO tessere_sconti (tessera_id, data_utilizzo, valore_sconto)
      VALUES (tid, '2026-09-19', '€20');
    END IF;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Monica', 'Rebecchi', '3406889815', False, 'monicageordie5@gmail.com', 'cremona', '1976-10-17', 'Cremona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Monica' AND cognome='Rebecchi' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3062', '2026-03-17', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Elena', 'Benassi', '3394919725', False, 'elena17benassi@hotmail.com', 'cremona', '1971-12-17', 'Cremona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Elena' AND cognome='Benassi' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3063', '2026-03-20', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Vincenzo', 'Raffaini', '3480618348', True, 'vincenzoraffaini@gmail.com', 'cremona', '1957-02-11', 'Cremona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Vincenzo' AND cognome='Raffaini' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3064', '2026-03-23', True, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Monica', 'Gastaldi', '3336382324', False, 'monicagastaldi6@gmail.com', 'cremona', '1970-07-10', 'Cremona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Monica' AND cognome='Gastaldi' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3065', '2026-03-30', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Donatella', 'Piccioni', '3482839962', False, 'donatella.piccioli@tiscali.it', 'cremona', '1952-08-04', 'Cremona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Donatella' AND cognome='Piccioni' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3066', '2026-03-30', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Mirella', 'Pasi', '3332212570', False, 'mirella.pasi@gmail.com', 'cremona', '1960-01-03', 'Piadene Drizzona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Mirella' AND cognome='Pasi' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3067', '2026-03-30', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Elena', 'Forzani', '3343510510', False, 'elena.forzani@hotmail.com', 'cremona', '1997-12-28', 'Cremona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Elena' AND cognome='Forzani' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3068', '2026-04-08', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Elena', 'Taje', '3206772253', False, 'taje-mariola@libera.it', 'cremona', '1969-03-31', 'Cremona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Elena' AND cognome='Taje' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3069', '2026-04-15', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Cristina', 'Alquati', '3662673676', False, 'shoshanatmid@gmail.com', 'cremona', '1959-09-30', 'Cremona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Cristina' AND cognome='Alquati' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3070', '2026-04-15', False, False)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Silvia', 'Gagliardi', '3294112388', False, 'silvia_martina@hotmail.com', 'cremona', '1977-11-15', 'Cremona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Silvia' AND cognome='Gagliardi' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3071', '2026-04-15', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Angela', 'Canedoli', '3398010405', False, 'angela.canedoli (?)', 'cremona', '1961-07-30', 'Isola Dovarese', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Angela' AND cognome='Canedoli' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3072', '2026-04-15', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Chiara', 'Fiorani', NULL, False, NULL, 'cremona', '1974-02-19', 'Pisa', 'Pisa')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Chiara' AND cognome='Fiorani' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3073', '2026-04-03', False, False)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Davide', 'Bodini', '3402722765', False, 'davidebodini@gmail.com', 'cremona', '1976-03-24', 'Cremona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Davide' AND cognome='Bodini' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3074', '2026-04-08', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Giancarla', 'Vizzosi', NULL, False, NULL, 'cremona', NULL, NULL, NULL)
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Giancarla' AND cognome='Vizzosi' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3075', NULL, False, False)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Letizia', 'Platé', '3470518786', False, 'andlety@libero.it', 'cremona', '1975-10-22', 'Cremona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Letizia' AND cognome='Platé' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3076', '2026-04-02', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Fabiana', 'Bonali', '3496364510', False, 'fabiana.bonali@libero.it', 'cremona', '1971-03-12', 'Cremona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Fabiana' AND cognome='Bonali' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3077', '2026-03-31', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Sophie', 'Roudaire', '3318239236', False, 'sroudaire@hotmail.com', 'cremona', '1978-02-09', 'Cremona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Sophie' AND cognome='Roudaire' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3078', '2026-03-31', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Gianluigi', 'Bellandi', '3482833376', False, 'gianluigimitico@gmail.com', 'cremona', '1959-09-21', 'Gombito', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Gianluigi' AND cognome='Bellandi' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3079', '2026-04-01', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Ilaria', 'Canevari', '3402547488', False, 'ila24kt@inwind.it', 'cremona', '1984-01-30', 'Grontardo', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Ilaria' AND cognome='Canevari' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3080', '2026-03-31', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Michela', 'Rava', NULL, False, NULL, 'cremona', NULL, NULL, NULL)
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Michela' AND cognome='Rava' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3083', '2026-03-31', False, False)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Anna', 'Cattivelli', '3491078565', False, 'cattivellianna@gmail.com', 'cremona', '1962-07-09', 'Cremona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Anna' AND cognome='Cattivelli' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3084', NULL, False, False)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Simona', 'Bianchi', '3289605569', False, 'simonabianchigm@gmail.com', 'cremona', '1971-05-22', 'Cremona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Simona' AND cognome='Bianchi' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3085', '2026-03-24', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Maria', 'Caraci Vela', '3338439559', False, 'maria.caraci@unipv.it', 'cremona', '1946-03-11', 'Cremona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Maria' AND cognome='Caraci Vela' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3086', '2026-03-24', False, False)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Giuliana', 'Bertuzzi', '3332148104', False, 'geagauss@libero.it', 'cremona', '1963-04-10', 'Vescovato', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Giuliana' AND cognome='Bertuzzi' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3087', '2026-03-24', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
    IF tid IS NOT NULL THEN
      INSERT INTO tessere_sconti (tessera_id, data_utilizzo, valore_sconto)
      VALUES (tid, '2026-09-16', '€20');
    END IF;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Monica', 'Mercado', '3332588557', False, 'monica291283@yahoo.it', 'cremona', NULL, 'Cremona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Monica' AND cognome='Mercado' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3088', '2026-03-24', False, False)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Francesca', 'Sora', '3334626619', False, 'francesca@studiosora.it', 'cremona', '1960-05-20', 'Cremona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Francesca' AND cognome='Sora' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3089', NULL, False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
    IF tid IS NOT NULL THEN
      INSERT INTO tessere_sconti (tessera_id, data_utilizzo, valore_sconto)
      VALUES (tid, '2026-09-12', '€20');
    END IF;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Anna', 'Soldi', '3289064235', False, 'annasoldi@gmail.com', 'cremona', '1974-02-18', 'Busseto', 'Parma')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Anna' AND cognome='Soldi' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3090', '2026-03-24', False, False)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Fania', 'Sverdlik', '3392291841', False, 'sverdlikviolius@gmail.com', 'cremona', '1952-12-06', 'Cremona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Fania' AND cognome='Sverdlik' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3091', '2026-03-24', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Cinzia', 'Guindani', NULL, False, 'guindanicinzia@gmail.com', 'cremona', '1961-11-28', 'Casalmaggiore', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Cinzia' AND cognome='Guindani' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3092', '2026-03-05', False, False)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Maria Teresa', 'Nolli', '3480465838', False, 'nollimariateresa@gmail.com', 'cremona', '1956-05-20', 'Cremona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Maria Teresa' AND cognome='Nolli' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3093', '2026-02-27', False, False)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
    IF tid IS NOT NULL THEN
      INSERT INTO tessere_sconti (tessera_id, data_utilizzo, valore_sconto)
      VALUES (tid, '2026-08-18', '€20');
    END IF;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Rosa', 'Di Maggio', '3289717372', False, 'rdiamaggio.ing@gmail.com', 'cremona', '1973-09-14', 'Cremona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Rosa' AND cognome='Di Maggio' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3094', '2026-02-27', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Maria', 'Tessaroli', '3317590199', False, 'maria.tessaroli@gmail.com', 'cremona', '1993-11-20', 'Vescovato', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Maria' AND cognome='Tessaroli' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3095', '2026-02-27', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Giuseppina', 'Guarneri', '3494201749', False, 'guarnerigiuseppina@yahoo.com', 'cremona', '1962-04-25', 'Malagnino', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Giuseppina' AND cognome='Guarneri' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3096', '2026-02-13', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Melissa', 'Monica', '3287064214', False, NULL, 'cremona', '1984-06-17', 'Cremona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Melissa' AND cognome='Monica' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3097', '2026-01-10', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Paola', 'Lucini', '3497976574', False, 'gymballet@hotmail.it', 'cremona', '1966-06-30', 'Torre De Picenardi', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Paola' AND cognome='Lucini' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3098', '2026-01-10', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Giuliana', 'Bertuzzi', '3332148104', False, 'geagauss@libero.it', 'cremona', '1963-04-10', 'Vescovato', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Giuliana' AND cognome='Bertuzzi' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3099', '2026-02-13', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
    IF tid IS NOT NULL THEN
      INSERT INTO tessere_sconti (tessera_id, data_utilizzo, valore_sconto)
      VALUES (tid, '2026-03-30', '€20');
    END IF;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Francesca', 'Galloni', '3389857665', False, 'psygalloni@gmail.com', 'cremona', '1975-04-23', 'Cremona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Francesca' AND cognome='Galloni' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3104', '2026-03-14', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Lucia', 'Tonani', '3332370078', False, 'lucia96.tonani@gmail.com', 'cremona', '1996-10-25', 'Cremona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Lucia' AND cognome='Tonani' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3106', '2026-04-15', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Benedetta', 'Galli', '3346167144', False, 'benedetta.galli93@gmail.com', 'cremona', '1993-07-16', 'Scandicci', 'Firenze')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Benedetta' AND cognome='Galli' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3107', '2026-04-15', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Riccarda', 'Rossi', '3332663841', False, 'riccarda.kovarik@gmail.com', 'cremona', '1977-11-29', 'Cremona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Riccarda' AND cognome='Rossi' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3109', '2026-04-15', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Milena', 'Braga', '3336942548', False, 'bragamilena53@gmail.com', 'cremona', '1953-09-24', 'Cremona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Milena' AND cognome='Braga' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3110', '2026-04-17', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Ilaria', 'Macconi', '3391409330', False, 'hillarymacca@hotmail.com', 'cremona', '1985-11-19', 'Cremona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Ilaria' AND cognome='Macconi' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3111', '2026-04-23', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Alice', 'Modonesi', '3382001474', False, 'alicediletta@yahoo.it', 'cremona', '1990-11-20', 'Poncarale', 'Brescia')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Alice' AND cognome='Modonesi' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3112', '2026-04-23', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Silvia', 'Ruggeri', '3313023046', False, 'silviaruggeri99@gmail.com', 'cremona', '1999-07-26', 'Cremona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Silvia' AND cognome='Ruggeri' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3112 BIS', '2026-05-13', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Vania', 'Zanetti', NULL, False, NULL, 'cremona', NULL, NULL, NULL)
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Vania' AND cognome='Zanetti' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3113', NULL, False, False)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Maria Grazia', 'Truffa', '3406041588', False, NULL, 'cremona', '1949-03-04', 'Castelverde', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Maria Grazia' AND cognome='Truffa' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3114', '2026-05-23', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Isabella', 'Zeli', NULL, False, NULL, 'cremona', NULL, NULL, NULL)
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Isabella' AND cognome='Zeli' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3115', '2026-05-23', False, False)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Eleonora', 'Casarotti', '3701020373', False, 'eleonoracasarotti (?)', 'cremona', '1990-06-21', 'Cremona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Eleonora' AND cognome='Casarotti' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3116', '2026-05-02', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Mariangela', 'Mineri', '3397300403', False, 'marimineri@gmail.com', 'cremona', '1962-12-25', 'Cremona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Mariangela' AND cognome='Mineri' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3117', '2026-05-23', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Cabrini', NULL, NULL, False, NULL, 'cremona', NULL, NULL, NULL)
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Cabrini' AND cognome=NULL AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3118', '2026-05-13', False, False)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Amelia', 'Mcewen', '3342867527', False, 'ameliaflomcewn@gmail.com', 'cremona', '1995-11-14', 'Cremona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Amelia' AND cognome='Mcewen' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3119', '2026-05-06', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Antonella', 'Codazzi', '3347173493', False, 'antonella.codazzi@libero.it', 'cremona', '1956-01-10', 'Caorso', 'Piacenza')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Antonella' AND cognome='Codazzi' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3120', '2026-05-16', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Claudia', 'Vismara', '3333565219', False, 'claudiavismara22@gmail.com', 'cremona', '1992-10-15', 'Corbetta', 'Milano')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Claudia' AND cognome='Vismara' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3121', '2026-05-06', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Lucia', 'Bartiloro', '3280010129', False, 'luciabartiloro67@gmail.com', 'cremona', '1967-10-03', 'Cremona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Lucia' AND cognome='Bartiloro' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3123', '2026-05-13', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Nicola', 'Manfredini', '3357617786', False, 'nicola.manfredini@libero.it', 'cremona', '1967-01-16', 'Usmate Velate', 'Monza Brianza')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Nicola' AND cognome='Manfredini' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3124', '2026-05-13', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Lisa', 'Milani', '3493761020', False, 'papehouse7@gmail.com', 'cremona', '1969-09-05', 'Persico Dosimo', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Lisa' AND cognome='Milani' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3125', '2026-05-13', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Pierluigi', 'Monteverdi', '3471651558', False, NULL, 'cremona', '1958-06-19', 'Cremona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Pierluigi' AND cognome='Monteverdi' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3126', '2026-05-14', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Maria Letizia', 'Capria', '3425028337', False, 'letstitti@gmail.com', 'cremona', '1959-08-02', 'Cremona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Maria Letizia' AND cognome='Capria' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3128', '2026-05-19', False, False)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Guendalina', 'Triacchini', '3890039827', False, 'guendalina@triacchini.it', 'cremona', '1970-12-05', 'Cremona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Guendalina' AND cognome='Triacchini' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3129', '2026-05-19', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Valerio', 'Gamba', NULL, False, 'valerio.gamba.cr@gmail.com', 'cremona', '1978-01-11', 'Paderno Ponchielli', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Valerio' AND cognome='Gamba' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3130', '2026-05-19', False, False)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Santi', 'Alberto (& Laura)', '3480661202', False, 'alberto.santi@fastpiu.it', 'cremona', '1965-11-11', 'Cremona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Santi' AND cognome='Alberto (& Laura)' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3131', '2026-03-07', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Marta', 'Vaghi', '3395466644', False, 'vaghi.sala@gmail.com', 'cremona', '1997-08-11', 'Maleo', 'Lodi')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Marta' AND cognome='Vaghi' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3132', '2026-05-06', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Giovanna', 'Nicola Guardia', '3333022220', False, 'giovannanicolaguardi@gmail.com', 'cremona', '1958-09-08', 'Cremona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Giovanna' AND cognome='Nicola Guardia' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3133', '2026-05-26', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Daniela', 'Aldrisi', '3336512714', False, 'aldrisidaniela@gmail.com', 'cremona', '1954-08-11', 'Cremona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Daniela' AND cognome='Aldrisi' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3134', '2026-05-26', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Patrizia', 'Gogna', '3381404112', False, 'gognapatrizia@gmail.com', 'cremona', '1962-10-30', 'Pralboino', 'Brescia')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Patrizia' AND cognome='Gogna' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3135', '2026-05-30', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Beatrice', 'Strevignoli', '3405183198', False, 'beatrice.giuseppe@live.it', 'cremona', '1960-04-30', 'Cremona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Beatrice' AND cognome='Strevignoli' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3136', '2026-05-16', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Cinzia', 'Tomasi', '3463622327', False, '75cinzia@gmail.com', 'cremona', '1975-08-12', 'Redondesco', 'Mantova')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Cinzia' AND cognome='Tomasi' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3137', '2026-05-30', False, False)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Aureliana', 'Pagliari', NULL, False, NULL, 'cremona', NULL, NULL, NULL)
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Aureliana' AND cognome='Pagliari' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3138', '2026-05-30', False, False)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Benedetta', 'Negri', '3429216211', False, 'negri.benedetta@gmail.com', 'cremona', '1963-06-09', 'Cremona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Benedetta' AND cognome='Negri' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3139', '2026-06-25', False, False)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Maria Paola', 'Gaggia', '3406054532', False, 'mpgaggia@libero.it', 'cremona', '1969-09-20', 'Cremona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Maria Paola' AND cognome='Gaggia' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3140', '2026-03-04', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
    IF tid IS NOT NULL THEN
      INSERT INTO tessere_sconti (tessera_id, data_utilizzo, valore_sconto)
      VALUES (tid, '2026-08-01', '€20');
    END IF;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Francesca', 'Vannutelli', '3474137357', False, NULL, 'cremona', '1946-06-26', 'Cremona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Francesca' AND cognome='Vannutelli' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3141', '2026-06-16', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Cosetta', 'Ferrari', '3384111689', False, 'ferraricosetta@gmail.com', 'cremona', '1965-03-22', 'Olmetta', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Cosetta' AND cognome='Ferrari' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3142', '2026-06-25', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Clelia', 'Gobbi', '3338479991', False, 'gobbiclelia@gmail.com', 'cremona', '1950-12-10', 'Remedello', 'Brescia')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Clelia' AND cognome='Gobbi' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3143', '2026-06-25', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Laura', 'Galelli', '3703716774', False, 'lauragalelli@gmail.com', 'cremona', '1981-04-13', 'Cremona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Laura' AND cognome='Galelli' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3144', '2026-06-01', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
    IF tid IS NOT NULL THEN
      INSERT INTO tessere_sconti (tessera_id, data_utilizzo, valore_sconto)
      VALUES (tid, '2026-06-12', '€20');
    END IF;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Maria Grazia', 'Cavagnoli', '3337563003', False, NULL, 'cremona', '1956-02-15', 'Cremona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Maria Grazia' AND cognome='Cavagnoli' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3146', '2026-06-16', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Giovanna', 'Barbisotti', '3384212284', False, 'giovabar@hotmail.it', 'cremona', '1955-03-19', 'Cremona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Giovanna' AND cognome='Barbisotti' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3147', '2026-06-25', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Andrea', 'Fornari', NULL, False, 'afar1776@gmail.com', 'cremona', '1969-02-23', 'Cremona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Andrea' AND cognome='Fornari' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3149', '2026-06-25', False, False)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Michela', 'Venturini', '3480359091', False, 'mikyvent@gmail.com', 'cremona', '1965-04-06', 'Cremona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Michela' AND cognome='Venturini' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3150', '2026-06-25', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Chiara', 'Guarato', '3386293906', False, 'guarato.chiara@gmail.com', 'cremona', '1979-08-15', 'Quinzano D''Oglio', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Chiara' AND cognome='Guarato' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3152', '2026-07-01', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Luigina', 'Barbeno', '3393924206', False, 'luiginabarbeno@gmail.com', 'cremona', '1966-02-02', 'Travagliato', 'Brescia')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Luigina' AND cognome='Barbeno' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3153', '2026-07-01', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Giuseppina Rita', 'Rizzi', '3297368631', False, NULL, 'cremona', '1947-04-10', 'Cremona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Giuseppina Rita' AND cognome='Rizzi' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3154', '2026-07-01', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Maria', 'Morando', '3924536168', False, 'maria.morando2@gmail.com', 'cremona', '1996-07-01', 'parigi', NULL)
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Maria' AND cognome='Morando' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3155', '2002-07-01', False, False)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Andrea', 'Cariani', '3202187507', False, 'andrea.cariani92@gmail.com', 'cremona', '1992-11-14', 'Cremona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Andrea' AND cognome='Cariani' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3156', '2026-07-02', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Samantha', 'Banzi', '3488768441', False, 'samantha.banzi@gmail.com', 'cremona', '1975-05-18', 'cremona', 'cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Samantha' AND cognome='Banzi' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3157', '2026-07-01', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Terenzio', 'Ciancarelli', '3333538296', False, 'terenziociancarelli@gmail.com', 'cremona', NULL, 'cremona', 'cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Terenzio' AND cognome='Ciancarelli' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3158', '2026-07-01', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Licia', 'Fiamenghi', '3332661866', False, 'liciarosfiam@gmail.com', 'cremona', '1961-03-22', 'cremona', 'cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Licia' AND cognome='Fiamenghi' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3159', '2026-07-01', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Milena', 'Del Barba', '3493127881', False, 'bersale.marazzi@tiscali.it', 'cremona', '1974-07-11', 'Corte de'' Frati', 'cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Milena' AND cognome='Del Barba' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3160', '2026-07-01', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Margherita', 'Oneta', '3403088495', False, 'margheoneta@gmail.com', 'cremona', '1964-01-14', 'cremona', 'cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Margherita' AND cognome='Oneta' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3163', '2026-07-01', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Federica', 'Stargiotti', '3338770826', False, 'fstargiotti@gmail.com', 'cremona', '1990-04-15', 'Leno', 'Brescia')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Federica' AND cognome='Stargiotti' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3164', '2026-07-01', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Francesca', 'Grasselli', '3484454677', False, 'stangagrasselli@gmail.com', 'cremona', '1962-03-20', 'cremona', 'cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Francesca' AND cognome='Grasselli' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3165', '2026-07-01', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Giuseppina', 'Marino', '3478745102', False, 'giusy1959@live.com', 'cremona', '1959-03-07', 'cremona', 'cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Giuseppina' AND cognome='Marino' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3166', '2026-07-01', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Pierluigi', 'Baronio', '335218409', False, 'p.baronio@telecolor.net', 'cremona', '1958-03-24', 'cremona', 'cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Pierluigi' AND cognome='Baronio' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3167', '2026-07-01', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Maria', 'Perrone', '3389797169', False, 'ma-perrone@libero.it', 'cremona', '1972-04-07', 'cremona', 'cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Maria' AND cognome='Perrone' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3169', '2026-07-01', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Katia', 'Moratti', '3333692738', False, 'kmpicasso64@gmail.com', 'cremona', '1964-11-16', 'cremona', 'cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Katia' AND cognome='Moratti' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3170', '2026-07-21', False, False)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Patrizia', 'Mazzini', '3381085089', False, 'mazzpat60@gmail.com', 'cremona', '1960-10-06', 'cremona', 'cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Patrizia' AND cognome='Mazzini' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3171', '2026-07-24', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Marco', 'Bonini', '3388671653', False, 'duequarti@gmail.com', 'cremona', '1959-12-26', 'Cremona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Marco' AND cognome='Bonini' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3172', '2026-07-29', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Maria Chiara', 'Tolomini', '3355733055', False, 'mariachiara.tolomini@libero.it', 'cremona', '1963-07-06', 'Cremona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Maria Chiara' AND cognome='Tolomini' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3173', '2026-06-25', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Silvia', 'Sofia', '3404661577', False, 'silviasofia2000@gmail.com', 'cremona', '2000-04-14', 'Cremona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Silvia' AND cognome='Sofia' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3174', '2026-06-25', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Alessandra', 'Mombelli', '3348503360', False, 'sandramombelli@libero.it', 'cremona', '1965-01-20', 'Cremona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Alessandra' AND cognome='Mombelli' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3175', '2026-06-25', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Alessia', 'Ghidetti', '9395077250', False, 'alessiaghidetti71@gmail.com', 'cremona', '1971-10-20', 'Pieve s.giacomo', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Alessia' AND cognome='Ghidetti' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3176', '2026-05-21', False, False)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Sara', 'Cavalli', '3475961513', False, 'sari.79@virgilio.it', 'cremona', '1979-12-14', 'Cremona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Sara' AND cognome='Cavalli' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3177', '2026-05-21', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Ardea', 'Mainardi', '3473430380', False, 'ardea.mainardi@gmail.com', 'cremona', '1993-12-24', 'Cremona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Ardea' AND cognome='Mainardi' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3178', '2026-05-19', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Federica', 'Priori', '3489327082', False, 'fede.priori@gmail.com', 'cremona', '1984-11-09', 'Cremona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Federica' AND cognome='Priori' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3179', '2026-05-07', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Margherita', 'Pozzi', '3926288126', False, 'margherita.pozzi@icloud.com', 'cremona', '1995-12-11', 'Cremona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Margherita' AND cognome='Pozzi' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3180', '2026-05-07', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Federica', 'Verdelli', '3480367696', False, 'federica.verdelli@gmail.com', 'cremona', '1988-09-15', 'Cremona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Federica' AND cognome='Verdelli' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3181', '2026-05-07', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Elena', 'Taje''', '3206772253', False, 'taje_mariola@libero.it', 'cremona', '1969-03-31', 'Cremona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Elena' AND cognome='Taje''' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3183', '2026-04-24', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Margherita', 'Vacchelli', '3384610371', False, 'margherita.vacchelli@alice.it', 'cremona', '1956-05-09', 'Cremona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Margherita' AND cognome='Vacchelli' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3184', '2026-04-24', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Moira', 'Grassi', '3203090203', False, 'grassimoira@libero.it', 'cremona', '1976-09-11', 'Annicco', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Moira' AND cognome='Grassi' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3185', '2026-04-23', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Rossella', 'Mazzini', '3404608299', False, 'rosmaz48@gmail.com', 'cremona', '1948-05-16', 'Cremona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Rossella' AND cognome='Mazzini' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3186', '2026-04-15', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Giusi', 'Rizzi', '3355770724', False, 'giusi.rizzi.61@gmail.com', 'cremona', '1961-05-22', 'San Paolo', 'Brescia')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Giusi' AND cognome='Rizzi' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3187', '2026-04-15', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Gerardo', 'Bambino', '3311245710', False, 'gerardo.b@tin.it', 'cremona', '1957-01-10', 'Piacenza', 'Piacenza')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Gerardo' AND cognome='Bambino' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3188', '2026-01-27', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
    IF tid IS NOT NULL THEN
      INSERT INTO tessere_sconti (tessera_id, data_utilizzo, valore_sconto)
      VALUES (tid, '2026-09-19', '€20');
    END IF;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Laura', 'Rossi', '3358154430', False, 'laurarossimanfredi@gmail.com', 'cremona', '1972-11-23', 'Cremona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Laura' AND cognome='Rossi' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3189', '2026-04-08', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Sabrina', 'Mainardi', '3357056455', False, 'sabrina.mainardi.b@gmail.com', 'cremona', '1968-06-23', 'Casalecchio di Reno', 'Bologna')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Sabrina' AND cognome='Mainardi' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3190', '2026-07-29', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Bianca', 'Oradini', '3393772129', False, 'bianca.oradini@gmail.com', 'cremona', '1997-03-23', 'Cremona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Bianca' AND cognome='Oradini' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3191', '2026-07-31', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Marina', 'Gerevini', '3386857936', False, 'marina.gerevini@yahoo.com', 'cremona', '1956-04-01', 'Cremona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Marina' AND cognome='Gerevini' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3192', '2025-01-20', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Maria Paola', 'Gaggia', '3406054532', False, 'mpgaggia@libero.it', 'cremona', '1969-09-20', 'Cremona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Maria Paola' AND cognome='Gaggia' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3194', '2026-03-04', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
    IF tid IS NOT NULL THEN
      INSERT INTO tessere_sconti (tessera_id, data_utilizzo, valore_sconto)
      VALUES (tid, '2026-09-01', '€20');
    END IF;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Luciana Elena', 'Finardi', '3381891137', False, 'lucianaelenafinardi@gmailcom', 'cremona', '1970-02-16', 'Cremona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Luciana Elena' AND cognome='Finardi' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3195', '2026-08-03', False, False)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Nadia', 'Marchetti', '3471136971', False, 'nadia.marchetti60@gmail.com', 'cremona', '1960-01-17', 'Cremona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Nadia' AND cognome='Marchetti' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3196', '2026-08-05', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Chiara', 'Pagliarini', '3381801428', False, 'chiara.pagliarini@yahoo.it', 'cremona', '1975-09-17', 'Cremona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Chiara' AND cognome='Pagliarini' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3197', '2026-08-07', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Lorenza', 'Ruggieri', '3385374176', False, 'olivetta@outlook.es', 'cremona', '1971-02-17', 'Cremona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Lorenza' AND cognome='Ruggieri' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3198', '2026-08-08', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Anna Maria', 'Beccari', '3357646359', False, 'beccariannamaria@gmail.com', 'cremona', '1966-05-06', 'Cremona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Anna Maria' AND cognome='Beccari' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3199', '2026-08-18', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Danila', 'Zanini', '3382289450', False, 'zaninidanila@gmail.com', 'cremona', '1961-10-12', 'Cremona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Danila' AND cognome='Zanini' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3200', '2026-08-18', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Alessandra', 'Toresani', '3280267145', False, 'fermini.toresani@gmail.com', 'cremona', '1971-01-30', 'Cremona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Alessandra' AND cognome='Toresani' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3201', '2026-08-18', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Manuela', 'Dati', '3463378040', False, 'manuela.dati@acbgroup.com', 'cremona', '1962-08-03', 'Cremona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Manuela' AND cognome='Dati' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3202', '2026-08-19', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Lorenza', 'Bonetta', '3473972434', False, 'lorenza.bonetta@yahoo.it', 'cremona', '1961-10-08', 'Pescarolo ed Uniti', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Lorenza' AND cognome='Bonetta' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3204', '2029-08-24', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Laura', 'Ghigi', '3409671719', False, 'lauraghigi@gmail.com', 'cremona', '1957-08-14', 'Cremona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Laura' AND cognome='Ghigi' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3206', '2026-08-29', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Egle (Tullia)', 'Biazzi Tosani', '3936569485', False, NULL, 'cremona', NULL, 'Cremona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Egle (Tullia)' AND cognome='Biazzi Tosani' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3207', '2026-08-29', False, False)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Maria Paola', 'Gaggia', '3406054532', False, 'mpgaggia@libero.it', 'cremona', '1969-09-20', 'Cremona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Maria Paola' AND cognome='Gaggia' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3208', '2026-08-29', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Daniela', 'Riccardi', '3286334866', False, 'bergonzifamily@yahoo.it', 'cremona', '1963-07-25', 'Cremona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Daniela' AND cognome='Riccardi' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3209', '2026-09-01', False, False)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Francesca', 'Sora', '3334626619', False, 'francesca@studiosora.it', 'cremona', '1960-05-20', 'Cremona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Francesca' AND cognome='Sora' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3210', '2026-09-12', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Yesenia', 'De La Rosa', '3279075633', False, 'yesenia2delarosa@hotmail.com', 'cremona', '1958-09-14', 'Cremona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Yesenia' AND cognome='De La Rosa' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3211', '2026-09-01', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Simona', 'Salvini', '3474660127', False, 'simsalv@tiscali.it', 'cremona', '1969-06-09', 'Cremona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Simona' AND cognome='Salvini' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3212', '2026-09-01', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Maria', 'Caraci Vela', '3338439559', False, 'maria.caraci@unipv.it', 'cremona', '1946-03-11', 'Cremona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Maria' AND cognome='Caraci Vela' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3213', '2026-09-10', False, False)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Simona', 'Quieto', '3477677673', False, 'quietos77@icloud.com', 'cremona', '1977-01-10', 'Cremona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Simona' AND cognome='Quieto' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3214', '2026-09-11', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Patrizia', 'Poletti', '3474305617', False, NULL, 'cremona', '1956-05-29', 'Cremona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Patrizia' AND cognome='Poletti' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3215', '2026-09-11', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Alice', 'Depoli', '3478755320', False, 'bewitched1979@icloud.com', 'cremona', '1979-09-11', 'Cremona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Alice' AND cognome='Depoli' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3216', '2026-09-11', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Maura', 'Pedroni', '3333690180', False, 'maura.pedroni1@gmail.com', 'cremona', '1958-05-12', 'Cremona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Maura' AND cognome='Pedroni' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3217', '2026-09-12', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Sara', 'Bernardini', '3395854068', False, 'sarabernardini79@libero.it', 'cremona', '1979-05-23', 'Cremona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Sara' AND cognome='Bernardini' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3218', '2026-09-12', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Laura', 'Galelli', '3703716774', False, 'lauragalelli@gmail.com', 'cremona', '1981-04-13', 'Cremona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Laura' AND cognome='Galelli' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3219', '2026-09-12', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Alex', 'De Palma', '3388773937', False, 'alexdp197777@gmail.com', 'cremona', '1977-02-13', 'Fidenza', 'Parma')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Alex' AND cognome='De Palma' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3220', '2026-09-12', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Giovanna', 'Boccali', '3383902508', False, 'giovanna.boccali1@live.com', 'cremona', '1954-09-27', 'Cremona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Giovanna' AND cognome='Boccali' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3224', '2026-09-16', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Giuliana', 'Bertuzzi', '3332148104', False, 'geagauss@libero.it', 'cremona', '1963-04-10', 'Vescovato', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Giuliana' AND cognome='Bertuzzi' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3225', '2026-09-16', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Laura', 'Ferrari', '3381778508', False, 'laurasurela@yahoo.it', 'cremona', '1980-11-07', 'Cremona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Laura' AND cognome='Ferrari' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3226', '2026-09-18', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Gerardo', 'Bambino', '3311245710', False, 'gerardo.b@tin.it', 'cremona', '1957-01-10', 'Piacenza', 'Piacenza')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Gerardo' AND cognome='Bambino' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3227', '2026-09-19', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Laura', 'Gerevini', '3475128394', False, 'laura.gerevini@comune.cremona.it', 'cremona', '1966-09-06', 'Cremona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Laura' AND cognome='Gerevini' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3228', '2026-09-19', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Cinzia', 'Tomasi', '3463622327', False, '75cinzia@gmail.com', 'cremona', '1975-08-12', 'Redondesco', 'Mantova')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Cinzia' AND cognome='Tomasi' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3229', '2026-09-19', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Chiara', 'Rizzi', '3479231902', False, 'chiara.rizzi@gmail.com', 'cremona', '1963-12-21', 'Bonemerse', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Chiara' AND cognome='Rizzi' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3230', '2026-09-19', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Marisa', 'Barbieri', '3332914024', False, 'b.marisa0612@gmail.com', 'cremona', '2026-12-06', 'Piadena Drizzona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Marisa' AND cognome='Barbieri' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3231', '2026-09-19', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Lucia', 'Cariani', '3472498581', False, 'luciacariani@yahoo.it', 'cremona', '1990-12-31', 'Cremona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Lucia' AND cognome='Cariani' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3232', '2026-09-19', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Cesarina', 'Zinetti', '3341886648', False, 'cesi.zinetti@gmail.com', 'cremona', '1985-08-03', 'Cremona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Cesarina' AND cognome='Zinetti' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3233', '2026-09-22', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Rossella', 'Susta', '3460792628', False, 'tr.gallusta@gmail.com', 'cremona', '1958-09-07', 'Cremona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Rossella' AND cognome='Susta' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3234', '2026-09-22', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Giovanna', 'Ardemagni', '3406101556', False, 'gardemagni@libero.it', 'cremona', '1962-10-19', 'Cremona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Giovanna' AND cognome='Ardemagni' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3235', '2026-09-22', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Gabriella', 'Spotti', '3773085031', False, 'gabriella.spotti@gmail.com', 'cremona', '1974-06-19', 'Cremona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Gabriella' AND cognome='Spotti' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3236', '2026-09-23', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Carla', 'Sperzaga', '3386168279', False, 'carlopini@gmail.com', 'cremona', '1950-11-24', 'Monticelli D''ongina', 'Piacenza')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Carla' AND cognome='Sperzaga' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3237', '2025-09-24', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Annalisa', 'Telò', '3207299124', False, 'annalisa.telo@gmail.com', 'cremona', '1993-08-31', 'Cremona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Annalisa' AND cognome='Telò' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3238', '2026-09-26', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Sharon', 'Sacchini', '3343697144', False, 'shanny92@hotmail.it', 'cremona', '1992-09-29', 'Cremona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Sharon' AND cognome='Sacchini' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3239', '2026-09-26', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Anna Ottilia', 'Limoni', '3487139986', False, 'annaottilia.limoni@gmail.com', 'cremona', '1949-04-05', 'Cremona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Anna Ottilia' AND cognome='Limoni' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3240', '2026-09-26', False, False)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Veronica', 'Orlando', '3336964296', False, 'vero.orlando7@gmail.com', 'cremona', '1975-03-06', 'Cremona', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Veronica' AND cognome='Orlando' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'cremona', '3241', '2026-09-29', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Cristina', 'Copelli', '3468684966', False, NULL, 'casalmaggiore', '1960-09-15', 'Casalmaggiore', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Cristina' AND cognome='Copelli' AND emporio='casalmaggiore' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'casalmaggiore', '104/CA', '2026-01-21', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Giovanna', 'Raineri', '3494249980', True, 'gianna.rai64@gmail.com', 'casalmaggiore', '1964-05-26', 'Casalmaggiore', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Giovanna' AND cognome='Raineri' AND emporio='casalmaggiore' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'casalmaggiore', '105/CA', '2026-02-07', True, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Annamaria', 'Boroni Grazioli', '3466789126', False, NULL, 'casalmaggiore', '1959-05-03', 'Sabbioneta', 'Mantova')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Annamaria' AND cognome='Boroni Grazioli' AND emporio='casalmaggiore' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'casalmaggiore', '106/CA', '2026-02-07', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Maria Rosa', 'Ragazzini', '3288621624', True, 'mariarosa.ragazzini61@gmail.com', 'casalmaggiore', '1961-12-08', 'Casalmaggiore', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Maria Rosa' AND cognome='Ragazzini' AND emporio='casalmaggiore' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'casalmaggiore', '107/CA', '2026-02-12', True, False)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Sarah', 'Alessandrini', '3396370032', True, 'alessandrini.sarah@libero.it', 'casalmaggiore', '1969-10-20', 'Casalmaggiore', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Sarah' AND cognome='Alessandrini' AND emporio='casalmaggiore' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'casalmaggiore', '108/CA', '2026-02-21', True, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Cosima', 'Prete', '3206878400', True, 'mimma.prete@gmail.com', 'casalmaggiore', '1988-05-28', 'Casalmaggiore', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Cosima' AND cognome='Prete' AND emporio='casalmaggiore' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'casalmaggiore', '109/CA', '2026-02-28', True, False)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Annamaria', 'Boroni Grazioli', '3466789126', False, NULL, 'casalmaggiore', '1959-05-03', 'Sabbioneta', 'Mantova')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Annamaria' AND cognome='Boroni Grazioli' AND emporio='casalmaggiore' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'casalmaggiore', '110/CA', '2026-03-14', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Giovanna', 'Raineri', '3494249980', True, 'gianna.rai64@gmail.com', 'casalmaggiore', '1964-05-26', 'Casalmaggiore', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Giovanna' AND cognome='Raineri' AND emporio='casalmaggiore' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'casalmaggiore', '111/CA', '2026-03-19', True, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Giovanna', 'Raineri', '3494249980', True, 'gianna.rai64@gmail.com', 'casalmaggiore', '1964-05-26', 'Casalmaggiore', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Giovanna' AND cognome='Raineri' AND emporio='casalmaggiore' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'casalmaggiore', '112/CA', '2026-04-11', True, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Maria Marcella', 'Scaravonati', '3880518440', True, 'marascaravonati@alice.it', 'casalmaggiore', '1956-03-23', 'Casalmaggiore', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Maria Marcella' AND cognome='Scaravonati' AND emporio='casalmaggiore' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'casalmaggiore', '113/CA', '2026-04-29', True, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Lucrezia', 'Olivieri', '3465260604', True, 'lucreziaolivieri@gmail.com', 'casalmaggiore', '1998-08-15', 'Casalmaggiore', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Lucrezia' AND cognome='Olivieri' AND emporio='casalmaggiore' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'casalmaggiore', '114/CA', '2026-05-09', True, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Martina', 'Buttarelli', '3381072991', True, 'buttarelli.m81@gmail.com', 'casalmaggiore', '1981-12-28', 'Casalmaggiore', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Martina' AND cognome='Buttarelli' AND emporio='casalmaggiore' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'casalmaggiore', '115/CA', '2026-05-23', True, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Maria Luisa', 'Manfredi', '3204213440', False, NULL, 'casalmaggiore', '1949-10-15', 'Casalmaggiore', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Maria Luisa' AND cognome='Manfredi' AND emporio='casalmaggiore' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'casalmaggiore', '116/CA', '2026-05-23', False, False)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Paola', 'Vezzoni', '3403112761', True, 'vezzonipaola@libero.it', 'casalmaggiore', '1962-11-27', 'Casalmaggiore', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Paola' AND cognome='Vezzoni' AND emporio='casalmaggiore' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'casalmaggiore', '117/CA', '2026-05-30', True, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Cristina', 'Copelli', '3468684966', False, NULL, 'casalmaggiore', '1960-09-14', 'Casalmaggiore', 'Cremona')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Cristina' AND cognome='Copelli' AND emporio='casalmaggiore' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'casalmaggiore', '120/CA', '2026-06-13', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Antonella', 'Avigni', '3472156280', False, NULL, 'viadana', '1977-06-19', 'Viadana', 'Mantova')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Antonella' AND cognome='Avigni' AND emporio='viadana' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'viadana', '360', '2025-01-29', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Maria Luisa', 'Benvenuti', NULL, True, 'mluisa.benvenuti@gmail.com', 'viadana', '1952-07-06', 'Viadana', 'Mantova')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Maria Luisa' AND cognome='Benvenuti' AND emporio='viadana' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'viadana', '361', '2025-02-06', True, False)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Paola', 'Miglio', NULL, True, 'paolamiglio7@gmail.com', 'viadana', '1965-07-21', 'Viadana', 'Mantova')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Paola' AND cognome='Miglio' AND emporio='viadana' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'viadana', '362', '2025-02-06', True, False)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Marco', 'D''Agostino', '3397825117', True, 'donmarco1970@gmail.com', 'viadana', '1970-06-03', 'Viadana', 'Mantova')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Marco' AND cognome='D''Agostino' AND emporio='viadana' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'viadana', '363', '2025-03-15', True, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Rosa', 'Zeli', '3452622593', False, NULL, 'viadana', '1961-08-05', 'Viadana', 'Mantova')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Rosa' AND cognome='Zeli' AND emporio='viadana' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'viadana', '364', '2025-05-09', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Marina', 'Rossi', '3482857435', True, 'marinarossi69@hotmail.com', 'viadana', '1969-09-16', 'Viadana', 'Mantova')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Marina' AND cognome='Rossi' AND emporio='viadana' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'viadana', '365', '2025-05-21', True, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Paola', 'Fantini', '3332508066', False, NULL, 'viadana', '1955-07-16', 'Viadana', 'Mantova')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Paola' AND cognome='Fantini' AND emporio='viadana' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'viadana', '366', '2025-05-30', False, False)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Giuseppe', 'Rizzi', '3471642471', True, 'rizzi6353@gmail.com', 'viadana', '1953-03-06', 'Viadana', 'Mantova')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Giuseppe' AND cognome='Rizzi' AND emporio='viadana' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'viadana', '367', '2025-07-17', True, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Francesca', 'Sartor', '3341312475', True, 'francy.sartor3@gmail.com', 'viadana', '1995-12-26', 'Viadana', 'Mantova')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Francesca' AND cognome='Sartor' AND emporio='viadana' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'viadana', '368', '2025-06-21', True, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Lucia', 'Padova', '3661740482', True, 'luciapadova86@gmail.com', 'viadana', '1959-03-19', 'Viadana', 'Mantova')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Lucia' AND cognome='Padova' AND emporio='viadana' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'viadana', '369', '2025-08-22', True, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Valeria', 'Facchetti', NULL, True, 'valeria.facchetti.81@gmail.com', 'viadana', '1981-06-25', 'Viadana', 'Mantova')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Valeria' AND cognome='Facchetti' AND emporio='viadana' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'viadana', '370', '2025-09-30', True, False)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Anna Carlotta', 'Grassi', NULL, True, 'carlot_grassi@hotmail.it', 'viadana', '1989-10-30', 'Boretto', 'Reggio Emilia')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Anna Carlotta' AND cognome='Grassi' AND emporio='viadana' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'viadana', '371', '2025-09-04', True, False)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Antonella', 'Avigni', NULL, True, 'antonella.avigni71@gmail.com', 'viadana', '1971-06-19', 'Viadana', 'Mantova')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Antonella' AND cognome='Avigni' AND emporio='viadana' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'viadana', '372', '2025-09-26', True, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Paola', 'Fantini', '3332508066', False, NULL, 'viadana', '1955-07-16', 'Viadana', 'Mantova')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Paola' AND cognome='Fantini' AND emporio='viadana' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'viadana', '373', '2025-11-27', False, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Anna', 'Tassoni', NULL, True, 'trivel_f@alice.it', 'viadana', '1963-08-28', 'Viadana', 'Mantova')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Anna' AND cognome='Tassoni' AND emporio='viadana' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'viadana', '374', '2025-12-12', True, False)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Marina', 'Zaffanella', NULL, True, 'zaffanellamarina@gmail.com', 'viadana', '1972-03-20', 'Viadana', 'Mantova')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Marina' AND cognome='Zaffanella' AND emporio='viadana' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'viadana', '375', '2025-12-13', True, False)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Ilaria', 'Orlandelli', '3495349524', True, 'ilariaorla@yahoo.it', 'viadana', '1983-02-20', 'Viadana', 'Mantova')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Ilaria' AND cognome='Orlandelli' AND emporio='viadana' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'viadana', '376', '2026-01-23', True, False)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Valeria', 'Facchetti', '3295490428', True, 'valeria.facchetti.81@gmail.com', 'viadana', '1981-06-25', 'Viadana', 'Mantova')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Valeria' AND cognome='Facchetti' AND emporio='viadana' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'viadana', '377', '2026-02-20', True, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('luigi', 'Gardini', '3491296429', True, 'gluros@katamail.com', 'viadana', '1960-02-13', 'Viadana', 'Mantova')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='luigi' AND cognome='Gardini' AND emporio='viadana' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'viadana', '382', '2025-12-20', True, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, telefono, wa, email, emporio, data_nascita, citta, provincia)
  VALUES ('Paola', 'Fantini', '3332508066', True, 'baruffaldi.g@gmail.com', 'viadana', '1955-07-16', 'Viadana', 'Mantova')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Paola' AND cognome='Fantini' AND emporio='viadana' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio, codice_tessera, data_emissione, ha_whatsapp, in_lista_broadcast_whatsapp)
    VALUES (cid, 'standard', 'viadana', '383', '2025-01-08', True, True)
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;


-- AMBASSADOR CLIENTS
DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Angiola Maria', 'Agarossi', 'cremona', '1950-04-04')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Angiola Maria' AND cognome='Agarossi' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'cremona')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Giuseppina', 'Alari', 'cremona', '1949-08-06')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Giuseppina' AND cognome='Alari' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'cremona')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Giorgia', 'Ambrosio', 'cremona', '1998-10-26')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Giorgia' AND cognome='Ambrosio' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'cremona')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Antonio', 'Ariberti', 'cremona', '1964-06-26')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Antonio' AND cognome='Ariberti' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'cremona')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Domenico', 'Basile', 'cremona', '1959-10-17')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Domenico' AND cognome='Basile' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'cremona')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Tina', 'Bassanetti', 'cremona', '1939-08-29')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Tina' AND cognome='Bassanetti' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'cremona')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Patrizia', 'Bassi', 'cremona', '1958-09-09')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Patrizia' AND cognome='Bassi' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'cremona')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Carla', 'Bellani', 'cremona', '1949-12-14')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Carla' AND cognome='Bellani' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'cremona')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Carla', 'Bellintani', 'cremona', '1961-11-04')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Carla' AND cognome='Bellintani' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'cremona')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Laura', 'Bettoni', 'cremona', '1982-08-23')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Laura' AND cognome='Bettoni' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'cremona')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Francesca', 'Bignelli', 'cremona', '1981-10-15')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Francesca' AND cognome='Bignelli' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'cremona')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Silvia', 'Bonomi', 'cremona', '1983-10-28')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Silvia' AND cognome='Bonomi' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'cremona')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Sara', 'Bonvicini', 'cremona', '1988-01-05')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Sara' AND cognome='Bonvicini' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'cremona')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Maurella', 'Canova', 'cremona', '1950-05-20')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Maurella' AND cognome='Canova' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'cremona')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Elena', 'Capoani', 'cremona', '1976-09-13')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Elena' AND cognome='Capoani' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'cremona')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Gianluigi', 'Cappellini', 'cremona', '1959-10-24')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Gianluigi' AND cognome='Cappellini' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'cremona')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Sergio', 'Caravaggio', 'cremona', '1967-05-13')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Sergio' AND cognome='Caravaggio' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'cremona')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Giuseppe Bernardo', 'Casali', 'cremona', '1958-06-11')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Giuseppe Bernardo' AND cognome='Casali' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'cremona')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Roberto', 'Cassettana', 'cremona', '1970-06-05')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Roberto' AND cognome='Cassettana' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'cremona')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Elena Maria', 'Cattani', 'cremona', '1967-05-09')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Elena Maria' AND cognome='Cattani' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'cremona')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
    IF tid IS NOT NULL THEN
      INSERT INTO tessere_sconti (tessera_id, data_utilizzo, valore_sconto)
      VALUES (tid, '2026-04-02', '€25');
    END IF;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Massimiliano', 'Ciocca', 'cremona', '1975-04-15')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Massimiliano' AND cognome='Ciocca' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'cremona')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Maddalena', 'Ciozzani', 'cremona', '1991-02-07')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Maddalena' AND cognome='Ciozzani' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'cremona')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Chiara', 'Coelli', 'cremona', '1968-03-24')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Chiara' AND cognome='Coelli' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'cremona')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Maria Pia', 'Collini', 'cremona', '1956-11-15')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Maria Pia' AND cognome='Collini' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'cremona')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Grazia', 'Contardi', 'cremona', '1947-02-14')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Grazia' AND cognome='Contardi' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'cremona')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Massimo', 'Cremonini Bianchi', 'cremona', '1958-09-13')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Massimo' AND cognome='Cremonini Bianchi' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'cremona')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Marco', 'De Angelis', 'cremona', '1977-07-27')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Marco' AND cognome='De Angelis' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'cremona')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Silvia', 'De Donno', 'cremona', '1974-02-11')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Silvia' AND cognome='De Donno' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'cremona')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Ugo', 'Di Felice', 'cremona', '1961-01-29')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Ugo' AND cognome='Di Felice' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'cremona')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Elvira', 'Di Mascia', 'cremona', '1967-10-21')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Elvira' AND cognome='Di Mascia' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'cremona')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Ettore', 'Dodi', 'cremona', '1958-08-08')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Ettore' AND cognome='Dodi' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'cremona')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Vittorio', 'Dotti', 'cremona', '1964-02-04')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Vittorio' AND cognome='Dotti' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'cremona')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Elena', 'Duchi', 'cremona', '1933-02-01')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Elena' AND cognome='Duchi' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'cremona')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Angela', 'Faldi', 'cremona', '1936-07-29')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Angela' AND cognome='Faldi' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'cremona')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Miriam', 'Federici', 'cremona', '1998-06-15')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Miriam' AND cognome='Federici' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'cremona')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Nella', 'Ferrari', 'cremona', '1936-11-21')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Nella' AND cognome='Ferrari' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'cremona')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Edoardo', 'Ferrari', 'cremona', '1941-07-14')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Edoardo' AND cognome='Ferrari' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'cremona')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Paolo', 'Finozzi', 'cremona', '1964-08-21')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Paolo' AND cognome='Finozzi' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'cremona')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Susanna', 'Fiorentini', 'cremona', '1987-08-20')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Susanna' AND cognome='Fiorentini' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'cremona')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Maria Grazia', 'Fioretti', 'cremona', '1955-07-26')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Maria Grazia' AND cognome='Fioretti' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'cremona')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Monica', 'Fiori', 'cremona', '1963-02-25')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Monica' AND cognome='Fiori' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'cremona')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Alessandro', 'Fornaroli', 'cremona', NULL)
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Alessandro' AND cognome='Fornaroli' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'cremona')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Silvia', 'Frati', 'cremona', '1972-12-16')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Silvia' AND cognome='Frati' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'cremona')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Duncan Lou', 'Frosi', 'cremona', '1981-12-04')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Duncan Lou' AND cognome='Frosi' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'cremona')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Giulia', 'Galelli', 'cremona', '1988-04-12')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Giulia' AND cognome='Galelli' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'cremona')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Sergio', 'Galimberti', 'cremona', '1937-01-03')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Sergio' AND cognome='Galimberti' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'cremona')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Gianluca', 'Galimberti', 'cremona', '1968-05-30')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Gianluca' AND cognome='Galimberti' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'cremona')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Maria Cristina', 'Galimberti', 'cremona', '1966-06-05')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Maria Cristina' AND cognome='Galimberti' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'cremona')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Donata', 'Galloni', 'cremona', '1960-11-15')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Donata' AND cognome='Galloni' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'cremona')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Paolo Ettore', 'Gamba', 'cremona', '1965-04-05')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Paolo Ettore' AND cognome='Gamba' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'cremona')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Anna Teresa', 'Gennari', 'cremona', '1938-11-22')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Anna Teresa' AND cognome='Gennari' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'cremona')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Gilberto', 'Gerevini', 'cremona', '1972-04-17')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Gilberto' AND cognome='Gerevini' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'cremona')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Lorenzo', 'Girelli Carasi', 'cremona', '1982-01-20')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Lorenzo' AND cognome='Girelli Carasi' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'cremona')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Luciana', 'Guarneri', 'cremona', '1946-05-13')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Luciana' AND cognome='Guarneri' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'cremona')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Paola', 'Gusberti', 'cremona', '1963-11-16')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Paola' AND cognome='Gusberti' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'cremona')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Daniele', 'Lodrini', 'cremona', '1983-05-31')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Daniele' AND cognome='Lodrini' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'cremona')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Pasquale', 'Losapio', 'cremona', '1986-03-30')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Pasquale' AND cognome='Losapio' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'cremona')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Luisella', 'Lupatelli', 'cremona', '1946-07-13')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Luisella' AND cognome='Lupatelli' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'cremona')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Stefano', 'Lupatini', 'cremona', '1969-09-17')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Stefano' AND cognome='Lupatini' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'cremona')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Barbara', 'Machetti', 'cremona', '1963-10-16')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Barbara' AND cognome='Machetti' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'cremona')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
    IF tid IS NOT NULL THEN
      INSERT INTO tessere_sconti (tessera_id, data_utilizzo, valore_sconto)
      VALUES (tid, '2026-04-02', '€25');
    END IF;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Ave', 'Mainardi', 'cremona', '1957-10-12')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Ave' AND cognome='Mainardi' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'cremona')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Ermena', 'Manfredini', 'cremona', '1948-08-19')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Ermena' AND cognome='Manfredini' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'cremona')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Barbara', 'Manfredini', 'cremona', '1959-08-29')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Barbara' AND cognome='Manfredini' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'cremona')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Enrico Italo', 'Manfredini', 'cremona', '1960-05-06')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Enrico Italo' AND cognome='Manfredini' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'cremona')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Marina', 'Marchi', 'cremona', '1983-09-24')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Marina' AND cognome='Marchi' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'cremona')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
    IF tid IS NOT NULL THEN
      INSERT INTO tessere_sconti (tessera_id, data_utilizzo, valore_sconto)
      VALUES (tid, '2026-04-18', '€25');
    END IF;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Donatella', 'Marcotti', 'cremona', '1953-12-29')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Donatella' AND cognome='Marcotti' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'cremona')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Laura', 'Martinelli', 'cremona', '1979-08-31')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Laura' AND cognome='Martinelli' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'cremona')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Elisabetta', 'Mazzini', 'cremona', '1976-08-12')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Elisabetta' AND cognome='Mazzini' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'cremona')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Emilio', 'Mazzolari', 'cremona', '1983-10-29')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Emilio' AND cognome='Mazzolari' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'cremona')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Annamaria', 'Menta', 'cremona', '1963-02-19')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Annamaria' AND cognome='Menta' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'cremona')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Roberto', 'Milazzo', 'cremona', '1955-12-06')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Roberto' AND cognome='Milazzo' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'cremona')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Simona', 'Modesti', 'cremona', '1966-05-09')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Simona' AND cognome='Modesti' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'cremona')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Francesco', 'Monterosso', 'cremona', '1974-05-02')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Francesco' AND cognome='Monterosso' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'cremona')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
    IF tid IS NOT NULL THEN
      INSERT INTO tessere_sconti (tessera_id, data_utilizzo, valore_sconto)
      VALUES (tid, '2026-09-15', '€25');
    END IF;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Maria Lucia', 'Monterosso', 'cremona', '1980-12-29')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Maria Lucia' AND cognome='Monterosso' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'cremona')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Chiara', 'Monteverdi', 'cremona', '1983-10-02')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Chiara' AND cognome='Monteverdi' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'cremona')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Mirella', 'Mori', 'cremona', '1932-07-23')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Mirella' AND cognome='Mori' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'cremona')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Daniela', 'Negri', 'cremona', '1953-10-24')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Daniela' AND cognome='Negri' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'cremona')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Federica Maria', 'Negri', 'cremona', '1958-05-14')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Federica Maria' AND cognome='Negri' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'cremona')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Maria Paola', 'Negri', 'cremona', '1950-12-10')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Maria Paola' AND cognome='Negri' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'cremona')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Vittoria', 'Pagliara', 'cremona', '1966-03-31')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Vittoria' AND cognome='Pagliara' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'cremona')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Paolo', 'Paroni', 'cremona', '1972-01-03')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Paolo' AND cognome='Paroni' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'cremona')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Vanna', 'Paz', 'cremona', '1942-05-04')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Vanna' AND cognome='Paz' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'cremona')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Giorgio', 'Pecorari', 'cremona', '1982-07-10')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Giorgio' AND cognome='Pecorari' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'cremona')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Paola Andrea', 'Pennisi', 'cremona', '1987-10-12')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Paola Andrea' AND cognome='Pennisi' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'cremona')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Alberto', 'Persico', 'cremona', '1958-05-10')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Alberto' AND cognome='Persico' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'cremona')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Paolo', 'Piccioni', 'cremona', '1979-08-08')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Paolo' AND cognome='Piccioni' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'cremona')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Francesca', 'Poli', 'cremona', '1989-06-27')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Francesca' AND cognome='Poli' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'cremona')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Manuela', 'Porrino', 'cremona', '1982-11-25')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Manuela' AND cognome='Porrino' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'cremona')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Erica', 'Racchetti', 'cremona', '1982-07-29')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Erica' AND cognome='Racchetti' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'cremona')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Elisa', 'Racchetti', 'cremona', '1982-07-29')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Elisa' AND cognome='Racchetti' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'cremona')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Paolo Alfonso', 'Racchetti', 'cremona', '1978-09-04')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Paolo Alfonso' AND cognome='Racchetti' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'cremona')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Giancarla', 'Rebaglio', 'cremona', '1952-02-13')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Giancarla' AND cognome='Rebaglio' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'cremona')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Laura', 'Rossi', 'cremona', '1973-12-18')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Laura' AND cognome='Rossi' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'cremona')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Federica', 'Sala', 'cremona', '1979-09-16')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Federica' AND cognome='Sala' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'cremona')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Elisabetta', 'Salvadori', 'cremona', '1966-03-17')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Elisabetta' AND cognome='Salvadori' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'cremona')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Lorena', 'Sanguanini', 'cremona', '1955-10-30')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Lorena' AND cognome='Sanguanini' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'cremona')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
    IF tid IS NOT NULL THEN
      INSERT INTO tessere_sconti (tessera_id, data_utilizzo, valore_sconto)
      VALUES (tid, '2026-06-01', '€25');
    END IF;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Marta', 'Scaravaggi', 'cremona', '1989-01-19')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Marta' AND cognome='Scaravaggi' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'cremona')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
    IF tid IS NOT NULL THEN
      INSERT INTO tessere_sconti (tessera_id, data_utilizzo, valore_sconto)
      VALUES (tid, '2026-07-18', '€25');
    END IF;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Katharina', 'Schelling', 'cremona', '1951-07-05')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Katharina' AND cognome='Schelling' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'cremona')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Enrica', 'Scolari', 'cremona', '1974-01-21')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Enrica' AND cognome='Scolari' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'cremona')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Sara', 'Signorini', 'cremona', '1979-09-11')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Sara' AND cognome='Signorini' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'cremona')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Davide', 'Sora', 'cremona', '1964-01-07')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Davide' AND cognome='Sora' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'cremona')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Nicola', 'Spotti', 'cremona', '1978-01-07')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Nicola' AND cognome='Spotti' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'cremona')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Grazia', 'Tenca', 'cremona', '1949-08-17')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Grazia' AND cognome='Tenca' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'cremona')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Luisamma', 'Tinelli', 'cremona', '1951-07-08')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Luisamma' AND cognome='Tinelli' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'cremona')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Paolo', 'Ungari', 'cremona', '1991-01-15')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Paolo' AND cognome='Ungari' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'cremona')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Camilla', 'Vacchelli', 'cremona', '1988-12-06')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Camilla' AND cognome='Vacchelli' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'cremona')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Massimo', 'Vasarotti', 'cremona', '1964-03-14')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Massimo' AND cognome='Vasarotti' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'cremona')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Paola', 'Zambini', 'cremona', '1957-02-18')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Paola' AND cognome='Zambini' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'cremona')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Miriam Luigina Vanda', 'Zanghi', 'cremona', '1983-07-29')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Miriam Luigina Vanda' AND cognome='Zanghi' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'cremona')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Cristina', 'Zanoni', 'cremona', '1987-11-22')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Cristina' AND cognome='Zanoni' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'cremona')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Adriano', 'Zeni', 'cremona', '1949-03-06')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Adriano' AND cognome='Zeni' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'cremona')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Paolo', 'Zilliken', 'cremona', '1961-04-09')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Paolo' AND cognome='Zilliken' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'cremona')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Stefano', 'Zurpa', 'cremona', '1976-10-06')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Stefano' AND cognome='Zurpa' AND emporio='cremona' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'cremona')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Barbara', 'Araldi', 'casalmaggiore', '1968-07-07')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Barbara' AND cognome='Araldi' AND emporio='casalmaggiore' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'casalmaggiore')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Erica', 'Bossi', 'casalmaggiore', '1985-11-27')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Erica' AND cognome='Bossi' AND emporio='casalmaggiore' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'casalmaggiore')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Pierangela', 'Cattaneo', 'casalmaggiore', '1953-05-21')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Pierangela' AND cognome='Cattaneo' AND emporio='casalmaggiore' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'casalmaggiore')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Damiano', 'Chiarini', 'casalmaggiore', '1980-04-05')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Damiano' AND cognome='Chiarini' AND emporio='casalmaggiore' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'casalmaggiore')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Matilde', 'Chiarini', 'casalmaggiore', '1986-12-23')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Matilde' AND cognome='Chiarini' AND emporio='casalmaggiore' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'casalmaggiore')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Fabio', 'Chiesa', 'casalmaggiore', '1987-02-01')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Fabio' AND cognome='Chiesa' AND emporio='casalmaggiore' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'casalmaggiore')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Valentina', 'Ferrari', 'casalmaggiore', '1991-03-22')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Valentina' AND cognome='Ferrari' AND emporio='casalmaggiore' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'casalmaggiore')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Giulia', 'Frigeri', 'casalmaggiore', '1990-02-12')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Giulia' AND cognome='Frigeri' AND emporio='casalmaggiore' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'casalmaggiore')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Deborah', 'Frigeri', 'casalmaggiore', '1992-03-09')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Deborah' AND cognome='Frigeri' AND emporio='casalmaggiore' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'casalmaggiore')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Silvana', 'Galimberti', 'casalmaggiore', '1960-08-19')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Silvana' AND cognome='Galimberti' AND emporio='casalmaggiore' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'casalmaggiore')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Piero', 'Gatti', 'casalmaggiore', '2002-08-02')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Piero' AND cognome='Gatti' AND emporio='casalmaggiore' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'casalmaggiore')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Francesco', 'Lunardini', 'casalmaggiore', '1986-06-18')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Francesco' AND cognome='Lunardini' AND emporio='casalmaggiore' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'casalmaggiore')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Giuseppe', 'Lunardini', 'casalmaggiore', '1957-01-19')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Giuseppe' AND cognome='Lunardini' AND emporio='casalmaggiore' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'casalmaggiore')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Vittoria', 'Lunardini', 'casalmaggiore', '1999-08-24')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Vittoria' AND cognome='Lunardini' AND emporio='casalmaggiore' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'casalmaggiore')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Carla', 'Maffei', 'casalmaggiore', '1954-06-25')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Carla' AND cognome='Maffei' AND emporio='casalmaggiore' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'casalmaggiore')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Michele', 'Marchini', 'casalmaggiore', '1983-01-05')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Michele' AND cognome='Marchini' AND emporio='casalmaggiore' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'casalmaggiore')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Giuseppina', 'Pedrazzini', 'casalmaggiore', '1987-04-08')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Giuseppina' AND cognome='Pedrazzini' AND emporio='casalmaggiore' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'casalmaggiore')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Fabio', 'Perini', 'casalmaggiore', '1976-06-14')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Fabio' AND cognome='Perini' AND emporio='casalmaggiore' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'casalmaggiore')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Alessandra', 'Rivetti', 'casalmaggiore', '1958-02-12')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Alessandra' AND cognome='Rivetti' AND emporio='casalmaggiore' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'casalmaggiore')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Teresa', 'Rosa', 'casalmaggiore', '1949-07-30')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Teresa' AND cognome='Rosa' AND emporio='casalmaggiore' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'casalmaggiore')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Patrizia', 'Saporito', 'casalmaggiore', '1973-10-08')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Patrizia' AND cognome='Saporito' AND emporio='casalmaggiore' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'casalmaggiore')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Maria Marcella', 'Scaravonati', 'casalmaggiore', '1956-03-23')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Maria Marcella' AND cognome='Scaravonati' AND emporio='casalmaggiore' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'casalmaggiore')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Giuseppina', 'Amadini', 'viadana', '1958-11-28')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Giuseppina' AND cognome='Amadini' AND emporio='viadana' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'viadana')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Ave', 'Aroldi', 'viadana', '1950-05-08')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Ave' AND cognome='Aroldi' AND emporio='viadana' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'viadana')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Carla', 'Bellelli', 'viadana', '1951-08-29')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Carla' AND cognome='Bellelli' AND emporio='viadana' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'viadana')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Ottavia', 'Bondani', 'viadana', '1995-03-15')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Ottavia' AND cognome='Bondani' AND emporio='viadana' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'viadana')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Carla', 'Chittolini', 'viadana', '1952-12-16')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Carla' AND cognome='Chittolini' AND emporio='viadana' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'viadana')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Donatella', 'Falugi', 'viadana', '1950-12-24')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Donatella' AND cognome='Falugi' AND emporio='viadana' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'viadana')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Carla', 'Ferri', 'viadana', '1961-09-27')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Carla' AND cognome='Ferri' AND emporio='viadana' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'viadana')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Franco', 'Furlotti', 'viadana', '1976-08-18')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Franco' AND cognome='Furlotti' AND emporio='viadana' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'viadana')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Sara', 'Germani', 'viadana', '1982-07-07')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Sara' AND cognome='Germani' AND emporio='viadana' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'viadana')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Elena', 'Ghelfi', 'viadana', '1984-03-07')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Elena' AND cognome='Ghelfi' AND emporio='viadana' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'viadana')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Mirella', 'Panato', 'viadana', '1969-01-13')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Mirella' AND cognome='Panato' AND emporio='viadana' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'viadana')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Barbara', 'Piotrowskia', 'viadana', '1959-06-03')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Barbara' AND cognome='Piotrowskia' AND emporio='viadana' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'viadana')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Marta', 'Sanfelici', 'viadana', '1980-04-22')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Marta' AND cognome='Sanfelici' AND emporio='viadana' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'viadana')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Manuela', 'Scazza', 'viadana', '1960-05-27')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Manuela' AND cognome='Scazza' AND emporio='viadana' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'viadana')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;

DO $$ DECLARE cid BIGINT; tid UUID;
BEGIN
  INSERT INTO clienti (nome, cognome, emporio, data_nascita)
  VALUES ('Giulia', 'Zanoni', 'viadana', '1997-10-19')
  ON CONFLICT DO NOTHING RETURNING id INTO cid;
  IF cid IS NULL THEN
    SELECT id INTO cid FROM clienti WHERE nome='Giulia' AND cognome='Zanoni' AND emporio='viadana' LIMIT 1;
  END IF;
  IF cid IS NOT NULL THEN
    INSERT INTO tessere (cliente_id, tipo, emporio)
    VALUES (cid, 'ambassador', 'viadana')
    ON CONFLICT DO NOTHING RETURNING id INTO tid;
  END IF;
END $$;
