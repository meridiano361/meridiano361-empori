-- Lista Spesa: catalogo articoli + righe ordine per emporio

CREATE TABLE IF NOT EXISTS lista_spesa_articoli (
  id           SERIAL PRIMARY KEY,
  codice       TEXT,
  descrizione  TEXT NOT NULL,
  confezione   INTEGER,
  fornitore    TEXT,
  link         TEXT,
  categoria    TEXT NOT NULL,
  sort_order   INTEGER DEFAULT 0
);

CREATE TABLE IF NOT EXISTS lista_spesa_righe (
  id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  articolo_id  INTEGER REFERENCES lista_spesa_articoli(id) ON DELETE CASCADE,
  emporio      TEXT NOT NULL,          -- 'CR','CAS','VIA','UFF'
  quantita     NUMERIC(8,2) DEFAULT 0,
  note         TEXT,
  completato   BOOLEAN DEFAULT FALSE,
  updated_at   TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(articolo_id, emporio)
);

-- RLS
ALTER TABLE lista_spesa_articoli ENABLE ROW LEVEL SECURITY;
ALTER TABLE lista_spesa_righe    ENABLE ROW LEVEL SECURITY;
CREATE POLICY "auth read articoli"  ON lista_spesa_articoli FOR SELECT TO authenticated USING (true);
CREATE POLICY "auth read righe"     ON lista_spesa_righe    FOR SELECT TO authenticated USING (true);
CREATE POLICY "auth write righe"    ON lista_spesa_righe    FOR ALL    TO authenticated USING (true) WITH CHECK (true);

-- ── SEED ─────────────────────────────────────────────────────────────────────

INSERT INTO lista_spesa_articoli (codice,descrizione,confezione,fornitore,link,categoria,sort_order) VALUES

-- BORSE CON MANICI
('246',     'Borsa Altromercato mini',                              200,  'Altromercato',   NULL, 'Borse con manici', 1),
('126',     'Borsa Altromercato piccola foglie',                    200,  'Altromercato',   NULL, 'Borse con manici', 2),
('127',     'Borsa Altromercato media foglie',                      200,  'Altromercato',   NULL, 'Borse con manici', 3),
('31182',   'Borsa Altromercato maxi',                              175,  'Altromercato',   NULL, 'Borse con manici', 4),
(NULL,      'Borsa per vino singolo',                               25,   'Rossi Carta',    'https://www.rossicarta.it/shopper-in-carta/30-633-25-shoppers-bottiglia-carta-sealing-avana-maniglia-cordino.html#/957-misura-cm_14x85x39', 'Borse con manici', 5),
(NULL,      'Scatola per due bottiglie di vino',                    20,   'Amazon',         'https://www.amazon.it/SCATOLA-BOTTIGLIA-BOTTIGLIE-CARTONE-ONDULATO/dp/B01BLQIMAQ/', 'Borse con manici', 6),
('46526',   'Borsa Altromercato piccola natale',                    200,  'Altromercato',   NULL, 'Borse con manici', 7),
('42944',   'Borsa Altromercato media natale',                      200,  'Altromercato',   NULL, 'Borse con manici', 8),
('196',     'Borsa Altromercato maxi natale',                       175,  'Altromercato',   NULL, 'Borse con manici', 9),

-- SACCHETTI SENZA MANICI
('6604',    'Sacchetto Altromercato piccolo',                       1000, 'Altromercato',   NULL, 'Sacchetti', 1),
('6605',    'Sacchetto Altromercato grande',                        1000, 'Altromercato',   NULL, 'Sacchetti', 2),
('201',     'Sacchettino natale',                                   200,  'Altromercato',   NULL, 'Sacchetti', 3),

