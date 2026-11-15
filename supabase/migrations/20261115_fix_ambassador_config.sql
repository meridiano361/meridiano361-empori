-- Fix tessera_config ambassador: ripristina colore nero, rate ambassador (€30/€25)
-- Causa: riga ambassador nel DB aveva colore e rate standard (copiati o modificati per errore)

UPDATE public.tessera_config
SET euro_per_timbro  = 30,
    sconto_ciclo     = 25,
    colore           = '#111111',
    stamp_image_url  = '/assets/images/simbolo_m361.png',
    updated_at       = now()
WHERE tipo = 'ambassador';
