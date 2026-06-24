/// Single source of truth for the API base URL (MoneyMate-style routes).
///
/// Pick the right one for where you're running:
///  • Android emulator  → http://10.0.2.2:5000   (maps to your PC's localhost)
///  • Real phone on same WiFi → http://<your-PC-LAN-IP>:5000  (e.g. 192.168.1.5)
///  • Deployed on Railway → https://<your-app>.up.railway.app
class Url {
  // Change this one line to switch environments.
  static const String base = 'https://web-production-0324de.up.railway.app';

  static const String signup = '$base/signup';
  static const String login = '$base/login';
  static const String currentUser = '$base/get_current_user';
  static const String profile = '$base/profile'; //  /profile/<user_id>
  static const String contacts = '$base/contacts'; //  /contacts/<user_id>
  static const String reports = '$base/reports';
  static const String dangerZones = '$base/danger_zones';
  static const String sos = '$base/sos';
  static const String dashboard = '$base/dashboard'; //  /dashboard/<user_id>
}
