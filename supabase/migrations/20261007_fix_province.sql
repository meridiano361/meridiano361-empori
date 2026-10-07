-- Fix province: converte nomi estesi e nomi città → sigla 2 lettere maiuscole
-- Copre: nomi province, capoluoghi, comuni frequenti, sigle minuscole/miste

WITH mapping(raw, sigla) AS (
  VALUES
  -- Nomi province estesi
  ('agrigento','AG'),('alessandria','AL'),('ancona','AN'),('aosta','AO'),
  ('valle d''aosta','AO'),('valle daosta','AO'),
  ('ascoli piceno','AP'),('l''aquila','AQ'),('aquila','AQ'),('arezzo','AR'),
  ('asti','AT'),('avellino','AV'),('bari','BA'),
  ('barletta-andria-trani','BT'),('barletta andria trani','BT'),
  ('belluno','BL'),('benevento','BN'),('bergamo','BG'),('biella','BI'),
  ('bologna','BO'),('bolzano','BZ'),('bozen','BZ'),('brescia','BS'),
  ('brindisi','BR'),('cagliari','CA'),('caltanissetta','CL'),
  ('campobasso','CB'),('caserta','CE'),('catania','CT'),('catanzaro','CZ'),
  ('chieti','CH'),('como','CO'),('cosenza','CS'),('cremona','CR'),
  ('crotone','KR'),('cuneo','CN'),('enna','EN'),('fermo','FM'),
  ('ferrara','FE'),('firenze','FI'),('florence','FI'),
  ('foggia','FG'),('forli-cesena','FC'),('forlì-cesena','FC'),
  ('forli cesena','FC'),('forlì cesena','FC'),
  ('frosinone','FR'),('genova','GE'),('gorizia','GO'),('grosseto','GR'),
  ('imperia','IM'),('isernia','IS'),('la spezia','SP'),('spezia','SP'),
  ('latina','LT'),('lecce','LE'),('lecco','LC'),('livorno','LI'),
  ('lodi','LO'),('lucca','LU'),('macerata','MC'),('mantova','MN'),
  ('massa','MS'),('massa-carrara','MS'),('massa carrara','MS'),
  ('matera','MT'),('messina','ME'),('milano','MI'),('milan','MI'),
  ('modena','MO'),('monza','MB'),('monza e brianza','MB'),
  ('monza brianza','MB'),('napoli','NA'),('novara','NO'),('nuoro','NU'),
  ('oristano','OR'),('padova','PD'),('palermo','PA'),('parma','PR'),
  ('pavia','PV'),('perugia','PG'),('pesaro','PU'),
  ('pesaro e urbino','PU'),('pesaro urbino','PU'),('urbino','PU'),
  ('pescara','PE'),('piacenza','PC'),('pisa','PI'),('pistoia','PT'),
  ('pordenone','PN'),('potenza','PZ'),('prato','PO'),('ragusa','RG'),
  ('ravenna','RA'),('reggio calabria','RC'),('reggio di calabria','RC'),
  ('reggio emilia','RE'),('reggio nell''emilia','RE'),
  ('rieti','RI'),('rimini','RN'),('roma','RM'),('rome','RM'),
  ('rovigo','RO'),('salerno','SA'),('sassari','SS'),('savona','SV'),
  ('siena','SI'),('siracusa','SR'),('sondrio','SO'),('sud sardegna','SU'),
  ('taranto','TA'),('teramo','TE'),('terni','TR'),('torino','TO'),
  ('trapani','TP'),('trento','TN'),('treviso','TV'),('trieste','TS'),
  ('udine','UD'),('varese','VA'),('venezia','VE'),('venice','VE'),
  ('verbano-cusio-ossola','VB'),('verbano cusio ossola','VB'),
  ('verbania','VB'),('vercelli','VC'),('verona','VR'),('vicenza','VI'),
  ('viterbo','VT'),('vibo valentia','VV'),
  -- Lombardia
  ('abbiategrasso','MI'),('busto arsizio','VA'),('gallarate','VA'),
  ('saronno','VA'),('sesto san giovanni','MI'),('cinisello balsamo','MI'),
  ('desio','MB'),('seregno','MB'),('vimercate','MB'),
  ('lissone','MB'),('carate brianza','MB'),
  ('bergamo alta','BG'),('treviglio','BG'),('seriate','BG'),('dalmine','BG'),
  ('chiari','BS'),('darfo boario terme','BS'),('lumezzane','BS'),
  ('garda','BS'),('salo','BS'),('salò','BS'),
  ('merate','LC'),('mandello del lario','LC'),
  ('cantù','CO'),('mariano comense','CO'),
  ('codogno','LO'),('casalpusterlengo','LO'),
  ('vigevano','PV'),('voghera','PV'),('mortara','PV'),
  ('crema','CR'),('casalmaggiore','CR'),('soresina','CR'),
  ('pandino','CR'),('romanengo','CR'),('rivolta d''adda','CR'),
  ('viadana','MN'),('suzzara','MN'),('guidizzolo','MN'),
  ('sabbioneta','MN'),('castel goffredo','MN'),('ostiglia','MN'),
  ('volta mantovana','MN'),('castiglione delle stiviere','MN'),
  ('porto mantovano','MN'),('curtatone','MN'),('marmirolo','MN'),
  ('gonzaga','MN'),('pegognaga','MN'),('moglia','MN'),
  ('tirano','SO'),('livigno','SO'),
  -- Piemonte
  ('moncalieri','TO'),('collegno','TO'),('rivoli','TO'),
  ('nichelino','TO'),('settimo torinese','TO'),('chieri','TO'),
  ('pinerolo','TO'),('chivasso','TO'),
  ('alba','CN'),('bra','CN'),('fossano','CN'),('saluzzo','CN'),
  ('mondovi','CN'),('mondovì','CN'),
  ('novi ligure','AL'),('tortona','AL'),('casale monferrato','AL'),
  ('canelli','AT'),
  ('borgomanero','NO'),('arona','NO'),
  ('borgosesia','VC'),
  ('cossato','BI'),
  -- Emilia-Romagna
  ('imola','BO'),('casalecchio di reno','BO'),
  ('carpi','MO'),('sassuolo','MO'),('formigine','MO'),
  ('mirandola','MO'),('vignola','MO'),
  ('fidenza','PR'),('salsomaggiore terme','PR'),
  ('fiorenzuola d''arda','PC'),('castel san giovanni','PC'),
  ('scandiano','RE'),('guastalla','RE'),('correggio','RE'),
  ('rubiera','RE'),('castellarano','RE'),
  ('cento','FE'),('comacchio','FE'),
  ('faenza','RA'),('lugo','RA'),('cervia','RA'),
  ('forli','FC'),('forlì','FC'),('cesena','FC'),('cesenatico','FC'),
  ('riccione','RN'),('cattolica','RN'),
  -- Veneto
  ('legnago','VR'),('san bonifacio','VR'),('bussolengo','VR'),
  ('bassano del grappa','VI'),('schio','VI'),('thiene','VI'),
  ('abano terme','PD'),('cittadella','PD'),('este','PD'),
  ('mestre','VE'),('chioggia','VE'),('dolo','VE'),
  ('conegliano','TV'),('castelfranco veneto','TV'),
  ('feltre','BL'),
  ('adria','RO'),
  -- Toscana
  ('empoli','FI'),('scandicci','FI'),('sesto fiorentino','FI'),
  ('poggibonsi','SI'),('montepulciano','SI'),
  ('sansepolcro','AR'),('cortona','AR'),
  ('monsummano terme','PT'),
  ('viareggio','LU'),('capannori','LU'),
  ('cascina','PI'),('pontedera','PI'),
  ('cecina','LI'),('piombino','LI'),
  ('orbetello','GR'),
  ('carrara','MS'),
  -- Lazio
  ('fiumicino','RM'),('guidonia montecelio','RM'),('tivoli','RM'),
  ('velletri','RM'),('pomezia','RM'),('anzio','RM'),('civitavecchia','RM'),
  ('terracina','LT'),('aprilia','LT'),('formia','LT'),
  ('cassino','FR'),('anagni','FR'),
  -- Campania
  ('giugliano in campania','NA'),('torre del greco','NA'),
  ('nocera inferiore','SA'),('cava de'' tirreni','SA'),
  ('aversa','CE'),('marcianise','CE'),
  ('ariano irpino','AV'),
  ('montesarchio','BN'),
  -- Puglia
  ('altamura','BA'),('molfetta','BA'),('bitonto','BA'),
  ('grottaglie','TA'),('martina franca','TA'),
  ('nardò','LE'),('galatina','LE'),
  ('fasano','BR'),('ostuni','BR'),('francavilla fontana','BR'),
  ('cerignola','FG'),('manfredonia','FG'),
  ('barletta','BT'),('andria','BT'),('trani','BT'),
  -- Sicilia
  ('bagheria','PA'),('monreale','PA'),
  ('acireale','CT'),('misterbianco','CT'),
  ('barcellona pozzo di gotto','ME'),
  ('augusto','SR'),('noto','SR'),
  ('vittoria','RG'),('modica','RG'),
  ('marsala','TP'),('mazara del vallo','TP'),
  ('porto empedocle','AG'),
  ('gela','CL'),
  ('piazza armerina','EN'),
  -- Sardegna
  ('quartu sant''elena','CA'),('selargius','CA'),
  ('alghero','SS'),('porto torres','SS'),
  ('dorgali','NU'),
  -- Altre regioni
  ('rovereto','TN'),('riva del garda','TN'),
  ('merano','BZ'),('bressanone','BZ'),
  ('sanremo','IM'),
  ('foligno','PG'),('spoleto','PG'),('assisi','PG'),
  ('orvieto','TR'),
  ('senigallia','AN'),('jesi','AN'),('fabriano','AN'),
  ('fano','PU'),
  ('civitanova marche','MC'),('recanati','MC'),
  ('san benedetto del tronto','AP'),
  ('porto san giorgio','FM'),
  ('avezzano','AQ'),('sulmona','AQ'),
  ('lanciano','CH'),('vasto','CH'),
  ('montesilvano','PE'),
  ('giulianova','TE'),
  ('termoli','CB'),
  ('melfi','PZ'),
  ('rende','CS'),('corigliano-rossano','CS'),
  ('lamezia terme','CZ')
)
UPDATE clienti
SET provincia = mapping.sigla
FROM mapping
WHERE LOWER(TRIM(clienti.provincia)) = mapping.raw
  AND (
    LENGTH(TRIM(clienti.provincia)) > 2
    OR clienti.provincia != UPPER(clienti.provincia)
  );

-- Gestisci sigle già corrette ma minuscole/miste (es. "cr" → "CR", "Mi" → "MI")
UPDATE clienti
SET provincia = UPPER(TRIM(provincia))
WHERE LENGTH(TRIM(provincia)) = 2
  AND provincia ~ '^[A-Za-z]{2}$'
  AND provincia != UPPER(TRIM(provincia));
