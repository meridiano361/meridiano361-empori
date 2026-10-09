-- Log immutabile consensi digitali (prova legale)
CREATE TABLE IF NOT EXISTS consensi_digitali_log (
  id                UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  cliente_id        BIGINT      REFERENCES clienti(id) ON DELETE SET NULL,
  consent_token     TEXT        NOT NULL,
  nome_digitato     TEXT        NOT NULL,
  testo_informativa TEXT        NOT NULL,
  ip_address        TEXT,
  user_agent        TEXT,
  emporio           TEXT,
  signed_at         TIMESTAMPTZ NOT NULL DEFAULT now()
);

ALTER TABLE consensi_digitali_log ENABLE ROW LEVEL SECURITY;

-- Anon può inserire (viene chiamato dalla pagina pubblica consenso)
CREATE POLICY "cdl_insert_anon" ON consensi_digitali_log
  FOR INSERT TO anon WITH CHECK (true);

-- Solo autenticati possono leggere
CREATE POLICY "cdl_select_auth" ON consensi_digitali_log
  FOR SELECT TO authenticated USING (true);

-- Nessuno può modificare o cancellare (immutabile)