-- MATERIALI ACCESSORI ALLA VENDITA
('50517',   'Espositori PVC A3',                                    1,    'Redoffice',      'https://www.universoufficio.it/portadepliant-a3-in-pvc-semirigido-5253-lebez_38395.htm', 'Materiali', 1),
('50518',   'Espositori PVC A4',                                    1,    'Redoffice',      'https://www.universoufficio.it/portadepliant-a4-in-pvc-semirigido_38396.htm', 'Materiali', 2),
(NULL,      'Fili plastica per agganciare prezzi',                  NULL, 'Redoffice',      'https://www.universoufficio.it/busta-da-1000-fili-manuali-125mm-art.5265_03652.htm', 'Materiali', 3),
(NULL,      'Paglietta legno truciolo per confezionamento cesti',   1,    'Imballaggi2000', 'https://www.imballaggi-2000.com/protezione-e-materiale-imballaggio/484-truciolo-legno-10-kg-8058032370747.html', 'Materiali', 4),
(NULL,      'Carta velina',                                         100,  'Caselani',       NULL, 'Materiali', 5),
('70913',   'Buste trasparenti crystal 10x30+6cm c/fondo quadro',  100,  'Redoffice',      NULL, 'Materiali', 6),
('70915',   'Buste trasparenti crystal 14x34+8cm c/fondo quadro',  100,  'Redoffice',      NULL, 'Materiali', 7),
(NULL,      'Rotolo trasparente per cesti 50×250m',                 1,    'Caselani',       NULL, 'Materiali', 8),
(NULL,      'Scaletta plexiglass',                                  1,    'Altromercato',   NULL, 'Materiali', 9),
('6606',    'Rotolo per pacchi Altromercato',                       1,    'Altromercato',   NULL, 'Materiali', 10),
(NULL,      'Rotolo imballaggio bollicine 100m pluriball',          1,    'Caselani',       NULL, 'Materiali', 11),
(NULL,      'Pluriball sostenibile',                                1,    'Imballaggi2000', 'https://www.imballaggi-2000.com/protezione-e-materiale-imballaggio/1809-pluriball-carta-sostenibile.html', 'Materiali', 12),
('3520080510','Nastro raso avorio 3×100',                          1,    'Rossi Carta',    'https://www.rossicarta.it/nastri-in-tessuto/10-16701-nastro-tessuto-in-doppio-raso.html#/44-colore-avorio/1331-misura-mm_3x100_mt', 'Materiali', 13),
(NULL,      'Nastro raso giallo 3×100',                             1,    'Rossi Carta',    NULL, 'Materiali', 14),
(NULL,      'Nastro raso arancio 3×100',                            1,    'Rossi Carta',    NULL, 'Materiali', 15),
(NULL,      'Nastro raso rosa 3×100',                               1,    'Rossi Carta',    NULL, 'Materiali', 16),
(NULL,      'Nastro raso verde chiaro 3×100',                       1,    'Rossi Carta',    NULL, 'Materiali', 17),
(NULL,      'Nastro raso rosso 3×100',                              1,    'Rossi Carta',    'https://www.rossicarta.it/nastri-in-tessuto/10-16716-nastro-tessuto-in-doppio-raso.html#/20-colore-rosso/1331-misura-mm_3x100_mt', 'Materiali', 18),
(NULL,      'Nastro raso blu 3×100',                                1,    'Rossi Carta',    NULL, 'Materiali', 19),
(NULL,      'Nastro raso bordeaux 3×100',                           1,    'Rossi Carta',    'https://www.rossicarta.it/nastri-in-tessuto/10-16705-nastro-tessuto-in-doppio-raso.html#/33-colore-bordeaux/1331-misura-mm_3x100_mt', 'Materiali', 20),
('3972',    'Nastro juta rosso basso',                              1,    'Altromercato',   NULL, 'Materiali', 21),
('3973',    'Nastro juta rosso alto',                               1,    'Altromercato',   NULL, 'Materiali', 22),
('3975',    'Nastro juta verde scuro basso',                        1,    'Altromercato',   NULL, 'Materiali', 23),
('3976',    'Nastro juta verde scuro alto',                         1,    'Altromercato',   NULL, 'Materiali', 24),
('3978',    'Nastro juta naturale basso',                           1,    'Altromercato',   NULL, 'Materiali', 25),
('3979',    'Nastro juta naturale alto',                            1,    'Altromercato',   NULL, 'Materiali', 26),
('3981',    'Nastro juta avorio basso',                             1,    'Altromercato',   NULL, 'Materiali', 27),
('3982',    'Nastro juta avorio alto',                              1,    'Altromercato',   NULL, 'Materiali', 28),

