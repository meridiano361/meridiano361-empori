// Service Worker M361 — gestisce notifiche push anche con app chiusa

self.addEventListener('push', event => {
  let data = { title: 'M361', body: '' };
  try { data = event.data.json(); } catch (_) {}

  event.waitUntil(
    clients.matchAll({ type: 'window', includeUncontrolled: true }).then(list => {
      // Avvisa tutte le finestre aperte per il banner in-app
      list.forEach(c => c.postMessage({ type: 'm361-push', title: data.title, body: data.body || '' }));

      // Mostra sempre la notifica di sistema (visibile quando l'app è chiusa/in background)
      return self.registration.showNotification(data.title, {
        body:     data.body || '',
        icon:     '/icons/icon-192.png',
        badge:    '/icons/icon-192.png',
        vibrate:  [200, 100, 200],
        tag:      'm361-notifica',
        renotify: true,
        data:     { url: data.url || '/' },
      });
    })
  );
});

self.addEventListener('notificationclick', event => {
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
