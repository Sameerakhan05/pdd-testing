import 'package:shared_preferences/shared_preferences.dart';

/// Static holder for the logged-in user (your usual Session pattern).
class Session {
  static int? userId;
  static String name = '';
  static String email = '';
  static String phone = '';

  static bool get isLoggedIn => userId != null;

  static void setUser(Map<String, dynamic> u) {
    userId = u['id'] is int ? u['id'] : int.tryParse('${u['id']}');
    name = (u['name'] ?? '').toString();
    email = (u['email'] ?? '').toString();
    phone = (u['phone'] ?? '').toString();
    _persist();
  }

  static Future<void> _persist() async {
    final p = await SharedPreferences.getInstance();
    await p.setInt('s_uid', userId ?? -1);
    await p.setString('s_name', name);
    await p.setString('s_email', email);
    await p.setString('s_phone', phone);
  }

  static Future<void> restore() async {
    final p = await SharedPreferences.getInstance();
    final uid = p.getInt('s_uid') ?? -1;
    if (uid <= 0) return;
    userId = uid;
    name = p.getString('s_name') ?? '';
    email = p.getString('s_email') ?? '';
    phone = p.getString('s_phone') ?? '';
  }

  static Future<void> clear() async {
    userId = null;
    name = email = phone = '';
    final p = await SharedPreferences.getInstance();
    await p.remove('s_uid');
    await p.remove('s_name');
    await p.remove('s_email');
    await p.remove('s_phone');
  }
}
