-- Notifica push broadcast: Calendario Commerciale ora visibile a tutti.
-- ISTRUZIONE: esegui UNA VOLTA nel Supabase SQL Editor.

SELECT net.http_post(
  url                  => 'https://hsalynvxazxqtmsvjrzc.supabase.co/functions/v1/send-notification',
  headers              => '{"Content-Type":"application/json","Authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhzYWx5bnZ4YXp4cXRtc3ZqcnpjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Nzc3MjQ3MjcsImV4cCI6MjA5MzMwMDcyN30.JW4nsMrrfuI8BTg4bn2v74seVJ-_prfxZ1PQp5T18a8"}'::jsonb,
  body                 => '{"target":"tutti","titolo":"M361 — Novità","testo":"Il Calendario Commerciale è ora visibile a tutti gli operatori. Scopri le campagne attive!","url":"/pages/calendario/index.html","tipo":"generali"}'::jsonb,
  timeout_milliseconds => 30000
);
