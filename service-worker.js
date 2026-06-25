const CACHE_NAME = 'm361-empori-v12';

const PRECACHE_URLS = [
  '/',
  '/index.html',
  '/login.html',
  '/manifest.json',
  '/assets/style/nav-style.css',
  '/assets/style/responsive.css',
  '/scripts/nav-script.js',
  '/scripts/guide.js',
  '/assets/images/logom361_rosso.jpg',
  '/faviconm361.png',
];

self.addEventListener('install', event => {
  event.waitUntil(
    caches.open(CACHE_NAME)
      .then(cache => cache.addAll(PRECACHE_URLS.map(u => new Request(u, { cache: 'reload' }))))
      .catch(() => {})
  );
  self.skipWaiting();
});

self.addEventListener('activate', event => {
  event.waitUntil(
    caches.keys().then(names =>
      Promise.all(names.filter(n => n !== CACHE_NAME).map(n => caches.delete(n)))
    )
  );
  self.clients.claim();
});

// Network-first: prova sempre la rete, usa la cache solo se offline
self.addEventListener('fetch', event => {
  if (event.request.method !== 'GET') return;
  if (!event.request.url.startsWith(self.location.origin)) return;

  event.respondWith(
    fetch(event.request).then(response => {
      if (response && response.status === 200 && response.type === 'basic') {
        const clone = response.clone();
        caches.open(CACHE_NAME).then(cache => cache.put(event.request, clone));
      }
      return response;
    }).catch(() =>
      caches.match(event.request).then(cached => cached || caches.match('/index.html'))
    )
  );
});

// ── PUSH NOTIFICATIONS ──────────────────────────────────────────────────────
self.addEventListener('push', event => {
  let data = { title: 'M361', body: '', url: '/' };
  try { data = { ...data, ...event.data.json() }; } catch (_) {}

  event.waitUntil(
    clients.matchAll({ type: 'window', includeUncontrolled: true }).then(list => {
      // Manda banner in-app a tutte le finestre aperte (UI aggiuntiva, non sostitutiva)
      list.forEach(c => c.postMessage({ type: 'm361-push', title: data.title, body: data.body }));

      // Mostra SEMPRE la notifica OS — persistente nel centro notifiche finché
      // l'utente non la scorre via. Il banner in-app sopra è solo un'aggiunta visiva.
      // renotify:true garantisce suono/vibrazione anche se c'è già una notifica con lo stesso tag.
      const tag = data.tag || `m361-${new Date().toISOString().slice(0, 10)}`;
      return self.registration.showNotification(data.title, {
        body:               data.body || '',
        icon:               '/icons/icon-192.png',
        badge:              '/icons/icon-192.png',
        requireInteraction: true,
        tag,
        renotify:           true,
        data:               { url: data.url },
        actions: [
          { action: 'open',    title: 'Vedi turni' },
          { action: 'dismiss', title: 'Ho letto ✓' },
        ],
      });
    })
  );
});

self.addEventListener('notificationclick', event => {
  if (event.action === 'dismiss') {
    event.notification.close();
    return;
  }

  event.notification.close();
  event.waitUntil(
    clients.matchAll({ type: 'window', includeUncontrolled: true }).then(list => {
      for (const client of list) {
        if (client.url.includes(self.location.origin) && 'focus' in client) {
          return client.focus();
        }
      }
      return clients.openWindow(event.notification.data?.url || '/');
    })
  );
});
