-- Responsabile comunicazione: gestione contenuti, news, consensi privacy
ALTER TABLE operatori
  ADD COLUMN IF NOT EXISTS is_resp_comunicazione boolean NOT NULL DEFAULT false;

GRANT UPDATE (is_resp_comunicazione) ON operatori TO anon;
