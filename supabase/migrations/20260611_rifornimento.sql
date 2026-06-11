-- ═══════════════════════════════════════════════════════════════
-- RIFORNIMENTO — schema + catalogo iniziale da Excel
-- ═══════════════════════════════════════════════════════════════

-- ── 1. CATALOGO PRODOTTI ────────────────────────────────────────
CREATE TABLE IF NOT EXISTS rifornimento_catalogo (
  id                      BIGSERIAL PRIMARY KEY,
  source_sheet            TEXT NOT NULL DEFAULT '',          -- ALI AM / ALI LT / ALI VR / ALI VA
  category                TEXT NOT NULL DEFAULT '',          -- es. BEVANDE ALCOLICHE
  product_code            TEXT NOT NULL,
  description             TEXT NOT NULL,
  pvp                     NUMERIC(10,2),
  pack_size               NUMERIC(8,0),
  assortment_cremona      BOOLEAN,                           -- true=SI, false=NO, null=NAT/EST/vuoto
  assortment_casalmaggiore BOOLEAN,
  assortment_viadana      BOOLEAN,
  sort_order              INT NOT NULL DEFAULT 0,
  active                  BOOLEAN NOT NULL DEFAULT true,
  created_at              TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE UNIQUE INDEX IF NOT EXISTS rifornimento_catalogo_code_sheet_uidx
  ON rifornimento_catalogo(product_code, source_sheet);

ALTER TABLE rifornimento_catalogo ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS rifornimento_catalogo_read   ON rifornimento_catalogo;
DROP POLICY IF EXISTS rifornimento_catalogo_manage ON rifornimento_catalogo;

CREATE POLICY rifornimento_catalogo_read ON rifornimento_catalogo
  FOR SELECT USING (true);

CREATE POLICY rifornimento_catalogo_manage ON rifornimento_catalogo
  FOR ALL USING (true);

-- ── 2. PROPOSTE ─────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS rifornimento_proposte (
  id           BIGSERIAL PRIMARY KEY,
  emporio      TEXT NOT NULL,                                -- Casalmaggiore | Viadana
  status       TEXT NOT NULL DEFAULT 'bozza',               -- bozza | inviata | letta | archiviata
  created_by   TEXT NOT NULL DEFAULT '',                     -- nome operatore
  created_at   TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at   TIMESTAMPTZ NOT NULL DEFAULT now(),
  submitted_at TIMESTAMPTZ,
  note         TEXT NOT NULL DEFAULT ''
);

ALTER TABLE rifornimento_proposte ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS rifornimento_proposte_read_own   ON rifornimento_proposte;
DROP POLICY IF EXISTS rifornimento_proposte_write_own  ON rifornimento_proposte;
DROP POLICY IF EXISTS rifornimento_proposte_read_admin ON rifornimento_proposte;

-- anon legge tutto (la logica di visibilità è nel frontend con auth.js)
CREATE POLICY rifornimento_proposte_read_admin ON rifornimento_proposte
  FOR SELECT USING (true);

CREATE POLICY rifornimento_proposte_write_own ON rifornimento_proposte
  FOR ALL USING (true);

-- ── 3. RIGHE PROPOSTA ────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS rifornimento_proposte_righe (
  id                  BIGSERIAL PRIMARY KEY,
  proposal_id         BIGINT NOT NULL REFERENCES rifornimento_proposte(id) ON DELETE CASCADE,
  catalog_product_id  BIGINT REFERENCES rifornimento_catalogo(id) ON DELETE SET NULL,
  product_code        TEXT NOT NULL DEFAULT '',              -- denormalizzato per praticità
  description         TEXT NOT NULL DEFAULT '',
  quantity            NUMERIC(10,0) NOT NULL DEFAULT 0,
  notes               TEXT NOT NULL DEFAULT '',
  created_at          TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE UNIQUE INDEX IF NOT EXISTS rifornimento_proposte_righe_uidx
  ON rifornimento_proposte_righe(proposal_id, product_code);

ALTER TABLE rifornimento_proposte_righe ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS rifornimento_proposte_righe_read  ON rifornimento_proposte_righe;
DROP POLICY IF EXISTS rifornimento_proposte_righe_write ON rifornimento_proposte_righe;

CREATE POLICY rifornimento_proposte_righe_read ON rifornimento_proposte_righe
  FOR SELECT USING (true);

CREATE POLICY rifornimento_proposte_righe_write ON rifornimento_proposte_righe
  FOR ALL USING (true);

-- ── 4. IMPORT CATALOGO DA EXCEL ─────────────────────────────────
-- 286 prodotti (ALI AM 266, ALI LT 9, ALI VR 3, ALI VA 8)
-- Duplicati gestiti: 109 (dup esatto rimosso), 168→168a/168b, 959→959a/959b
-- Codici NAT/EST = assortimento stagionale/estivo → null
-- Righe vuote e intestazioni scartate (33 righe)

INSERT INTO rifornimento_catalogo
  (source_sheet, category, product_code, description, pvp, pack_size,
   assortment_cremona, assortment_casalmaggiore, assortment_viadana, sort_order, active)
VALUES
  ('ALI AM','BEVANDE ALCOLICHE','851','PROSECCO QUORUM DOCG',12.5,6,true,true,true,1,true),
  ('ALI AM','BEVANDE ALCOLICHE','852','MOSCATO FIORI D''ARANCIO DOCG',11,6,null,null,null,2,true),
  ('ALI AM','BEVANDE ALCOLICHE','1061','VINO GIATO BIANCO DOC',9.5,6,true,true,true,3,true),
  ('ALI AM','BEVANDE ALCOLICHE','1062','VINO GIATO ROSSO DOC',9.5,6,true,true,true,4,true),
  ('ALI AM','BEVANDE ALCOLICHE','1153','PROSECCO GENESIS DOCG',12.5,6,null,null,null,5,true),
  ('ALI AM','BEVANDE ALCOLICHE','3918','LIMONCELLO DI SICILIA',15,6,true,true,true,6,true),
  ('ALI AM','BEVANDE ANALCOLICHE E SCIROPPI','49','SUCCO FRUTTI ROSSI DI SICILIA',4,6,true,true,true,7,true),
  ('ALI AM','BEVANDE ANALCOLICHE E SCIROPPI','668','NETTARE MIRTILLI 200 ml',2.5,12,true,true,true,8,true),
  ('ALI AM','BEVANDE ANALCOLICHE E SCIROPPI','121','SCIROPPO AL GUARANA''',5,6,null,null,null,9,true),
  ('ALI AM','BEVANDE ANALCOLICHE E SCIROPPI','168a','GUARANITO',1.5,24,null,null,null,10,true),
  ('ALI AM','BEVANDE ANALCOLICHE E SCIROPPI','528','SCIROPPO ALLA MENTA',5,6,null,null,null,11,true),
  ('ALI AM','BEVANDE ANALCOLICHE E SCIROPPI','970','NETTARE FRUTTI BOSCO 200 ml',2.5,12,true,true,true,12,true),
  ('ALI AM','BEVANDE ANALCOLICHE E SCIROPPI','968','NETTARE MIRTILLI 500 ml',5.5,12,true,true,true,13,true),
  ('ALI AM','BEVANDE ANALCOLICHE E SCIROPPI','969','NETTARE FRUTTI BOSCO 500 ml',5.5,12,true,true,true,14,true),
  ('ALI AM','BEVANDE ANALCOLICHE E SCIROPPI','347','GUARANITO LATTINA',0.8,24,true,true,true,15,true),
  ('ALI AM','BEVANDE ANALCOLICHE E SCIROPPI','1092','TEA BREAK TÈ VERDE MATE',2,6,false,true,true,16,true),
  ('ALI AM','BEVANDE ANALCOLICHE E SCIROPPI','1093','TEA BREAK ROOIBOS LIME',2,6,false,true,true,17,true),
  ('ALI AM','BEVANDE ANALCOLICHE E SCIROPPI','365','TERERITO BOTTIGLIETTA',1,24,true,true,true,18,true),
  ('ALI AM','BEVANDE ANALCOLICHE E SCIROPPI','168b','GUARANITO BOTTIGLIETTA',1,24,true,true,true,19,true),
  ('ALI AM','BEVANDE ANALCOLICHE E SCIROPPI','1126','MOLECOLA',2,12,true,true,true,20,true),
  ('ALI AM','BEVANDE ANALCOLICHE E SCIROPPI','1147','GUARANITO BOTTIGLIA',2,6,true,true,true,21,true),
  ('ALI AM','BEVANDE ANALCOLICHE E SCIROPPI','1148','GINGERITO BOTTIGLIA',2,6,true,true,true,22,true),
  ('ALI AM','BEVANDE CALDE - CAFFE''','203','BIOCAFFÈ LATTINA 100% ARAB.',8,12,null,null,null,23,true),
  ('ALI AM','BEVANDE CALDE - CAFFE''','382','CAFFÈ ETIOPIA 100% ARABICA',8.5,12,true,true,true,24,true),
  ('ALI AM','BEVANDE CALDE - CAFFE''','383','CAFFÈ NICARAGUA 100% ARABiCA',8.5,12,true,true,true,25,true),
  ('ALI AM','BEVANDE CALDE - CAFFE''','384','CAFFÈ MESSICO 100% ARABICA',8.5,12,true,true,true,26,true),
  ('ALI AM','BEVANDE CALDE - CAFFE''','385','BIOCAFFÈ 100% ARABICA',7,12,true,true,true,27,true),
  ('ALI AM','BEVANDE CALDE - CAFFE''','390','BIOCAFFÈ 100% ARAB.GRANI',15,12,true,false,false,28,true),
  ('ALI AM','BEVANDE CALDE - CAFFE''','555','TRIS CAFFÈ MISCELE',12,3,true,true,true,29,true),
  ('ALI AM','BEVANDE CALDE - CAFFE''','867','TRIS MONORIG. BIO 100% ARAB.',15,3,true,true,true,30,true),
  ('ALI AM','BEVANDE CALDE - CAFFE''','437','BIODEKA 100% ARABICA',8,16,true,true,true,31,true),
  ('ALI AM','BEVANDE CALDE - CAFFE''','378','CAFFÈ MISCELA INTENSA',3.3,16,true,true,true,32,true),
  ('ALI AM','BEVANDE CALDE - CAFFE''','379','CAFFÈ MISCELA CLASSICA',3.7,16,true,true,true,33,true),
  ('ALI AM','BEVANDE CALDE - CAFFE''','380','CAFFÈ MISCELA ESPRESSO',3.8,16,true,true,true,34,true),
  ('ALI AM','BEVANDE CALDE - CAFFE''','381','CAFFÈ MISCELA PREGIATA',4,16,true,true,true,35,true),
  ('ALI AM','BEVANDE CALDE - CAFFE''','549','CAFFÈ TANZANIA SOLUBILE',8,12,true,true,true,36,true),
  ('ALI AM','BEVANDE CALDE - CAFFE''','935','CAFFÈ MISC. INTENSA BIPACK',10.5,8,true,true,true,37,true),
  ('ALI AM','BEVANDE CALDE - CAFFE''','936','CAFFÈ MISC. CLASSICA BIPACK',11,8,true,true,true,38,true),
  ('ALI AM','BEVANDE CALDE - CAFFE''','937','CAFFÈ MISC. PREGIATA BIPACK',11.5,8,true,true,true,39,true),
  ('ALI AM','BEVANDE CALDE - CAFFE''','1106','CAPSULE CAFFÉ ESPRESSO',4.5,12,true,true,true,40,true),
  ('ALI AM','BEVANDE CALDE - CAFFE''','1107','CAPSULE BIOCAFFÉ 100% ARAB.',4,12,true,true,true,41,true),
  ('ALI AM','BEVANDE CALDE - CAFFE''','1260','CAFFÈ MANIFESTO',7,12,true,true,true,42,true),
  ('ALI AM','BEVANDE CALDE - CAFFE''','7920','CAFFÈ GINSENG',7,12,true,true,true,43,true),
  ('ALI AM','BEVANDE CALDE - ORZO','171','ORZO TOSTATO MACINATO',3,12,true,true,true,44,true),
  ('ALI AM','BEVANDE CALDE - ORZO','172','ORZO SOLUBILE',2.5,6,true,true,true,45,true),
  ('ALI AM','BEVANDE CALDE - TE''','308','TÈ VERDE DETEINATO 20 F.',4,12,false,false,true,46,true),
  ('ALI AM','BEVANDE CALDE - TE''','386','TÈ VERDE MENTA 20 F.',4,10,true,true,true,47,true),
  ('ALI AM','BEVANDE CALDE - TE''','474','TÈ NERO 50 F.',6,6,true,true,true,48,true),
  ('ALI AM','BEVANDE CALDE - TE''','475','TÈ VERDE 50 F.',6,6,true,true,true,49,true),
  ('ALI AM','BEVANDE CALDE - TE''','478','TÈ NERO MANGO VANIGLIA 20F.',4,10,true,true,true,50,true),
  ('ALI AM','BEVANDE CALDE - TE''','479','TÈ NERO FRUTTI DI BOSCO 20 F.',4,10,true,true,true,51,true),
  ('ALI AM','BEVANDE CALDE - TE''','480','TÈ NERO ARANCIO SPEZIE 20 F.',4,10,true,true,true,52,true),
  ('ALI AM','BEVANDE CALDE - TE''','575','TÈ AROM. IN COFANETTO 40F.',12,4,null,null,null,53,true),
  ('ALI AM','BEVANDE CALDE - TE''','868','TÈ NERO DARJEELING 20 F.',4.4,8,true,true,true,54,true),
  ('ALI AM','BEVANDE CALDE - TE''','869','TÈ VERDE DARJEELING 20 F.',4.4,8,true,true,true,55,true),
  ('ALI AM','BEVANDE CALDE - TE''','802','TÈ NERO FOGLIE CESTINO',4,10,true,true,true,56,true),
  ('ALI AM','BEVANDE CALDE - TE''','803','TÈ VERDE FOGLIE CESTINO',3.5,10,true,true,true,57,true),
  ('ALI AM','BEVANDE CALDE - TE''','804','TÈ NERO BOPF 25 F.',4,10,true,true,true,58,true),
  ('ALI AM','BEVANDE CALDE - TE''','805','TÈ NERO EARL GREY 25 F.',4,10,true,true,true,59,true),
  ('ALI AM','BEVANDE CALDE - TE''','806','TÈ VERDE GREEN FANNINGS 25 F.',4,10,true,true,true,60,true),
  ('ALI AM','BEVANDE CALDE - TE''','807','TÈ NERO LEMON HONEY 25 F.',4,10,true,true,true,61,true),
  ('ALI AM','BEVANDE CALDE - TE''','810','TÈ VERDE GELSOMINO 25 F.',4,10,true,true,true,62,true),
  ('ALI AM','BEVANDE CALDE - TE''','870','TÈ BIANCO DARJEELING 20 F.',4.5,8,true,true,true,63,true),
  ('ALI AM','BEVANDE CALDE - TE''','1011','TÉ VERDE LIMONE ZENZERO 20 F.',4,10,true,true,true,64,true),
  ('ALI AM','BEVANDE CALDE - TE''','1012','TÈ NERO EARL GREY 20F.',2.8,10,true,true,true,65,true),
  ('ALI AM','BEVANDE CALDE - TE''','1013','TÉ VERDE GELSOMINO 20 F.',2.8,10,true,true,true,66,true),
  ('ALI AM','BEVANDE CALDE - TE''','1099','TÈ AROMATIZZATI LATTA 60 F.',18,4,null,null,null,67,true),
  ('ALI AM','BEVANDE CALDE - TE''','5954','TÈ PIRAMIDALI',25,4,null,false,false,68,true),
  ('ALI AM','BEVANDE CALDE - TE''','6678','TÈ BIANCO FILTRI',4,12,true,true,true,69,true),
  ('ALI AM','BEVANDE CALDE - INFUSI E TISANE','1048','T-SANA TAZZA E TISANE',24,1,null,null,null,70,true),
  ('ALI AM','BEVANDE CALDE - INFUSI E TISANE','109a','CARCADÉ FILTRI',3.5,12,true,true,true,71,true),
  ('ALI AM','BEVANDE CALDE - INFUSI E TISANE','188','INFUSO DI ANANAS 20 F.',3.5,10,true,true,true,73,true),
  ('ALI AM','BEVANDE CALDE - INFUSI E TISANE','219','ERBA MATE FOGLIE',4,7,true,true,true,74,true),
  ('ALI AM','BEVANDE CALDE - INFUSI E TISANE','491','CAMOMILLA 20 F.',3.5,12,true,true,true,75,true),
  ('ALI AM','BEVANDE CALDE - INFUSI E TISANE','687','INFUSO MELA CANNELLA 20F.',3.5,10,true,true,true,76,true),
  ('ALI AM','BEVANDE CALDE - INFUSI E TISANE','690','TISANA BENESSERE 20 F.',3.5,10,true,true,true,77,true),
  ('ALI AM','BEVANDE CALDE - INFUSI E TISANE','695','TISANA RESPIRO 20 F.',3.5,6,true,true,true,78,true),
  ('ALI AM','BEVANDE CALDE - INFUSI E TISANE','698','TISANA CUORE 20 F.',3.5,6,true,true,true,79,true),
  ('ALI AM','BEVANDE CALDE - INFUSI E TISANE','738','TISANA EQUILIBRIO 20 F.',3.5,10,true,true,true,80,true),
  ('ALI AM','BEVANDE CALDE - INFUSI E TISANE','779','TISANA RELAX 20 F.',3.5,6,true,true,true,81,true),
  ('ALI AM','BEVANDE CALDE - INFUSI E TISANE','922','INFUSO FRUTTI BOSCO 20 F.',3.5,6,true,true,true,82,true),
  ('ALI AM','BEVANDE CALDE - INFUSI E TISANE','1054','INFUSO ROOIBOS 20 F.',3.5,12,true,true,true,83,true),
  ('ALI AM','BEVANDE CALDE - INFUSI E TISANE','1056','PAUSA RELAX',8,3,true,true,true,84,true),
  ('ALI AM','BEVANDE CALDE - INFUSI E TISANE','5956','TISANA ARMONIA',3.5,6,true,true,true,85,true),
  ('ALI AM','BEVANDE CALDE - INFUSI E TISANE','7239','TRATTAMENTO 28 GIORNI',7,5,true,true,true,86,true),
  ('ALI AM','BEVANDE CALDE - INFUSI E TISANE','3458','CHOKO CACAO',3.5,10,true,true,true,87,true),
  ('ALI AM','BEVANDE CALDE - INFUSI E TISANE','3459','CHOKO CACAO E ZENZERO',3.5,10,true,true,true,88,true),
  ('ALI AM','BEVANDE CALDE - INFUSI E TISANE','3460','CHOKO FRUTTI DI BOSCO',3.5,10,true,true,true,89,true),
  ('ALI AM','BEVANDE CALDE - BASE CACAO','126','EQUIK CACAO SOLUBILE',4.5,12,true,true,true,90,true),
  ('ALI AM','BEVANDE CALDE - BASE CACAO','338','CHOKOLA',3,8,true,true,true,91,true),
  ('ALI AM','BEVANDE CALDE - BASE CACAO','3396','CHOKOLA DARK',3,8,true,true,true,92,true),
  ('ALI AM','FRUTTA E VEGETALI CONFEZIONATI - SOTTOLI','808','FRIARIELLI SOTT''OLIO',5.2,12,true,true,true,93,true),
  ('ALI AM','FRUTTA E VEGETALI CONFEZIONATI - SOTTOLI','801','MELANZANE SOTT''OLIO',5.2,12,false,false,false,94,true),
  ('ALI AM','FRUTTA E VEGETALI CONFEZIONATI - SOTTOLI','1112','OLIVE NERE BELLE CERIGNOLA',6.9,6,false,false,false,95,true),
  ('ALI AM','FRUTTA E VEGETALI CONFEZIONATI - SOTTOLI','581','OLIVE VERDI BELLE CERIGNOLA',6.9,6,false,false,false,96,true),
  ('ALI AM','FRUTTA E VEGETALI CONFEZIONATI - SOTTOLI','963','CAPONATA DI MELANZANE',5.5,6,true,true,true,97,true),
  ('ALI AM','FRUTTA E VEGETALI CONFEZIONATI - SOTTOLI','1142','CARCIOFI SOTT''OLIO',7,12,true,true,true,98,true),
  ('ALI AM','FRUTTA E VEGETALI CONFEZIONATI - SOTTOLI','1162','PATÉ DI CARCIOFI',4.5,12,true,true,true,99,true),
  ('ALI AM','FRUTTA E VEGETALI CONFEZIONATI - FRUTTA CONFEZIONATA','167','MIX FRUTTA SECCA',3,14,true,true,true,100,true),
  ('ALI AM','FRUTTA E VEGETALI CONFEZIONATI - FRUTTA CONFEZIONATA','345','ZEN-ZÌ',3,12,true,true,true,101,true),
  ('ALI AM','FRUTTA E VEGETALI CONFEZIONATI - FRUTTA CONFEZIONATA','374','ANACARDI TOSTATI E SALATI',2.5,14,true,true,true,102,true),
  ('ALI AM','FRUTTA E VEGETALI CONFEZIONATI - FRUTTA CONFEZIONATA','403','ANANAS A FETTE IN SUCCO',3.5,12,true,true,true,103,true),
  ('ALI AM','FRUTTA E VEGETALI CONFEZIONATI - FRUTTA CONFEZIONATA','406','ARACHIDI TOSTATE  E SALATE',2.5,12,true,true,true,104,true),
  ('ALI AM','FRUTTA E VEGETALI CONFEZIONATI - FRUTTA CONFEZIONATA','569','MANDORLE TOSTATE',4.5,12,true,true,true,105,true),
  ('ALI AM','FRUTTA E VEGETALI CONFEZIONATI - FRUTTA CONFEZIONATA','570','MANDORLE TOSTATE SALATE',4.5,12,true,true,true,106,true),
  ('ALI AM','FRUTTA E VEGETALI CONFEZIONATI - FRUTTA CONFEZIONATA','877','SEMI DI CHIA',4.5,12,true,true,true,107,true),
  ('ALI AM','FRUTTA E VEGETALI CONFEZIONATI - FRUTTA CONFEZIONATA','908','ANACARDI AL NATURALE',5,12,true,true,true,108,true),
  ('ALI AM','FRUTTA E VEGETALI CONFEZIONATI - FRUTTA CONFEZIONATA','933','NOCI DELL''AMAZZONIA',5,12,true,true,true,109,true),
  ('ALI AM','FRUTTA E VEGETALI CONFEZIONATI - FRUTTA CONFEZIONATA','1022','ZENZERO CANDITO',4,10,true,true,true,110,true),
  ('ALI AM','FRUTTA E VEGETALI CONFEZIONATI - FRUTTA CONFEZIONATA','1029','MANDORLE PELATE',4.5,12,true,true,true,111,true),
  ('ALI AM','FRUTTA E VEGETALI CONFEZIONATI - FRUTTA CONFEZIONATA','1032','UVETTA PASSA ESSICCATA',4,12,true,true,true,112,true),
  ('ALI AM','FRUTTA E VEGETALI CONFEZIONATI - FRUTTA CONFEZIONATA','1072','LATTE DI COCCO',4.5,12,true,true,true,113,true),
  ('ALI AM','FRUTTA E VEGETALI CONFEZIONATI - FRUTTA CONFEZIONATA','1086','MIX DI SEMI E ANACARDI',4,12,true,true,true,114,true),
  ('ALI AM','FRUTTA E VEGETALI CONFEZIONATI - FRUTTA CONFEZIONATA','1216','DATTERI MEDJOUL BIO',6.5,18,true,true,true,115,true),
  ('ALI AM','FRUTTA E VEGETALI CONFEZIONATI - LEGUMI','199','CECI LESSATI',2,12,true,true,true,116,true),
  ('ALI AM','FRUTTA E VEGETALI CONFEZIONATI - LEGUMI','630','LENTICCHIE ESSICCATE',4,12,true,true,true,117,true),
  ('ALI AM','FRUTTA E VEGETALI CONFEZIONATI - LEGUMI','1050','ZUPPA DI LENTICCHIE',3,12,true,true,true,118,true),
  ('ALI AM','FRUTTA E VEGETALI CONFEZIONATI - LEGUMI','1113','CECI SECCHI',3,6,true,true,true,119,true),
  ('ALI AM','FRUTTA E VEGETALI CONFEZIONATI - LEGUMI','1191','ZUPPA DI CICERCHIE FRIARIELLI',5.5,12,false,false,true,120,true),
  ('ALI AM','FRUTTA E VEGETALI CONFEZIONATI - LEGUMI','5383','HUMMUS DI CECI',4,12,true,true,true,121,true),
  ('ALI AM','FUORI PASTO DOLCI -  SNACK','265','BARRETTA COCCO SNACTION',1.5,24,true,true,true,122,true),
  ('ALI AM','FUORI PASTO DOLCI -  SNACK','348','PEQUENA',1,45,false,true,true,123,true),
  ('ALI AM','FUORI PASTO DOLCI -  SNACK','481','BARRITA NUT',1.5,30,false,true,true,124,true),
  ('ALI AM','FUORI PASTO DOLCI -  SNACK','578','BARRETTA MIRTILLI SNACTION',1.5,24,true,true,true,125,true),
  ('ALI AM','FUORI PASTO DOLCI -  SNACK','4294','FROLLA COCCO SNACTION',3.5,10,true,true,true,126,true),
  ('ALI AM','FUORI PASTO DOLCI -  SNACK','4295','FROLLA NOCCIOLE SNACTION',3.5,10,true,true,true,127,true),
  ('ALI AM','FUORI PASTO DOLCI - TAVOLETTE E BARRETTE','286','MASCAO EXTRA FONDENTE 85% - 100 g',3.5,22,true,true,true,128,true),
  ('ALI AM','FUORI PASTO DOLCI - TAVOLETTE E BARRETTE','367','NOCCIOLATO GIANDUIA',4,20,null,null,null,129,true),
  ('ALI AM','FUORI PASTO DOLCI - TAVOLETTE E BARRETTE','456','MASCAO FONDENTE MENTA',3.5,22,true,true,true,130,true),
  ('ALI AM','FUORI PASTO DOLCI - TAVOLETTE E BARRETTE','457','MASCAO FONDENTE RISO QUINOA',3,18,true,true,true,131,true),
  ('ALI AM','FUORI PASTO DOLCI - TAVOLETTE E BARRETTE','458','MASCAO FONDENTE ARANCIA',3,22,true,true,true,132,true),
  ('ALI AM','FUORI PASTO DOLCI - TAVOLETTE E BARRETTE','879','MASCAO LATTE DI COCCO',3.5,22,true,true,true,133,true),
  ('ALI AM','FUORI PASTO DOLCI - TAVOLETTE E BARRETTE','880','MASCAO FONDENTE MELOGRANO',3.5,22,true,true,true,134,true),
  ('ALI AM','FUORI PASTO DOLCI - TAVOLETTE E BARRETTE','1058','MASCAO LIMONE E ZENZERO - 100 g',3.5,22,true,true,true,135,true),
  ('ALI AM','FUORI PASTO DOLCI - TAVOLETTE E BARRETTE','1059','MASCAO LATTE CARAMELLO SALE - 100 g',3.5,22,true,true,true,136,true),
  ('ALI AM','FUORI PASTO DOLCI - TAVOLETTE E BARRETTE','1098','MASCAO CAFFÈ ARABICA',3.5,22,true,true,true,137,true),
  ('ALI AM','FUORI PASTO DOLCI - TAVOLETTE E BARRETTE','1166','MASCAO FONDENTE NOCCIOLE',3.5,18,false,true,false,138,true),
  ('ALI AM','FUORI PASTO DOLCI - TAVOLETTE E BARRETTE','1274','NOCCIOLATO FONDENTE',4,20,null,null,null,139,true),
  ('ALI AM','FUORI PASTO DOLCI - TAVOLETTE E BARRETTE','5062','MASCAO LATTE MANDORLE SALE',3.5,22,true,true,true,140,true),
  ('ALI AM','FUORI PASTO DOLCI - TAVOLETTE E BARRETTE','5406','MASCAO LATTE CARAMELLO SALE',3.5,22,true,true,true,141,true),
  ('ALI AM','FUORI PASTO DOLCI - TAVOLETTE E BARRETTE','5407','MASCAO FONDENTE ZENZERO LIMONE',3,22,true,true,true,142,true),
  ('ALI AM','FUORI PASTO DOLCI - TAVOLETTE E BARRETTE','5408','MASCAO FONDENTE FAVE',3,22,true,true,true,143,true),
  ('ALI AM','FUORI PASTO DOLCI - TAVOLETTE E BARRETTE','5409','MASCAO FONDENTE 85 %',3,22,true,true,true,144,true),
  ('ALI AM','FUORI PASTO DOLCI - TAVOLETTE E BARRETTE','5410','MASCAO FONDENTE 70 %',3,22,true,true,true,145,true),
  ('ALI AM','FUORI PASTO DOLCI - TAVOLETTE E BARRETTE','7592','MASCAO AL LATTE',3,22,true,true,true,146,true),
  ('ALI AM','FUORI PASTO DOLCI - CIOCCOLATINI E PRALINE','22','CIKI CRISPIES',3.5,12,true,true,true,147,true),
  ('ALI AM','FUORI PASTO DOLCI - CIOCCOLATINI E PRALINE','29','CIKI CAFFE''',3.5,12,true,true,true,148,true),
  ('ALI AM','FUORI PASTO DOLCI - CIOCCOLATINI E PRALINE','36','CIKI UVETTA',3.5,12,true,true,true,149,true),
  ('ALI AM','FUORI PASTO DOLCI - CIOCCOLATINI E PRALINE','176','NOUSSINE',8,6,false,false,false,150,true),
  ('ALI AM','FUORI PASTO DOLCI - CIOCCOLATINI E PRALINE','1125','TRÉS AMÌ',4.5,10,null,null,null,151,true),
  ('ALI AM','FUORI PASTO DOLCI - CIOCCOLATINI E PRALINE','371','MANÌ',2,30,null,null,null,152,true),
  ('ALI AM','FUORI PASTO DOLCI - CIOCCOLATINI E PRALINE','940','TARTUFI FONDENTI ANACARDI',7.5,14,null,null,null,153,true),
  ('ALI AM','FUORI PASTO DOLCI - CIOCCOLATINI E PRALINE','1273','NOCCIOLATINI',13.5,6,null,null,null,154,true),
  ('ALI AM','FUORI PASTO DOLCI - CIOCCOLATINI E PRALINE','5272','NOCCIOLATINI CRISP 250 g',13.5,6,null,null,null,155,true),
  ('ALI AM','FUORI PASTO DOLCI - CIOCCOLATINI E PRALINE','5074','CREMINI',13.5,6,null,null,null,156,true),
  ('ALI AM','FUORI PASTO DOLCI - CIOCCOLATINI E PRALINE','5075','NOCCIOLATINI 120 g',5.5,10,null,null,null,157,true),
  ('ALI AM','FUORI PASTO DOLCI - CIOCCOLATINI E PRALINE','5083','EXPERIENCE',20,6,null,null,null,158,true),
  ('ALI AM','INGREDIENTI DI BASE - ZUCCHERO DI CANNA','72','DULCITA 1 KG',5,10,true,true,true,159,true),
  ('ALI AM','INGREDIENTI DI BASE - ZUCCHERO DI CANNA','73','DULCITA 500 GR',2.6,20,true,true,true,160,true),
  ('ALI AM','INGREDIENTI DI BASE - ZUCCHERO DI CANNA','156','MASCOBADO 500 GR',4.8,10,true,true,true,161,true),
  ('ALI AM','INGREDIENTI DI BASE - ZUCCHERO DI CANNA','157','MASCOBADO 1 KG',5.5,10,true,true,true,162,true),
  ('ALI AM','INGREDIENTI DI BASE - ZUCCHERO DI CANNA','331','PICAFLOR 500 G',3,20,true,true,true,163,true),
  ('ALI AM','INGREDIENTI DI BASE - ZUCCHERO DI CANNA','525','DEMERARA 500 G',2,12,true,true,true,164,true),
  ('ALI AM','INGREDIENTI DI BASE - ZUCCHERO DI CANNA','1196','FIOR DI COCCO 250 G.',3.5,15,true,true,true,165,true),
  ('ALI AM','INGREDIENTI DI BASE - ZUCCHERO DI CANNA','2946','MELASSA NERA',3.5,12,true,true,true,166,true),
  ('ALI AM','INGREDIENTI DI BASE - PREPARATI PER DOLCI E CACAO IN POLVERE','51','CACAO MAGRO EL CEIBO',2.9,10,false,false,false,167,true),
  ('ALI AM','INGREDIENTI DI BASE - PREPARATI PER DOLCI E CACAO IN POLVERE','285','BLOCCO CIOCCOLATO FONDENTE',4.5,15,true,true,true,168,true),
  ('ALI AM','INGREDIENTI DI BASE - PREPARATI PER DOLCI E CACAO IN POLVERE','399','CACAO AMARO CONACADO',2.5,15,true,true,true,169,true),
  ('ALI AM','INGREDIENTI DI BASE - PREPARATI PER DOLCI E CACAO IN POLVERE','416','BUDINO ALLA VANIGLIA',3,8,true,true,true,170,true),
  ('ALI AM','INGREDIENTI DI BASE - PREPARATI PER DOLCI E CACAO IN POLVERE','417','BUDINO AL CACAO',3,8,true,true,true,171,true),
  ('ALI AM','INGREDIENTI DI BASE - PREPARATI PER DOLCI E CACAO IN POLVERE','667','COCCO GRATTUGIATO',4,12,true,true,true,172,true),
  ('ALI AM','INGREDIENTI DI BASE - FARINA','751','FARINA DI CECI',4,6,true,true,true,173,true),
  ('ALI AM','PASTA','7','SPAGHETTI SPEZZATI QUINOA',1.5,12,true,true,true,174,true),
  ('ALI AM','PASTA','539','SPAGHETTI LIBERA',2,12,true,true,true,175,true),
  ('ALI AM','PASTA','540','FUSILLI LIBERA',2,12,true,true,true,176,true),
  ('ALI AM','PASTA','7599','CASERECCE LIBERA',2,10,true,true,true,177,true),
  ('ALI AM','PASTA','1172','LINGUINE',2,12,true,true,true,178,true),
  ('ALI AM','PASTA','1173','SPAGHETTI INTEGRALI',2,12,true,true,true,179,true),
  ('ALI AM','PASTA','1174','PENNE INTEGRALI',2,12,true,true,true,180,true),
  ('ALI AM','PASTA','1175','FUSILLI INTEGRALI',2,12,true,true,true,181,true),
  ('ALI AM','RISO E ALTRI CEREALI','112','QUINOA REAL',7,12,true,true,true,182,true),
  ('ALI AM','RISO E ALTRI CEREALI','205','COUS COUS INTEGRALE',6,12,true,true,true,183,true),
  ('ALI AM','RISO E ALTRI CEREALI','329','RISO THAY AROMATICO',6,12,true,true,true,184,true),
  ('ALI AM','RISO E ALTRI CEREALI','330','RISO THAY INTEGRALE',6,12,true,true,true,185,true),
  ('ALI AM','RISO E ALTRI CEREALI','415','RISO THAY ROSSO INTEGRALE',4,10,true,true,true,186,true),
  ('ALI AM','RISO E ALTRI CEREALI','786','RISO BASMATI',4,10,true,true,true,187,true),
  ('ALI AM','BISCOTTI E CEREALI','119','BISCOTTI GOCCE CIOCC. 300 GR',3,12,true,true,true,188,true),
  ('ALI AM','BISCOTTI E CEREALI','136','MUESLI ESOTICO',5.5,8,true,true,true,189,true),
  ('ALI AM','BISCOTTI E CEREALI','150','BISCOTTI MIELE 300 GR',3,12,true,true,true,190,true),
  ('ALI AM','BISCOTTI E CEREALI','151','BISCOTTI CACAO ANACARDI 300 GR',3,12,true,true,true,191,true),
  ('ALI AM','BISCOTTI E CEREALI','366','BISCOTTI AL MIELE 700 GR',5,8,true,true,true,192,true),
  ('ALI AM','BISCOTTI E CEREALI','391','BIOFROLLE AL CACAO',3,12,true,true,true,193,true),
  ('ALI AM','BISCOTTI E CEREALI','503','BISCOTTI GOCCE CIOCC. 700 GR',5,8,true,true,true,194,true),
  ('ALI AM','BISCOTTI E CEREALI','752','BIOFROLLE ALLA QUINOA',3,12,true,true,true,195,true),
  ('ALI AM','BISCOTTI E CEREALI','1235','BISCOTTI RISO E AVENA 300 GR',3,12,true,true,true,196,true),
  ('ALI AM','CONDIMENTI - SPEZIE E AROMI','79','PEPE NERO IN GRANI',2.5,6,true,true,true,197,true),
  ('ALI AM','CONDIMENTI - SPEZIE E AROMI','80','PEPE BIANCO IN GRANI',2.5,6,true,true,true,198,true),
  ('ALI AM','CONDIMENTI - SPEZIE E AROMI','82','CANNELLA IN BASTONCINI',2.5,6,true,true,true,199,true),
  ('ALI AM','CONDIMENTI - SPEZIE E AROMI','83','CANNELLA MACINATA',2.5,6,true,true,true,200,true),
  ('ALI AM','CONDIMENTI - SPEZIE E AROMI','84','CURRY SAPORITO',2.5,6,true,true,true,201,true),
  ('ALI AM','CONDIMENTI - SPEZIE E AROMI','85','CURRY PICCANTE',2.5,6,true,true,true,202,true),
  ('ALI AM','CONDIMENTI - SPEZIE E AROMI','87','NOCI MOSCATE INTERE',2.5,6,true,true,true,203,true),
  ('ALI AM','CONDIMENTI - SPEZIE E AROMI','88','CHIODI DI GAROFANO',2.5,6,true,true,true,204,true),
  ('ALI AM','CONDIMENTI - SPEZIE E AROMI','89','CURCUMA MACINATA',2.5,6,true,true,true,205,true),
  ('ALI AM','CONDIMENTI - SPEZIE E AROMI','90','ZENZERO MACINATO',2.5,6,true,true,true,206,true),
  ('ALI AM','CONDIMENTI - SPEZIE E AROMI','91','CUMINO IN SEMI',2.5,6,true,true,true,207,true),
  ('ALI AM','CONDIMENTI - SPEZIE E AROMI','93','CARDAMOMO IN SEMI',5,6,true,true,true,208,true),
  ('ALI AM','CONDIMENTI - SPEZIE E AROMI','94','SESAMO IN SEMI',3,6,true,true,true,209,true),
  ('ALI AM','CONDIMENTI - SPEZIE E AROMI','95','CORIANDOLO MACINATO',2.5,6,true,true,true,210,true),
  ('ALI AM','CONDIMENTI - SPEZIE E AROMI','337','ZAFFERANO IN STIMMI',14,6,true,true,true,211,true),
  ('ALI AM','CONDIMENTI - SPEZIE E AROMI','484','VANIGLIA IN BACCHE',9,4,true,true,true,212,true),
  ('ALI AM','CONDIMENTI - SPEZIE E AROMI','914','SALE ALLE ERBE',5,6,true,true,true,213,true),
  ('ALI AM','CONDIMENTI - SPEZIE E AROMI','980','ZA''ATAR',5,12,true,true,true,214,true),
  ('ALI AM','CONDIMENTI - OLIO','2620','OLIO EVO AGRINOVA',15,6,true,true,true,215,true),
  ('ALI AM','CONDIMENTI - OLIO','1247','OLIO EVO LIBERA TERRA',13,6,true,true,true,216,true),
  ('ALI AM','CONDIMENTI - SALSE','242','PESTO DI BASILICO',4.5,6,true,true,true,217,true),
  ('ALI AM','CONDIMENTI - SALSE','885','SALSA DI NOCI',5,6,true,true,true,218,true),
  ('ALI AM','CONDIMENTI - SALSE','3462','PESTO ROSSO',5,6,true,true,true,219,true),
  ('ALI AM','CONDIMENTI - SALSE','1003','SUGO AL BASILICO',3,12,true,true,true,220,true),
  ('ALI AM','CONDIMENTI - SALSE','1004','SUGO AL FINOCCHIETTO',3,12,true,true,true,221,true),
  ('ALI AM','CONDIMENTI - SALSE','1075','PASSATA DI POMODORO',2,12,true,true,true,222,true),
  ('ALI AM','CONDIMENTI - SALSE','1182','PASSATA CILIEGINO',2.5,12,true,true,true,223,true),
  ('ALI AM','CONDIMENTI - SALSE','1183','PELATI IN SALSA',2.5,12,true,true,true,224,true),
  ('ALI AM','CONDIMENTI - SALSE','3802','SALSA PRONTA DATTERINO',3,12,true,true,true,225,true),
  ('ALI AM','SOSTITUTI DEL PANE - CRACKERS TARALLI E GALLETTE','768','LE LOCAS - POMODORO',1.5,12,true,true,true,226,true),
  ('ALI AM','SOSTITUTI DEL PANE - CRACKERS TARALLI E GALLETTE','1155','LE LOCAS - RISO NERO',1.5,12,true,true,false,227,true),
  ('ALI AM','SOSTITUTI DEL PANE - CRACKERS TARALLI E GALLETTE','1197','LE LOCAS - ROSSO',1.5,12,true,true,false,228,true),
  ('ALI AM','SOSTITUTI DEL PANE - CRACKERS TARALLI E GALLETTE','3391','LE LOCAS - MEDITERRANEO',1.5,12,true,true,true,229,true),
  ('ALI AM','SOSTITUTI DEL PANE - CRACKERS TARALLI E GALLETTE','5432','SFOGLIE CANAPA',4,10,true,true,true,230,true),
  ('ALI AM','SOSTITUTI DEL PANE - CRACKERS TARALLI E GALLETTE','5433','SFOGLIE CURCUMA',4,10,true,true,true,231,true),
  ('ALI AM','SPALMABILI DOLCI - MIELE','811','MIELE ACACIA',7.5,6,true,true,true,232,true),
  ('ALI AM','SPALMABILI DOLCI - MIELE','832','MIELE DEL SOL',6,6,true,true,true,233,true),
  ('ALI AM','SPALMABILI DOLCI - MIELE','833','MIELE ATAMISQUI',6,6,true,true,true,234,true),
  ('ALI AM','SPALMABILI DOLCI - MIELE','854','MIELE DEL SOL 550 GR',8.5,6,true,true,true,235,true),
  ('ALI AM','SPALMABILI DOLCI - MARMELLATE E CONFETTURA','192','CONFETTURA PAPAYA MARACUJA',4,12,false,true,true,236,true),
  ('ALI AM','SPALMABILI DOLCI - MARMELLATE E CONFETTURA','194','CONFETTURA DI MANGO',4,12,false,true,true,237,true),
  ('ALI AM','SPALMABILI DOLCI - MARMELLATE E CONFETTURA','949','COMPOSTA DI MIRTILLI',5,12,true,true,true,238,true),
  ('ALI AM','SPALMABILI DOLCI - MARMELLATE E CONFETTURA','950','COMPOSTA DI LAMPONI',5,12,true,true,true,239,true),
  ('ALI AM','SPALMABILI DOLCI - MARMELLATE E CONFETTURA','1020','COMPOSTA DI MORE',5,12,true,true,true,240,true),
  ('ALI AM','SPALMABILI DOLCI - MARMELLATE E CONFETTURA','5386','MARMELLATA DI LIMONI',5,6,true,true,true,241,true),
  ('ALI AM','SPALMABILI DOLCI - MARMELLATE E CONFETTURA','5387','MARMELLATA DI ARANCE',5,6,true,true,true,242,true),
  ('ALI AM','SPALMABILI DOLCI - MARMELLATE E CONFETTURA','343','MARMELLATA DI ARANCIA ECUADOR',null,12,false,false,false,243,true),
  ('ALI AM','SPALMABILI DOLCI - CREME','958','CREMA FONDENTE',6,12,true,true,true,244,true),
  ('ALI AM','SPALMABILI DOLCI - CREME','959a','CREMA SPALMABILE BIO CAJITA VEGAN',null,12,true,true,true,245,true),
  ('ALI AM','SPALMABILI DOLCI - CREME','959b','CREMA GIANDUIA',6,12,true,true,true,246,true),
  ('ALI AM','SPALMABILI DOLCI - CREME','975','CREMA CACAO NOCC ANACARDI',5.5,12,false,true,true,247,true),
  ('ALI AM','SPALMABILI DOLCI - CREME','728','CREMA SPALMABILE CAJITA',null,12,true,false,false,248,true),
  ('ALI AM','SPALMABILI DOLCI - CREME','961','TRIS CREME SPALMABILI SELEZIONE',null,6,false,false,false,249,true),
  ('ALI AM','RICORRENZE - CONFETTI','99','CONFETTI MANDORLA CIOCC. 1 KG',29,1,true,true,true,250,true),
  ('ALI AM','RICORRENZE - CONFETTI','388','CONFETTI MANDORLA 1KG',23,1,true,true,true,251,true),
  ('ALI AM','RICORRENZE - CONFETTI','519','CONFETTI CIOCC. FONDENTE 1 KG',15,1,true,true,true,252,true),
  ('ALI AM','INTEGRATORI','252','GUARANÀ COMPRESSE',8,6,true,true,true,253,true),
  ('ALI AM','INTEGRATORI','318','SPRAY ALLA PROPOLI',8,6,true,true,true,254,true),
  ('ALI AM','INTEGRATORI','344','SPIRULINA COMPRESSE',8,6,true,true,true,255,true),
  ('ALI AM','INTEGRATORI','512','PASTIGLIE ALLA PROPOLI',5,12,true,true,true,256,true),
  ('ALI AM','INTEGRATORI','513','SCIROPPO BALSAMICO PROPOLI',6.5,6,true,true,true,257,true),
  ('ALI AM','INTEGRATORI','537','CURCUMAN COMPRESSE',8,6,true,true,true,258,true),
  ('ALI AM','INTEGRATORI','538','MACA COMPRESSE',11,6,true,true,true,259,true),
  ('ALI AM','INTEGRATORI','878','MORINGA COMPRESSE',8,6,true,true,true,260,true),
  ('ALI AM','INTEGRATORI','1097','BAOBAB IN POLVERE',11,6,true,true,true,261,true),
  ('ALI AM','INTEGRATORI','2615','DIFESE IMMUNITARIE COMPRESSE',11,6,true,true,true,262,true),
  ('ALI AM','INTEGRATORI','5415','DIGESTIONE',8,6,true,true,true,263,true),
  ('ALI AM','INTEGRATORI','5416','DRENANTE',8,6,true,true,true,264,true),
  ('ALI AM','INTEGRATORI','6235','RELAX',8,12,true,true,true,265,true),
  ('ALI AM','INTEGRATORI','6236','DOLCE DORMIRE',8,6,true,true,true,266,true),
  ('ALI LT','','CU500','COUS COUS SEMOLA',3.5,12,true,true,true,267,true),
  ('ALI LT','','FR350BIO','FROLLINI ARANCE CACAO',4,12,true,true,true,268,true),
  ('ALI LT','','FR355BIO','FROLLINI FARRO MANDORLE',4,12,true,true,true,269,true),
  ('ALI LT','','PS140BIO','POMODORINI SOTTOLIO',4,30,true,true,true,270,true),
  ('ALI LT','','MC270BIO','MARMELLATA CLEMENTINE',5,6,true,true,true,271,true),
  ('ALI LT','','PESPEPVM','PESTO PEPERONCINI PICC.',6,12,true,true,true,272,true),
  ('ALI LT','','LIBOLINB160BIO','OLIVE DOLCI VERDI',4,12,true,true,true,273,true),
  ('ALI LT','','LIBPSC410BIO','PASSATA POMODORO SICCAGNO',3,12,true,true,true,274,true),
  ('ALI LT','','LIBPSP340BIO','POMODORI PELATI BIO',3,12,true,true,true,275,true),
  ('ALI VR','','HUBVRTAH180BIO','SALSA TAHINA',5,6,true,true,true,276,true),
  ('ALI VR','','HUBVR0000SP130','SALSA DI PISTACCHI',6.5,6,true,true,true,277,true),
  ('ALI VR','','HUBVR000RAD100','SALSA DI RADICCHIO',5,6,true,true,true,278,true),
  ('ALI VA','','HUBVA3304','SEMI DI FINOCCHIETTO',4.5,6,true,true,true,279,true),
  ('ALI VA','','HUBVA3313','SOMMACCO',4.5,6,true,true,true,280,true),
  ('ALI VA','','HUBVA3314','SUGO ALLA PUTTANESCA',4.5,12,true,true,true,281,true),
  ('ALI VA','','HUBVA6201','TIMILIA CROCK',4,12,true,true,true,282,true),
  ('ALI VA','','HUBVAFARINAC400','FARINA DI CECI',3.5,12,true,true,true,283,true),
  ('ALI VA','','HUBVAPATETOPIN140','PATE DI TOPINAMBUR',4,6,true,true,true,284,true),
  ('ALI VA','','HUBVASUGOSICILIANO280','SUGO SICILIANO',6.5,6,true,true,true,285,true),
  ('ALI VA','','HUBVASUSINACONFETTURA','CONFETTURA SUSINA',4.5,6,true,true,true,286,true)
ON CONFLICT (product_code, source_sheet) DO NOTHING;
