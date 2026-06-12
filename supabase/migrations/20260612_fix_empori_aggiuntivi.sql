-- Emilio e Chiara lavorano solo a Cremona: rimuovi empori_aggiuntivi sbagliati
UPDATE operatori
SET empori_aggiuntivi = '[]'::jsonb
WHERE id IN (
  '137b3677-608c-4525-ac64-2e8a8fd0d892',  -- Chiara Monteverdi
  'd318a06f-dcae-4762-841b-f951f7a9788f'   -- Emilio Mazzolari
);
