// Vercel serverless: feed ICS personale per operatore.
// GET /api/cal/{ics_token}
// Restituisce un file .ics con i turni dell'operatore (mese corrente + 2 successivi).
'use strict';

const { createClient } = require('@supabase/supabase-js');

const SBURL = 'https://hsalynvxazxqtmsvjrzc.supabase.co';
const SBKEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhzYWx5bnZ4YXp4cXRtc3ZqcnpjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Nzc3MjQ3MjcsImV4cCI6MjA5MzMwMDcyN30.JW4nsMrrfuI8BTg4bn2v74seVJ-_prfxZ1PQp5T18a8';

const LABEL_TURNO = { mattina: 'Mattina', pomeriggio: 'Pomeriggio', sera: 'Sera' };
const ORARI = {
  mattina:    { s: '09:15', e: '13:00' },
  pomeriggio: { s: '15:00', e: '19:00' },
  sera:       { s: '20:00', e: '22:30' },
};

function pad(n) { return String(n).padStart(2, '0'); }

function icalDT(anno, mese, giorno, time) {
  const [hh, mm] = time.split(':');
  return `${anno}${pad(mese)}${pad(giorno)}T${pad(hh)}${pad(mm)}00`;
}

function icalNextDay(anno, mese, giorno) {
  const d = new Date(anno, mese - 1, giorno + 1);
  return `${d.getFullYear()}${pad(d.getMonth() + 1)}${pad(d.getDate())}`;
}

function ie(s) {
  return (s || '').replace(/\\/g, '\\\\').replace(/,/g, '\\,').replace(/;/g, '\\;');
}

function buildICS(nome, turni, assenze) {
  const now = new Date();
  const dtstamp = `${now.getUTCFullYear()}${pad(now.getUTCMonth()+1)}${pad(now.getUTCDate())}T${pad(now.getUTCHours())}${pad(now.getUTCMinutes())}${pad(now.getUTCSeconds())}Z`;

  const lines = [
    'BEGIN:VCALENDAR',
    'VERSION:2.0',
    'PRODID:-//Meridiano361//Empori Turni//IT',
    'CALSCALE:GREGORIAN',
    'METHOD:PUBLISH',
    `X-WR-CALNAME:Turni M361 — ${nome}`,
    'X-WR-TIMEZONE:Europe/Rome',
    'BEGIN:VTIMEZONE',
    'TZID:Europe/Rome',
    'BEGIN:DAYLIGHT',
    'TZOFFSETFROM:+0100',
    'TZOFFSETTO:+0200',
    'TZNAME:CEST',
    'DTSTART:19700329T020000',
    'RRULE:FREQ=YEARLY;BYDAY=-1SU;BYMONTH=3',
    'END:DAYLIGHT',
    'BEGIN:STANDARD',
    'TZOFFSETFROM:+0200',
    'TZOFFSETTO:+0100',
    'TZNAME:CET',
    'DTSTART:19701025T030000',
    'RRULE:FREQ=YEARLY;BYDAY=-1SU;BYMONTH=10',
    'END:STANDARD',
    'END:VTIMEZONE',
  ];

  // Turni events
  for (const t of turni) {
    const { anno, mese, giorno, turno, aperto, emporio } = t;
    const orario = ORARI[turno] || ORARI.mattina;
    const label  = LABEL_TURNO[turno] || turno;
    const stato  = aperto === false ? ' (CHIUSO)' : '';
    const emp    = emporio || '';

    lines.push('BEGIN:VEVENT');
    lines.push(`UID:m361-turno-${emp}-${anno}-${mese}-${giorno}-${turno}-${nome.replace(/\s+/g,'_')}@meridiano361.it`);
    lines.push(`DTSTAMP:${dtstamp}`);
    lines.push(`DTSTART;TZID=Europe/Rome:${icalDT(anno, mese, giorno, orario.s)}`);
    lines.push(`DTEND;TZID=Europe/Rome:${icalDT(anno, mese, giorno, orario.e)}`);
    lines.push(`SUMMARY:${ie(label + (emp ? ' — Emporio ' + emp : '') + stato)}`);
    if (emp) lines.push(`LOCATION:${ie('Emporio ' + emp)}`);
    lines.push('END:VEVENT');
  }

  // Assenze (day events)
  for (const a of assenze) {
    const { anno, mese, giorno, tipo, ore, emporio } = a;
    const ds = `${anno}${pad(mese)}${pad(giorno)}`;
    const de = icalNextDay(anno, mese, giorno);
    const TIPO_LABEL = { ferie: 'Ferie', permesso: 'Permesso', malattia: 'Malattia', altro: 'Assenza' };
    const tipoLabel  = TIPO_LABEL[tipo] || tipo;
    const emp        = emporio || '';

    lines.push('BEGIN:VEVENT');
    lines.push(`UID:m361-ass-${emp}-${anno}-${mese}-${giorno}-${nome.replace(/\s+/g,'_')}@meridiano361.it`);
    lines.push(`DTSTAMP:${dtstamp}`);
    lines.push(`DTSTART;VALUE=DATE:${ds}`);
    lines.push(`DTEND;VALUE=DATE:${de}`);
    lines.push(`SUMMARY:${ie(tipoLabel + (ore ? ` (${ore}h)` : '') + ' — ' + nome)}`);
    lines.push('END:VEVENT');
  }

  lines.push('END:VCALENDAR');
  return lines.join('\r\n');
}

