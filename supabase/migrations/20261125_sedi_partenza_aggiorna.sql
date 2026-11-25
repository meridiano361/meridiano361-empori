-- Aggiorna indirizzi completi per tutti i luoghi esistenti
UPDATE sedi_partenza SET indirizzo='Corso G. Matteotti 1',    comune='Cremona',       cap='26100' WHERE id=1;
UPDATE sedi_partenza SET indirizzo='Piazza G. Turati 6',      comune='Casalmaggiore', cap='26041' WHERE id=2;
UPDATE sedi_partenza SET indirizzo='Corso Umberto I 34',      comune='Mantova',       cap='46100' WHERE id=3;
UPDATE sedi_partenza SET indirizzo='Via Guido da Castello 6a',comune='Reggio Emilia', cap='42121' WHERE id=4;
UPDATE sedi_partenza SET indirizzo='Via G. Verdi 4',          comune='Viadana',       cap='46019' WHERE id=5;
UPDATE sedi_partenza SET indirizzo='Via S. A. del Fuoco 9a',  comune='Cremona',       cap='26100' WHERE id=6;
UPDATE sedi_partenza SET indirizzo='Via Don Giovanni Verità 8',comune='Reggio Emilia',cap='42121' WHERE id=7;

-- Nuovi luoghi
INSERT INTO sedi_partenza (nome, indirizzo, comune, cap, attiva, ordine) VALUES
  ('On Earth Mantova',          'Corso Umberto I 34', 'Mantova', '46100', true, 20),
  ('Bottega Mappamondo Mantova','Via J. Daino 1',      'Mantova', '46100', true, 21);
