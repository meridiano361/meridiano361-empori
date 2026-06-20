-- ── LISTINO PREZZI ─────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS listini_prezzi (
  id               uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  emporio          text NOT NULL,
  nome             text NOT NULL,
  categoria        text NOT NULL DEFAULT 'altro',
  formato          text NOT NULL DEFAULT 'A4',
  archiviato       boolean NOT NULL DEFAULT false,
  -- Tipografia
  font_famiglia    text DEFAULT 'Poppins',
  font_size_voce   integer DEFAULT 11,
  font_size_sez    integer DEFAULT 12,
  font_size_titolo integer DEFAULT 18,
  -- Layout
  col_desc_pct     integer DEFAULT 70,
  mg_top           integer DEFAULT 15,
  mg_bottom        integer DEFAULT 15,
  mg_left          integer DEFAULT 15,
  mg_right         integer DEFAULT 15,
  logo_top_h       integer DEFAULT 35,
  logo_bottom_h    integer DEFAULT 28,
  -- Testi
  titolo           text,
  sottotitolo      text,
  note_piede       text,
  mostra_linee     boolean NOT NULL DEFAULT true,
  operatore_nome   text,
  created_at       timestamptz DEFAULT now(),
  updated_at       timestamptz DEFAULT now()
);

CREATE TABLE IF NOT EXISTS listini_voci (
  id           uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  listino_id   uuid NOT NULL REFERENCES listini_prezzi(id) ON DELETE CASCADE,
  riga_ordine  integer NOT NULL DEFAULT 0,
  tipo         text NOT NULL DEFAULT 'voce',    -- voce | sezione | separatore | spazio
  descrizione  text,
  prezzo       numeric(10,2),
  prezzo_testo text,                            -- alternativa testuale al numero
  grassetto    boolean NOT NULL DEFAULT false,
  corsivo      boolean NOT NULL DEFAULT false
);

-- Loghi condivisi: per categoria (tipo='categoria', chiave='alimentari') e per emporio (tipo='emporio', chiave='VillaCelva')
CREATE TABLE IF NOT EXISTS listini_loghi (
  id           uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  tipo         text NOT NULL,
  chiave       text NOT NULL,
  nome_display text,
  immagine_b64 text,
  updated_at   timestamptz DEFAULT now(),
  UNIQUE(tipo, chiave)
);

-- Font personalizzati caricati dall'admin
CREATE TABLE IF NOT EXISTS listini_font (
  id         uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  nome       text NOT NULL UNIQUE,
  dati_b64   text NOT NULL,
  formato    text NOT NULL DEFAULT 'woff2',
  created_at timestamptz DEFAULT now()
);

ALTER TABLE listini_prezzi DISABLE ROW LEVEL SECURITY;
ALTER TABLE listini_voci   DISABLE ROW LEVEL SECURITY;
ALTER TABLE listini_loghi  DISABLE ROW LEVEL SECURITY;
ALTER TABLE listini_font   DISABLE ROW LEVEL SECURITY;

GRANT ALL ON listini_prezzi TO anon, authenticated;
GRANT ALL ON listini_voci   TO anon, authenticated;
GRANT ALL ON listini_loghi  TO anon, authenticated;
GRANT ALL ON listini_font   TO anon, authenticated;

NOTIFY pgrst, 'reload schema';