module.exports = async function handler(req, res) {
  const { token } = req.query;

  if (!token || token.length < 20) {
    res.status(404).send('Not found');
    return;
  }

  const db = createClient(SBURL, SBKEY);

  // find operator by ics_token
  const { data: ops, error: opErr } = await db
    .from('operatori')
    .select('nome, emporio')
    .eq('ics_token', token)
    .eq('attivo', true)
    .limit(1);

  if (opErr || !ops?.length) {
    res.status(404).send('Calendario non trovato');
    return;
  }

  const { nome, emporio: emporioPrincipale } = ops[0];

  const now = new Date();
  const fromAnno = now.getFullYear();

  // Fetch all turni across all emporios — filter by operator name in JSONB.
  // Do NOT pre-filter by emporio: admin users have emporio=null and work in multiple stores.
  const { data: righe } = await db
    .from('turni')
    .select('emporio, anno, mese, giorno, turno, aperto, operatori, assenze')
    .gte('anno', fromAnno - 1)
    .lte('anno', fromAnno + 1);

  const myTurni   = [];
  const myAssenze = [];
  const cutoff    = new Date(now.getFullYear(), now.getMonth() - 1, 1);

  for (const row of (righe || [])) {
    const { emporio, anno, mese, giorno, turno, aperto, operatori, assenze } = row;

    const rowDate = new Date(anno, mese - 1, giorno);
    if (rowDate < cutoff) continue;

    // check if this operator is in this turno (case-insensitive, trim)
    const nomeKey = nome.toLowerCase().trim();
    const inTurno = Array.isArray(operatori) && operatori.some(
      o => (o.nome || o || '').toLowerCase().trim() === nomeKey
    );
    if (inTurno) {
      myTurni.push({ anno, mese, giorno, turno, aperto, emporio });
    }

    // check assenze — key format: ${emporio}|${anno}|${mese}|${giorno}|${nome}
    if (assenze && typeof assenze === 'object') {
      for (const [key, val] of Object.entries(assenze)) {
        const parts    = key.split('|');
        const assNome  = parts.slice(4).join('|');
        if (assNome.toLowerCase().trim() !== nomeKey) continue;
        const tipo = typeof val === 'string' ? val : val?.tipo;
        const ore  = typeof val === 'object' ? (val?.ore || 0) : 0;
        if (tipo) myAssenze.push({ anno, mese, giorno, tipo, ore, emporio });
      }
    }
  }

  const ics      = buildICS(nome, myTurni, myAssenze);
  const fileEmp  = (emporioPrincipale || 'turni').toLowerCase().replace(/\s+/g, '-');

  res.setHeader('Content-Type', 'text/calendar; charset=utf-8');
  res.setHeader('Content-Disposition', `attachment; filename="${fileEmp}.ics"`);
  res.setHeader('Cache-Control', 'public, max-age=1800');
  res.status(200).send(ics);
};
