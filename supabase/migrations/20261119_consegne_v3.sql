-- Consegne v3 — 2026-11-19
-- data_consegna diventa opzionale (si lascia vuota se da_concordare)
ALTER TABLE consegne ALTER COLUMN data_consegna DROP NOT NULL;
