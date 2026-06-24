import 'dart:convert';
import 'package:http/http.dart' as http;
import 'url.dart';
import 'mock_data.dart';

/// Thrown on any failed API call, with a user-friendly message.
class ApiException implements Exception {
  final String message;
  ApiException(this.message);
  @override
  String toString() => message;
}

/// All backend HTTP calls live here (your api_service.dart pattern).
/// Matches the MoneyMate-style routes: no /api prefix, {message,...} responses.
class ApiService {
  static const _headers = {'Content-Type': 'application/json'};
  static const _timeout = Duration(seconds: 15);

  static dynamic _decode(http.Response r) {
    final body = r.body.isEmpty ? {} : jsonDecode(r.body);
    if (r.statusCode >= 200 && r.statusCode < 300) return body;
    final msg = (body is Map && body['error'] != null)
        ? body['error'].toString()
        : 'Something went wrong (${r.statusCode})';
    throw ApiException(msg);
  }

  // ── Auth ──
  /// Registers, then auto-logs-in so the caller gets the user object.
  static Future<Map<String, dynamic>> signup({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
    required String phone,
  }) async {
    final r = await http
        .post(Uri.parse(Url.signup),
            headers: _headers,
            body: jsonEncode({
              'name': name,
              'email': email,
              'phone': phone,
              'password': password,
              'confirm_password': confirmPassword,
            }))
        .timeout(_timeout);
    _decode(r); // throws on error (mismatch / email exists)
    return login(email: email, password: password);
  }

  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final r = await http
        .post(Uri.parse(Url.login),
            headers: _headers,
            body: jsonEncode({'email': email, 'password': password}))
        .timeout(_timeout);
    final body = _decode(r);
    final user = (body is Map) ? body['user'] : null;
    if (user is Map) return user.cast<String, dynamic>();
    throw ApiException('Unexpected login response');
  }

  static Future<Map<String, dynamic>> updateProfile({
    required int userId,
    required String name,
    required String phone,
  }) async {
    final r = await http
        .put(Uri.parse('${Url.profile}/$userId'),
            headers: _headers,
            body: jsonEncode({'name': name, 'phone': phone}))
        .timeout(_timeout);
    final body = _decode(r);
    final user = (body is Map) ? body['user'] : null;
    if (user is Map) return user.cast<String, dynamic>();
    throw ApiException('Unexpected profile response');
  }

  // ── Contacts ──
  static Future<List<EmergencyContact>> getContacts(int userId) async {
    final r =
        await http.get(Uri.parse('${Url.contacts}/$userId')).timeout(_timeout);
    final body = _decode(r);
    return (body as List).map((e) => EmergencyContact.fromJson(e)).toList();
  }

  static Future<EmergencyContact> addContact({
    required int userId,
    required String name,
    required String phone,
    required String relation,
  }) async {
    final r = await http
        .post(Uri.parse(Url.contacts),
            headers: _headers,
            body: jsonEncode({
              'user_id': userId,
              'name': name,
              'phone': phone,
              'relation': relation,
            }))
        .timeout(_timeout);
    final body = _decode(r);
    final id = (body is Map) ? body['id'] : null;
    return EmergencyContact(
        id: id is int ? id : int.tryParse('$id'),
        name: name,
        phone: phone,
        relation: relation);
  }

  static Future<EmergencyContact> updateContact({
    required int id,
    required String name,
    required String phone,
    required String relation,
  }) async {
    final r = await http
        .put(Uri.parse('${Url.contacts}/$id'),
            headers: _headers,
            body: jsonEncode(
                {'name': name, 'phone': phone, 'relation': relation}))
        .timeout(_timeout);
    _decode(r);
    return EmergencyContact(
        id: id, name: name, phone: phone, relation: relation);
  }

  static Future<void> deleteContact(int id) async {
    final r =
        await http.delete(Uri.parse('${Url.contacts}/$id')).timeout(_timeout);
    _decode(r);
  }

  // ── Reports ──
  static Future<List<IncidentReport>> getReports() async {
    final r = await http.get(Uri.parse(Url.reports)).timeout(_timeout);
    final body = _decode(r);
    return (body as List).map((e) => IncidentReport.fromJson(e)).toList();
  }

  static Future<void> addReport({
    int? userId,
    required String type,
    required String area,
    required String note,
    required double lat,
    required double lng,
    required bool anonymous,
  }) async {
    final r = await http
        .post(Uri.parse(Url.reports),
            headers: _headers,
            body: jsonEncode({
              'user_id': userId,
              'type': type,
              'area': area,
              'note': note,
              'lat': lat,
              'lng': lng,
              'anonymous': anonymous,
            }))
        .timeout(_timeout);
    _decode(r);
  }

  // ── Danger zones ──
  static Future<List<DangerZone>> getDangerZones() async {
    final r = await http.get(Uri.parse(Url.dangerZones)).timeout(_timeout);
    final body = _decode(r);
    return (body as List).map((e) => DangerZone.fromJson(e)).toList();
  }

  // ── SOS ──
  static Future<void> sendSos({
    int? userId,
    required double lat,
    required double lng,
  }) async {
    try {
      await http
          .post(Uri.parse(Url.sos),
              headers: _headers,
              body: jsonEncode({'user_id': userId, 'lat': lat, 'lng': lng}))
          .timeout(_timeout);
    } catch (_) {
      // SOS should never block the UI; ignore network failure here.
    }
  }
}
