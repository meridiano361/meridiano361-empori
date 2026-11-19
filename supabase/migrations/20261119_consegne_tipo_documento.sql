-- Separa "scontrinato/regalo" (tipo documento) da "pagato/da_pagare" (stato pagamento)
ALTER TABLE consegne ADD COLUMN IF NOT EXISTS tipo_documento text;

-- Migra i valori esistenti: scontrinato e regalo vanno in tipo_documento
UPDATE consegne SET tipo_documento = 'scontrinato', tipo_pagamento = NULL WHERE tipo_pagamento = 'scontrinato';
UPDATE consegne SET tipo_documento = 'regalo',       tipo_pagamento = NULL WHERE tipo_pagamento = 'regalo';
