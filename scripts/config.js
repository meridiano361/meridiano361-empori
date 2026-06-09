/**
 * config.js — Configurazione integrazioni esterne M361 Empori.
 *
 * Questo è l'UNICO file da modificare per le integrazioni.
 * Non toccare i file delle pagine per aggiornare queste impostazioni.
 *
 * ─────────────────────────────────────────────────────────────────
 * GCAL_CLIENT_ID — Google OAuth 2.0 Client ID (una-tantum, da admin)
 * ─────────────────────────────────────────────────────────────────
 * Come ottenerlo (5 minuti, una sola volta):
 *   1. Vai su https://console.cloud.google.com
 *   2. Crea un progetto (es. "M361 Empori")
 *   3. Menu → API e servizi → Libreria → cerca "Google Calendar API" → Abilita
 *   4. Menu → API e servizi → Credenziali → Crea credenziali → ID client OAuth 2.0
 *   5. Tipo applicazione: "Applicazione web"
 *   6. Origini JavaScript autorizzate: aggiungi l'URL del tuo sito Vercel
 *      (es. https://meridiano361-empori.vercel.app)
 *   7. Copia l'ID client (formato: xxxxxxxxxx.apps.googleusercontent.com)
 *   8. Incollalo nel campo GCAL_CLIENT_ID qui sotto
 *   9. Salva, commit, push — fatto per sempre.
 */
window.M361_CONFIG = {

  // Incolla qui il tuo Google OAuth 2.0 Client ID.
  // Lascia '' per disabilitare la sincronizzazione Google Calendar.
  GCAL_CLIENT_ID: '',

};
