ALTER TABLE operatori
  ADD COLUMN IF NOT EXISTS is_resp_acquisti boolean NOT NULL DEFAULT false;

GRANT UPDATE (is_resp_acquisti) ON operatori TO anon;