-- CARTOLERIA
('STL3023', 'Etichette adesive prezzi A4 70×36 mm (24/fg)',        100,  'Redoffice',      'https://www.universoufficio.it/etichetta-adesiva-bianca-etta-100fg-in-a4-(24-etichette-da-70x36mm)_3461801.htm', 'Cartoleria', 1),
(NULL,      'Batterie ministilo AAA',                               NULL, 'Risparmiocasa',  NULL, 'Cartoleria', 2),
('STL1005', 'Biro nera',                                            20,   'Redoffice',      'https://www.universoufficio.it/scatola-20-penne-sfera-scatto-nero-p.media-starline_3469883.htm', 'Cartoleria', 3),
('STL1006', 'Biro blu',                                             20,   'Redoffice',      NULL, 'Cartoleria', 4),
('STL1007', 'Biro rossa',                                           20,   'Redoffice',      NULL, 'Cartoleria', 5),
('73980',   'Tratto pen nero',                                      12,   'Redoffice',      'https://www.universoufficio.it/pennarello-tratto-pen-new-metal-nero_51768.htm', 'Cartoleria', 6),
('45788',   'Buste plastica per faldoni forate 22×30 cm',          50,   'Redoffice',      'https://www.universoufficio.it/50-buste-forate-formato-22x30-6-100-b.a.-standard-esselte_23566.htm', 'Cartoleria', 7),
('37637',   'Buste forate porta scontrini 24×30,5 cm',             10,   'Redoffice',      'https://www.universoufficio.it/10-buste-forate-porta-6-scontrini-fiscali-1725-3-24x30,5-marca-favorit_15415.htm', 'Cartoleria', 8),
('71479',   'Carta A4',                                             500,  'Redoffice',      'https://www.universoufficio.it/carta-steinbeis-classic-white-a4-80gr-500fg-100-riciclata_59257.htm', 'Cartoleria', 9),
('72779',   'Cucitrice/pinzatrice',                                 1,    'Redoffice',      'https://www.universoufficio.it/cucitrice-a-pinza-titanium-passo-6---colore-nero_50557.htm', 'Cartoleria', 10),
(NULL,      'Fogli A3 per plastificatrice',                         NULL, NULL,             NULL, 'Cartoleria', 11),
('32682',   'Fogli cartoncino 200 g',                              500,  'Redoffice',      'https://www.universoufficio.it/carta-favini-rismaluce-formato-a4-200g-mq---risma-da-125-fogli-colore-bianco_10460.htm', 'Cartoleria', 12),
('30073',   'Pennarelli neri grossi',                               NULL, NULL,             NULL, 'Cartoleria', 13),
(NULL,      'Pennarello nero',                                      NULL, NULL,             NULL, 'Cartoleria', 14),
('26594',   'Pouches A4 per plastificatrice (100 pz)',              1,    'Redoffice',      'https://www.universoufficio.it/scatola-100-pouches-75-mic-216x303mm_04372.htm', 'Cartoleria', 15),
(NULL,      'Pile ministilo',                                       NULL, NULL,             NULL, 'Cartoleria', 16),
('47715',   'Punti cucitrice',                                      10,   'Redoffice',      'https://www.universoufficio.it/scatola-1000-punti-universali-6-4-leone_25593.htm', 'Cartoleria', 17),
('86534',   'Rotolini scontrini cassa',                             10,   'Redoffice',      'https://www.universoufficio.it/blister-10-rotoli-rc-carta-termica-bpa-free-55gr-57,5mm-x-30mt-diametro-50mm_64312.htm', 'Cartoleria', 18),
('86527',   'Rotolini scontrini POS',                               10,   'Redoffice',      'https://www.universoufficio.it/blister-12-rotoli-carta-termica-55gr-bpa-free-57mm-x-11mt-senza-anima-x-pos_64305.htm', 'Cartoleria', 19),
('STL6301', 'Nastro adesivo carta basso',                           12,   'Redoffice',      'https://www.universoufficio.it/nastro-adesivo-in-carta-19mmx50mt-starline_3464189.htm', 'Cartoleria', 20),
('STL6203', 'Nastro adesivo trasparente basso',                     8,    'Redoffice',      'https://www.universoufficio.it/torre-8-rotoli-nastro-adesivo-19mmx66mt-trasparente-starline_3464081.htm', 'Cartoleria', 21),
('53728',   'Nastro adesivo trasparente alto',                      6,    'Redoffice',      'https://www.universoufficio.it/nastro-adesivo-66mtx50mm-trasparente-ppl-530-comet_31506.htm', 'Cartoleria', 22),
(NULL,      'Nastro adesivo avana pacchi',                          36,   'Amazon',         'https://www.amazon.it/gp/product/B00NB3PRK6/', 'Cartoleria', 23),
('STL6701', 'Taglierino cutter',                                    1,    'Redoffice',      'https://www.universoufficio.it/cutter-18mm-con-bloccalama-basic-starline_3464589.htm', 'Cartoleria', 24),
(NULL,      'Forbici',                                              1,    NULL,             NULL, 'Cartoleria', 25),
(NULL,      'Puntine',                                              50,   NULL,             NULL, 'Cartoleria', 26),

-- IGIENE
('82489',   'Carta igienica (pacco 10 rotoli)',                     10,   'Redoffice',      'https://www.universoufficio.it/pacco-10-rotoli-carta-igienica-180-strappi-econatural-lucart_60267.htm', 'Igiene', 1),
('56959',   'Carta per mani (210 salviette)',                       15,   'Redoffice',      'https://www.universoufficio.it/cerca/56959.htm', 'Igiene', 2),
('82483',   'Carta rotoloni grandi',                                2,    'Redoffice',      NULL, 'Igiene', 3),
(NULL,      'Cattura polvere',                                      1,    'Risparmiocasa',  NULL, 'Igiene', 4),
(NULL,      'Detergente per vetri',                                 1,    'Risparmiocasa',  'https://shop.risparmiocasa.com/prodotti/cura-casa/detersivi-e-pulizia-casa/prodotti-pulizia-vetri/risparmio-casa-power-vetri-750ml', 'Igiene', 5),
(NULL,      'Mocio',                                                1,    'Risparmiocasa',  NULL, 'Igiene', 6),
(NULL,      'Togli ragnatele con asta telescopica',                 1,    'Risparmiocasa',  NULL, 'Igiene', 7);
