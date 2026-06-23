-- ─────────────────────────────────────────────────────────────────────────────
-- 20260623_app_settings.sql
-- Tabella chiave-valore per configurazione globale dell'app.
-- Usata per ora dal testo personalizzabile nella schermata di login.
-- ─────────────────────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS public.app_settings (
  key        TEXT PRIMARY KEY,
  value      TEXT NOT NULL DEFAULT '',
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Lettura pubblica: la login la legge PRIMA dell'autenticazione (ruolo anon)
ALTER TABLE public.app_settings ENABLE ROW LEVEL SECURITY;

CREATE POLICY "app_settings_public_read" ON public.app_settings
  FOR SELECT TO anon, authenticated USING (true);

CREATE POLICY "app_settings_auth_write" ON public.app_settings
  FOR ALL TO authenticated USING (true) WITH CHECK (true);

-- Valore di default
INSERT INTO public.app_settings (key, value)
VALUES ('login_caption', 'piattaforma gestione empori')
ON CONFLICT (key) DO NOTHING;
