-- Tabella notifiche admin → operatori.
-- target: 'tutti' oppure slug emporio (es. 'cremona')

CREATE TABLE IF NOT EXISTS notifiche (
  id          BIGSERIAL PRIMARY KEY,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
  titolo      TEXT        NOT NULL,
  testo       TEXT        NOT NULL DEFAULT '',
  target      TEXT        NOT NULL DEFAULT 'tutti',
  mittente    TEXT        NOT NULL DEFAULT '',
  letta_da    TEXT[]      NOT NULL DEFAULT '{}'
);
