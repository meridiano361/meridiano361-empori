-- Trigger server-side: notifica push quando una proposta rifornimento
-- passa a status='inviata'. Usa pg_net per chiamare la edge function.
-- Questo è il backup affidabile indipendente dal browser del mittente.

CREATE OR REPLACE FUNCTION notify_rifornimento_inviata()
RETURNS trigger AS $$
DECLARE
  _ids  UUID[];
  _body jsonb;
BEGIN
  -- Scatta solo quando status diventa 'inviata' (non su INSERT né su altre transizioni)
  IF NEW.status = 'inviata' AND (OLD.status IS NULL OR OLD.status <> 'inviata') THEN
    SELECT ARRAY_AGG(DISTINCT id) INTO _ids
    FROM operatori
    WHERE is_resp_acquisti = true OR ruolo = 'admin';

    IF _ids IS NOT NULL AND ARRAY_LENGTH(_ids, 1) > 0 THEN
      _body := jsonb_build_object(
        'operatore_ids', _ids,
        'target',        'tutti',
        'titolo',        'Meridiano 361',
        'testo',         'Proposta rifornimento — ' || COALESCE(NEW.emporio,'') || ', inviata da ' || COALESCE(NEW.created_by,'Operatore'),
        'tipo',          'ordini',
        'url',           '/pages/rifornimento/proposte.html'
      );

      PERFORM net.http_post(
        url     := 'https://hsalynvxazxqtmsvjrzc.supabase.co/functions/v1/send-notification',
        headers := '{"Content-Type":"application/json","Authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhzYWx5bnZ4YXp4cXRtc3ZqcnpjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Nzc3MjQ3MjcsImV4cCI6MjA5MzMwMDcyN30.JW4nsMrrfuI8BTg4bn2v74seVJ-_prfxZ1PQp5T18a8","apikey":"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhzYWx5bnZ4YXp4cXRtc3ZqcnpjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Nzc3MjQ3MjcsImV4cCI6MjA5MzMwMDcyN30.JW4nsMrrfuI8BTg4bn2v74seVJ-_prfxZ1PQp5T18a8"}'::jsonb,
        body    := _body
      );
    END IF;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trg_rifornimento_inviata ON rifornimento_proposte;
CREATE TRIGGER trg_rifornimento_inviata
  AFTER UPDATE ON rifornimento_proposte
  FOR EACH ROW
  EXECUTE FUNCTION notify_rifornimento_inviata();
