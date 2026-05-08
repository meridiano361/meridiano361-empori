(function() {
  const path = window.location.pathname.split('/').pop();

  const map = {
    'index.html':             'nav-home',
    'ordini.html':            'nav-ordini',
    'ordini_nuovi.html':      'nav-nuovo',
    'ordini_incorso.html':    'nav-incorso',
    'ordini_archiviati.html': 'nav-archivio'
  };

  const activeId = map[path];
  if (activeId) {
    const el = document.getElementById(activeId);
    if (el) el.classList.add('active');
  }
})();
