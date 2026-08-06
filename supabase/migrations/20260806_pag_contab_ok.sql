-- Flag contabilità per forme di pagamento: l'impiegato lo spunta dopo aver registrato i pagamenti del giorno
ALTER TABLE cassa_giorni ADD COLUMN IF NOT EXISTS pag_contab_ok BOOLEAN DEFAULT FALSE;
