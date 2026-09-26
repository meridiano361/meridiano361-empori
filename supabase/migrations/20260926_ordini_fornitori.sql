-- Tabelle ordini a fornitori (campagne stagionali)
-- RLS: accesso pubblico (anon key), stesso pattern delle altre tabelle dell'app
CREATE TABLE IF NOT EXISTS preordini_campagne (
  id          bigserial PRIMARY KEY,
  nome        text      NOT NULL,
  anno        int       NOT NULL,
  stagione    text,
  scadenza    date,
  min_ordine  numeric,
  created_at  timestamptz DEFAULT now()
);

CREATE TABLE IF NOT EXISTS preordini_empori (
  id                     bigserial PRIMARY KEY,
  campagna_id            bigint REFERENCES preordini_campagne(id) ON DELETE CASCADE,
  codice                 text NOT NULL,
  nome                   text NOT NULL,
  ordine_visualizzazione int  DEFAULT 0,
  attivo                 boolean DEFAULT true,
  UNIQUE(campagna_id, codice)
);

CREATE TABLE IF NOT EXISTS preordini_righe (
  id           bigserial PRIMARY KEY,
  campagna_id  bigint REFERENCES preordini_campagne(id) ON DELETE CASCADE,
  fornitore    text,
  codice       text,
  categoria    text,
  prodotto     text NOT NULL,
  conf         int,
  pvp_corrente numeric,
  pvp_precedente numeric,
  ordine_riga  int DEFAULT 0,
  note         text
);

CREATE TABLE IF NOT EXISTS preordini_quantita (
  id                  bigserial PRIMARY KEY,
  riga_id             bigint REFERENCES preordini_righe(id) ON DELETE CASCADE,
  emporio_codice      text NOT NULL,
  venduto_corrente    numeric DEFAULT 0,
  ordine_corrente     numeric DEFAULT 0,
  venduto_precedente  numeric DEFAULT 0,
  ordine_precedente   numeric DEFAULT 0,
  UNIQUE(riga_id, emporio_codice)
);

-- Campagna Pasqua 2027
WITH camp AS (
  INSERT INTO preordini_campagne (nome, anno, stagione, scadenza, min_ordine)
  SELECT 'Pasqua 2027', 2027, 'Primavera 2027', '2026-10-07', 1000.00
  WHERE NOT EXISTS (
    SELECT 1 FROM preordini_campagne WHERE nome = 'Pasqua 2027' AND anno = 2027
  )
  RETURNING id
),
cid AS (
  SELECT id FROM camp
  UNION ALL
  SELECT id FROM preordini_campagne WHERE nome = 'Pasqua 2027' AND anno = 2027
  LIMIT 1
),
emp AS (
  INSERT INTO preordini_empori (campagna_id, codice, nome, ordine_visualizzazione, attivo)
  SELECT c.id, e.codice, e.nome, e.ord, true
  FROM (VALUES
    ('CR', 'Cremona',       0),
    ('CA', 'Casalmaggiore', 1),
    ('VI', 'Viadana',       2),
    ('RE', 'Reggio Emilia', 3),
    ('MN', 'Mantova',       4)
  ) AS e(codice, nome, ord)
  CROSS JOIN (SELECT id FROM cid LIMIT 1) AS c
  ON CONFLICT (campagna_id, codice) DO NOTHING
)
INSERT INTO preordini_righe (campagna_id, fornitore, codice, categoria, prodotto, conf, pvp_corrente, ordine_riga)
SELECT c.id, p.fornitore, p.codice, p.categoria, p.prodotto, p.conf, p.cess, p.ord
FROM (VALUES
  -- Uova di Pasqua
  ('Ombar','00000067','Uova di Pasqua','Uovo cioccolato al latte - 200g - Bio',    6, 9.43,  0),
  ('Ombar','00000068','Uova di Pasqua','Uovo cioccolato fondente - 200g - Bio',    6, 9.43,  1),
  ('Ombar','00008092','Uova di Pasqua','Uovo cioccolato bianco - 200g - Bio',      6, 9.43,  2),
  ('Ombar','00000069','Uova di Pasqua','Uovo cioccolato al latte - 270g - Bio',    6, 10.68, 3),
  ('Ombar','00000070','Uova di Pasqua','Uovo cioccolato fondente - 270g - Bio',    6, 10.68, 4),
  ('Ombar','00001207','Uova di Pasqua','GROW Uovo fondente fave - 350g - Bio',     4, 15.13, 5),
  ('Ombar','00006300','Uova di Pasqua','GROW Uovo gianduia granella nocciole - Bio',4,14.82, 6),
  ('Ombar','00008649','Uova di Pasqua','GROW Uovo al latte crispies quinoa - 350g [novità]',4,14.82,7),
  ('Ombar','00008675','Uova di Pasqua','Mini uovo al latte - 50g - Bio [novità]',  16, 2.78, 8),
  -- Dolci da forno
  ('Ombar','00000357','Dolci da forno','Colomba mandorle Palestina - 750g',        6, 10.99, 9),
  ('Ombar','00002371','Dolci da forno','Colomba cuor di cacao - 750g',             6, 14.86, 10),
  ('Ombar','00008094','Dolci da forno','Colomba cuor di pistacchio - 750g',        6, 14.86, 11),
  ('Ombar','00008095','Dolci da forno','Colomba con pesca e cioccolato - 750g',    6, 14.86, 12),
  ('Ombar','00008096','Dolci da forno','Colombina gocce cioccolato - 100g [new pack]',27,1.91,13),
  -- Ovetti
  ('Ombar','00001087','Ovetti','Ovetti confettati colorati - 170g',                14, 3.66, 14),
  ('Ombar','00002354','Ovetti','Ovetti ripieni alla nocciola - 170g',              14, 3.66, 15),
  ('Ombar','00008672','Ovetti','Ovetti al latte crema bianca quinoa - 170g [novità]',14,3.66,16)
) AS p(fornitore, codice, categoria, prodotto, conf, cess, ord)
CROSS JOIN (SELECT id FROM cid LIMIT 1) AS c
WHERE NOT EXISTS (
  SELECT 1 FROM preordini_righe pr
  JOIN preordini_campagne pc ON pc.id = pr.campagna_id
  WHERE pc.nome = 'Pasqua 2027' AND pc.anno = 2027 AND pr.codice = p.codice
);

-- RLS policies
CREATE POLICY IF NOT EXISTS preordini_campagne_all ON preordini_campagne FOR ALL TO public USING (true) WITH CHECK (true);
CREATE POLICY IF NOT EXISTS preordini_empori_all   ON preordini_empori   FOR ALL TO public USING (true) WITH CHECK (true);
CREATE POLICY IF NOT EXISTS preordini_righe_all    ON preordini_righe    FOR ALL TO public USING (true) WITH CHECK (true);
CREATE POLICY IF NOT EXISTS preordini_quantita_all ON preordini_quantita FOR ALL TO public USING (true) WITH CHECK (true);
