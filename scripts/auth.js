/**
 * auth.js — Helper di autenticazione ed emporio per M361.
 * Dipende da: localStorage.m361_user impostato da login.html → nav-script.js
 */

// ── Prevenzione autofill browser ─────────────────────────────────────────────
// I browser ignorano autocomplete="off" e riempiono i campi con email/password
// salvate. Soluzione: form-honeypot nascosto che assorbe l'autofill + cleanup.
(function preventAutofill() {
  function run() {
    // 1. Form honeypot: il browser riempie questo (nascosto) e lascia stare gli altri
    if (!document.getElementById('m361-autofill-trap')) {
      const trap = document.createElement('form');
      trap.id = 'm361-autofill-trap';
      trap.setAttribute('aria-hidden', 'true');
      trap.style.cssText = 'display:none;position:absolute;left:-9999px;width:0;height:0;overflow:hidden;pointer-events:none';
      trap.innerHTML =
        '<input type="text"     name="m361fu" autocomplete="username"         tabindex="-1">' +
        '<input type="email"    name="m361fe" autocomplete="email"            tabindex="-1">' +
        '<input type="password" name="m361fp" autocomplete="current-password" tabindex="-1">';
      document.body.insertBefore(trap, document.body.firstChild);
    }

    // 2. Cleanup reattivo: rimuove email iniettate nei campi non-login dopo 250ms
    setTimeout(() => {
      document.querySelectorAll('input[type="text"], input[type="search"], input:not([type])').forEach(el => {
        if (el.closest('#login-view, #login-form, [data-autofill-ok]')) return;
        if (el.value && el.value.includes('@')) {
          el.value = el.defaultValue || '';
        }
      });
    }, 250);
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', run);
  } else {
    run();
  }
})();

function getOperatoreLoggato() {
  try { return JSON.parse(localStorage.getItem('m361_user') || 'null'); }
  catch { return null; }
}

function getEmporioLoggato() {
  return getOperatoreLoggato()?.emporio || null;
}

function getRuoloLoggato() {
  return getOperatoreLoggato()?.ruolo || null;
}

// isAdmin = "accesso globale a tutti gli empori".
// I dipendenti (ruolo fisso staff) vedono tutti gli empori come gli admin.
// SCU sono contrattualizzati ma legati a un emporio specifico → non isAdmin.
// Questa distinzione è INTENZIONALE e separata dalla logica "contrattualizzati".
function isAdmin() {
  return ['admin', 'dipendente'].includes(getRuoloLoggato());
}

/**
 * Converte nome emporio (es. "Reggio Emilia") in ID slug
 * usato da prezzi, info, prenotazioni (es. "reggioemilia").
 */
function emporioToId(nome) {
  if (!nome) return null;
  return nome.toLowerCase().replace(/\s+/g, '');
}

/** ID slug → nome completo */
function emporioIdToNome(id) {
  const map = {
    casalmaggiore: 'Casalmaggiore',
    cremona:       'Cremona',
    reggioemilia:  'Reggio Emilia',
    viadana:       'Viadana',
    mantova:       'Mantova',
  };
  return map[id] || id;
}

function getEmporioDisponibili() {
  const op = getOperatoreLoggato();
  if (!op || isAdmin()) return [];
  const empori = [op.emporio].filter(Boolean);
  if (Array.isArray(op.empori_aggiuntivi)) {
    empori.push(...op.empori_aggiuntivi);
  }
  return [...new Set(empori)];
}

/**
 * Applica il filtro emporio a una query Supabase.
 * Gli admin vedono tutto; gli altri solo il proprio emporio.
 * @param {object} query - Query Supabase chainabile
 */
function filtraPerEmporio(query) {
  if (isAdmin()) return query;
  const emporio = getEmporioLoggato();
  if (!emporio) return query;
  return query.eq('emporio', emporio);
}

/**
 * Verifica che l'operatore possa accedere a un record di un certo emporio.
 */
function verificaEmporioAccesso(recordEmporio) {
  if (isAdmin()) return true;
  const disponibili = getEmporioDisponibili();
  return disponibili.some(e => e.toLowerCase() === (recordEmporio || '').toLowerCase());
}

/**
 * Blocca e preimposta un <select> di emporio per l'utente loggato.
 * Non fa nulla se admin o se il select non esiste.
 * @param {string} selectId - ID del select element
 */
function inizializzaSelectEmporio(selectId) {
  if (isAdmin()) return;
  const select = document.getElementById(selectId);
  if (!select) return;
  const emporio = getEmporioLoggato();
  if (!emporio) return;
  // Match case-insensitive
  const opt = Array.from(select.options).find(o =>
    o.value.trim().toLowerCase() === emporio.trim().toLowerCase()
  );
  if (opt) select.value = opt.value;
  select.disabled = true;
  if (!select.parentElement.querySelector('.auth-emp-nota')) {
    const nota = document.createElement('small');
    nota.className = 'auth-emp-nota';
    nota.textContent = '(il tuo emporio)';
    nota.style.cssText =
      'color:#94a3b8;font-size:11px;margin-left:8px;display:inline-block;vertical-align:middle';
    select.parentElement.appendChild(nota);
  }
}
