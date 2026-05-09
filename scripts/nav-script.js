/**
 * nav-script.js — M361 App
 * ─────────────────────────────────────────────────────────
 * UTILIZZO: una sola riga in ogni pagina, dentro <head>:
 *
 *   <script src="../../scripts/nav-script.js"></script>
 *
 * Per index.html (root):
 *   <script src="scripts/nav-script.js"></script>
 *
 * Il file è completamente autonomo:
 * inietta da solo Font Awesome, i font Google, tutti gli stili,
 * l'header con logo e il bottom nav.
 * Non serve aggiungere nessun altro <link> o <style>.
 * ─────────────────────────────────────────────────────────
 */

(function () {
  'use strict';

  /* ═══════════════════════════════════════════════════════
     1. PERCORSO BASE (funziona con file:// e http://)
  ═══════════════════════════════════════════════════════ */
  function getBase() {
    // Ottieni il percorso dello script stesso (non della pagina host)
    const scripts = document.querySelectorAll('script[src]');
    for (const s of scripts) {
      if (s.src && s.src.includes('nav-script.js')) {
        // risali dalla directory dello script
        return s.src.replace(/scripts\/nav-script\.js.*$/, '');
      }
    }
    // Fallback: calcola dalla pagina corrente
    const path = window.location.pathname.replace(/\\/g, '/');
    const depth = path.split('/').filter(Boolean).length - 1;
    if (depth <= 0) return './';
    return Array(depth).fill('..').join('/') + '/';
  }
  const BASE = getBase();

  /* ═══════════════════════════════════════════════════════
     2. VOCI DI NAVIGAZIONE
  ═══════════════════════════════════════════════════════ */
  const NAV = [
    // group: null = senza etichetta sezione
    { group: null, items: [
      { id: 'home',    label: 'Home',    icon: 'fa-house',     href: 'index.html', active: true },
    ]},
    { group: 'Clienti', items: [
      { id: 'ordini',        label: 'Ordini',       icon: 'fa-bag-shopping',   href: 'pages/ordini/ordini.html',         active: true  },
      { id: 'prenotazioni',  label: 'Prenotazioni', icon: 'fa-calendar-check', href: 'pages/prenotazioni/index.html',    active: false },
      { id: 'tessere',       label: 'Tessere',      icon: 'fa-id-card',        href: 'pages/tessere/index.html',         active: false },
      { id: 'info',          label: 'Info',         icon: 'fa-message',        href: 'pages/info/index.html',            active: false },
    ]},
    { group: 'Negozio', items: [
      { id: 'turni',         label: 'Turni',        icon: 'fa-users',          href: 'pages/turni/turni.html',           active: true  },
      { id: 'cassa',         label: 'Cassa',        icon: 'fa-cash-register',  href: 'pages/cassa/cassa.html',           active: true  },
      { id: 'calendario',    label: 'Calendario',   icon: 'fa-calendar-days',  href: 'pages/calendario/index.html',      active: false },
      { id: 'rifornimento',  label: 'Rifornimento', icon: 'fa-boxes-stacked',  href: 'pages/rifornimento/index.html',    active: false },
      { id: 'prezzi',        label: 'Prezzi',       icon: 'fa-tag',            href: 'pages/prezzi/index.html',          active: false },
    ]},
    { group: null, items: [
      { id: 'logout', label: 'Esci', icon: 'fa-right-from-bracket', href: '#', active: true, isLogout: true },
    ]},
  ];

  const ALL_ITEMS = NAV.flatMap(s => s.items);

  /* ═══════════════════════════════════════════════════════
     3. INIETTA FONT AWESOME + GOOGLE FONTS (una volta sola)
  ═══════════════════════════════════════════════════════ */
  function injectDeps() {
    if (!document.getElementById('m361-fa')) {
      const fa = document.createElement('link');
      fa.id   = 'm361-fa';
      fa.rel  = 'stylesheet';
      fa.href = 'https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css';
      document.head.appendChild(fa);
    }
    if (!document.getElementById('m361-fonts')) {
      const f = document.createElement('link');
      f.id   = 'm361-fonts';
      f.rel  = 'stylesheet';
      f.href = 'https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700;800;900&family=DM+Mono:wght@400;500&display=swap';
      document.head.appendChild(f);
    }
  }

  /* ═══════════════════════════════════════════════════════
     4. INIETTA STILI (tutto inline, zero file esterni)
  ═══════════════════════════════════════════════════════ */
  function injectStyles() {
    if (document.getElementById('m361-styles')) return;
    const css = `
/* ── M361 BASE ── */
*, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
:root {
  --m-red:      #b75252;
  --m-red-d:    #8f3d3d;
  --m-red-l:    #fff1f1;
  --m-slate-50: #f8fafc;
  --m-slate-100:#f1f5f9;
  --m-slate-200:#e2e8f0;
  --m-slate-400:#94a3b8;
  --m-slate-500:#64748b;
  --m-slate-600:#475569;
  --m-slate-700:#334155;
  --m-slate-800:#1e293b;
  --m-font:     'Inter', sans-serif;
  --m-mono:     'DM Mono', 'Courier New', monospace;
}
html { -webkit-text-size-adjust: 100%; }
body {
  font-family: var(--m-font);
  background: #f0f2f5;
  color: var(--m-slate-800);
  min-height: 100vh;
  padding-top: 56px;
  padding-bottom: 68px;
  line-height: 1.5;
}

/* ── HEADER ── */
#m361-header {
  position: fixed;
  top: 0; left: 0; right: 0;
  height: 56px;
  background: #fff;
  border-bottom: 1px solid var(--m-slate-200);
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 20px;
  z-index: 900;
  box-shadow: 0 1px 4px rgba(0,0,0,.05);
}
#m361-header a.hd-home {
  display: flex;
  align-items: center;
  gap: 0;
  text-decoration: none;
  flex: 1;
  min-width: 0;
}
.hd-logo { height: 28px; object-fit: contain; flex-shrink: 0; }
.hd-logo-text {
  font-weight: 900; font-size: 15px;
  color: var(--m-red); letter-spacing: .08em;
  flex-shrink: 0;
}
.hd-sep {
  width: 1px; height: 22px;
  background: var(--m-slate-200);
  margin: 0 14px;
  flex-shrink: 0;
}
.hd-title {
  font-size: 14px; font-weight: 700;
  color: var(--m-slate-700);
  white-space: nowrap; overflow: hidden; text-overflow: ellipsis;
}
.hd-logout {
  display: flex; align-items: center; gap: 6px;
  padding: 6px 14px;
  border-radius: 10px;
  border: 1.5px solid var(--m-red);
  background: transparent;
  color: var(--m-red);
  font-size: 11px; font-weight: 800;
  text-transform: uppercase; letter-spacing: .08em;
  cursor: pointer;
  font-family: var(--m-font);
  transition: background .15s;
  flex-shrink: 0;
  margin-left: 12px;
  white-space: nowrap;
}
.hd-logout:hover { background: var(--m-red-l); }
.hd-logout i { font-size: 13px; }
.hd-logout-txt { display: inline; }
@media (max-width: 480px) {
  .hd-logout-txt { display: none; }
  .hd-title { font-size: 13px; }
}

/* ── BOTTOM NAV ── */
#m361-nav {
  position: fixed;
  bottom: 0; left: 0; right: 0;
  height: 60px;
  background: var(--m-red);
  border-top: 2px solid #9e3f3f;
  z-index: 900;
  display: flex;
  align-items: stretch;
  overflow-x: auto;
  overflow-y: hidden;
  -webkit-overflow-scrolling: touch;
  scrollbar-width: none;
  box-shadow: 0 -2px 10px rgba(0,0,0,.15);
}
#m361-nav::-webkit-scrollbar { display: none; }

.mn-sep {
  width: 1px;
  background: rgba(255,255,255,.2);
  margin: 10px 0;
  flex-shrink: 0;
  align-self: stretch;
}

.mn-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 3px;
  padding: 0 13px;
  min-width: 58px;
  text-decoration: none;
  cursor: pointer;
  transition: background .12s;
  border: none;
  background: transparent;
  flex-shrink: 0;
  font-family: var(--m-font);
  -webkit-tap-highlight-color: transparent;
}
.mn-item i {
  font-size: 16px;
  color: rgba(255,255,255,.65);
  transition: color .12s;
  line-height: 1;
}
.mn-item span {
  font-size: 9px; font-weight: 800;
  text-transform: uppercase; letter-spacing: .05em;
  color: rgba(255,255,255,.65);
  white-space: nowrap;
  transition: color .12s;
  line-height: 1;
}

/* pagina corrente */
.mn-item.mn-current {
  background: rgba(255,255,255,.22);
  border-radius: 12px;
  margin: 7px 3px;
  padding: 0 11px;
}
.mn-item.mn-current i,
.mn-item.mn-current span { color: #fff; }

/* hover su voci attive */
.mn-item.mn-active:not(.mn-current):hover {
  background: rgba(255,255,255,.12);
}
.mn-item.mn-active:hover i,
.mn-item.mn-active:hover span { color: #fff; }

/* WIP — disabilitato */
.mn-item.mn-wip {
  opacity: .35;
  cursor: not-allowed;
  pointer-events: none;
}

/* logout */
.mn-item.mn-logout { opacity: .75; }
.mn-item.mn-logout:hover { opacity: 1; background: rgba(255,255,255,.12); }
.mn-item.mn-logout:hover i,
.mn-item.mn-logout:hover span { color: #fff; }

/* ── UTILITY GLOBALI ── */
.m361-card {
  background: #fff;
  border: 1px solid var(--m-slate-200);
  border-radius: 20px;
  box-shadow: 0 1px 4px rgba(0,0,0,.06);
  transition: all .15s;
}
.m361-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(183,82,82,.14);
  border-color: rgba(183,82,82,.25);
}
.m361-sec-title {
  font-size: 10px; font-weight: 900;
  letter-spacing: .16em; text-transform: uppercase;
  color: var(--m-slate-400);
  display: flex; align-items: center; gap: 10px;
  margin-bottom: 18px;
}
.m361-sec-title::before {
  content: ''; display: block;
  width: 3px; height: 16px;
  background: var(--m-red); border-radius: 2px;
}
    `;
    const st = document.createElement('style');
    st.id = 'm361-styles';
    st.textContent = css;
    document.head.insertBefore(st, document.head.firstChild);
  }

  /* ═══════════════════════════════════════════════════════
     5. RILEVA PAGINA CORRENTE
  ═══════════════════════════════════════════════════════ */
  function getCurrentId() {
    const path = window.location.pathname.replace(/\\/g, '/').toLowerCase();
    // home
    if (
      path === '/' ||
      path.endsWith('/index.html') && path.split('/').filter(Boolean).length <= 1
    ) return 'home';
    // match per segmento
    for (const item of ALL_ITEMS) {
      if (item.id === 'home' || item.id === 'logout') continue;
      const parts = item.href.split('/').filter(Boolean);
      // controlla se il path corrente contiene i segmenti chiave
      if (parts.some(p => {
        const seg = p.replace('.html','').toLowerCase();
        return seg.length > 2 && path.includes('/' + seg);
      })) return item.id;
    }
    return null;
  }

  /* ═══════════════════════════════════════════════════════
     6. BUILD HEADER
  ═══════════════════════════════════════════════════════ */
  function buildHeader() {
    // Rimuovi header statici preesistenti (evita duplicati)
    document.querySelectorAll('header:not(#m361-header)').forEach(h => h.remove());
    if (document.getElementById('m361-header')) return;

    const title = document.title.replace(/^M361\s*[-–]\s*/i, '').trim() || 'App';
    const logoSrc = BASE + 'assets/images/logom361_rosso.jpg';

    const hdr = document.createElement('header');
    hdr.id = 'm361-header';
    hdr.innerHTML = `
      <a href="${BASE}index.html" class="hd-home" title="Torna alla home">
        <img src="${logoSrc}" alt="M361" class="hd-logo"
             onerror="this.style.display='none';document.querySelector('.hd-logo-text').style.display='block'">
        <span class="hd-logo-text" style="display:none">M361</span>
        <span class="hd-sep"></span>
        <span class="hd-title">${title}</span>
      </a>
      <button class="hd-logout" id="m361-logout-btn">
        <i class="fas fa-right-from-bracket"></i>
        <span class="hd-logout-txt">Esci</span>
      </button>
    `;
    document.body.insertBefore(hdr, document.body.firstChild);

    document.getElementById('m361-logout-btn').addEventListener('click', () => {
      if (confirm('Vuoi uscire dall\'applicazione?')) {
        window.location.href = BASE + 'index.html';
      }
    });
  }

  /* ═══════════════════════════════════════════════════════
     7. BUILD BOTTOM NAV
  ═══════════════════════════════════════════════════════ */
  function buildNav() {
    // Rimuovi nav preesistenti
    document.querySelectorAll(
      '#m361-nav, nav.bottom-nav, .bottom-nav'
    ).forEach(n => n.remove());

    const currentId = getCurrentId();
    const nav = document.createElement('nav');
    nav.id = 'm361-nav';
    nav.setAttribute('role', 'navigation');
    nav.setAttribute('aria-label', 'Navigazione principale');

    NAV.forEach((section, si) => {
      // separatore tra gruppi
      if (si > 0) {
        const sep = document.createElement('div');
        sep.className = 'mn-sep';
        nav.appendChild(sep);
      }

      section.items.forEach(item => {
        const isCurrent = item.id === currentId;
        const a = document.createElement('a');
        a.className = 'mn-item'
          + (item.active ? ' mn-active' : ' mn-wip')
          + (isCurrent   ? ' mn-current' : '')
          + (item.isLogout ? ' mn-logout' : '');

        if (item.isLogout) {
          a.href = '#';
          a.addEventListener('click', e => {
            e.preventDefault();
            if (confirm('Vuoi uscire dall\'applicazione?')) {
              window.location.href = BASE + 'index.html';
            }
          });
        } else {
          a.href = item.active ? BASE + item.href : '#';
        }

        if (!item.active) {
          a.setAttribute('aria-disabled', 'true');
          a.setAttribute('tabindex', '-1');
          a.title = item.label + ' — in costruzione';
        }
        if (isCurrent) a.setAttribute('aria-current', 'page');

        a.innerHTML = `<i class="fas ${item.icon}"></i><span>${item.label}</span>`;
        nav.appendChild(a);
      });
    });

    document.body.appendChild(nav);

    // Scrolla al tab corrente (utile su mobile)
    requestAnimationFrame(() => {
      const cur = nav.querySelector('.mn-current');
      if (cur) cur.scrollIntoView({ behavior: 'instant', block: 'nearest', inline: 'center' });
    });
  }

  /* ═══════════════════════════════════════════════════════
     8. INIT
  ═══════════════════════════════════════════════════════ */
  function init() {
    injectDeps();
    injectStyles();
    buildHeader();
    buildNav();
  }

  // Esegui subito se il DOM è già pronto, altrimenti aspetta
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
  } else {
    init();
  }

})();
