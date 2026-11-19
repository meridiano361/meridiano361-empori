-- ══════════════════════════════════════════════════════════════════════
-- Consegne v2 — 2026-11-19
-- Aggiunta campi: concordare, pagamento
-- ══════════════════════════════════════════════════════════════════════

ALTER TABLE consegne ADD COLUMN IF NOT EXISTS da_concordare   boolean      NOT NULL DEFAULT false;
ALTER TABLE consegne ADD COLUMN IF NOT EXISTS ora_concordata   time;
ALTER TABLE consegne ADD COLUMN IF NOT EXISTS tipo_pagamento   text
  CHECK (tipo_pagamento IN ('scontrinato','regalo','pagato','da_pagare'));
ALTER TABLE consegne ADD COLUMN IF NOT EXISTS importo          numeric(10,2);
ALTER TABLE consegne ADD COLUMN IF NOT EXISTS metodo_pagamento text
  CHECK (metodo_pagamento IN ('pos','contanti'));
