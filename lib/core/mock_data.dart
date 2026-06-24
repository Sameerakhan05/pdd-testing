import 'package:latlong2/latlong.dart';

/// ─────────────────────────────────────────────
///  Mock data layer
///  Everything here is fake/local so the FRONTEND
///  works with zero backend. Later you replace these
///  lists with calls from api_service.dart.
/// ─────────────────────────────────────────────

enum SafetyLevel { safe, caution, danger }

class NavStep {
  final String instruction; // "Turn left onto MG Road"
  final double meters; // length of this step
  final LatLng location; // where the maneuver happens
  NavStep({
    required this.instruction,
    required this.meters,
    required this.location,
  });
}

class RouteOption {
  final String label; // "Safest route", "Fastest route"
  final int safetyScore; // 0–100
  final int minutes;
  final double km;
  final SafetyLevel level;
  final List<LatLng> points;
  final List<NavStep> steps; // turn-by-turn

  RouteOption({
    required this.label,
    required this.safetyScore,
    required this.minutes,
    required this.km,
    required this.level,
    required this.points,
    this.steps = const [],
  });
}

class DangerZone {
  final LatLng center;
  final double radiusMeters;
  final String reason; // "Low lighting", "Low activity"
  DangerZone(this.center, this.radiusMeters, this.reason);

  factory DangerZone.fromJson(Map<String, dynamic> j) => DangerZone(
        LatLng((j['lat'] as num).toDouble(), (j['lng'] as num).toDouble()),
        (j['radius'] as num).toDouble(),
        (j['reason'] ?? 'Risky area').toString(),
      );
}

class IncidentReport {
  final String id;
  final String type; // Harassment, Stalking, Poor lighting...
  final String area;
  final String note;
  final DateTime time;
  final LatLng location;
  IncidentReport({
    required this.id,
    required this.type,
    required this.area,
    required this.note,
    required this.time,
    required this.location,
  });

  factory IncidentReport.fromJson(Map<String, dynamic> j) => IncidentReport(
        id: j['id'].toString(),
        type: (j['type'] ?? 'Other').toString(),
        area: (j['area'] ?? '').toString(),
        note: (j['note'] ?? '').toString(),
        time: DateTime.tryParse((j['created_at'] ?? '').toString())?.toLocal() ??
            DateTime.now(),
        location:
            LatLng((j['lat'] as num).toDouble(), (j['lng'] as num).toDouble()),
      );
}

class EmergencyContact {
  final int? id;
  final String name;
  final String phone;
  final String relation;
  EmergencyContact({
    this.id,
    required this.name,
    required this.phone,
    required this.relation,
  });

  Map<String, dynamic> toJson() =>
      {'name': name, 'phone': phone, 'relation': relation};

  factory EmergencyContact.fromJson(Map<String, dynamic> j) => EmergencyContact(
        id: j['id'] is int ? j['id'] : int.tryParse('${j['id']}'),
        name: j['name'] ?? '',
        phone: j['phone'] ?? '',
        relation: j['relation'] ?? '',
      );
}

// ── Sample routes around Chennai (hardcoded so the map draws instantly).
// Later these come from a routing engine (OSRM / Google Directions).
final List<RouteOption> kSampleRoutes = [
  RouteOption(
    label: 'Safest route',
    safetyScore: 88,
    minutes: 19,
    km: 4.1,
    level: SafetyLevel.safe,
    points: const [
      LatLng(13.0827, 80.2707),
      LatLng(13.0860, 80.2680),
      LatLng(13.0905, 80.2660),
      LatLng(13.0955, 80.2635),
      LatLng(13.1010, 80.2620),
      LatLng(13.1050, 80.2600),
    ],
  ),
  RouteOption(
    label: 'Fastest route',
    safetyScore: 54,
    minutes: 14,
    km: 3.4,
    level: SafetyLevel.caution,
    points: const [
      LatLng(13.0827, 80.2707),
      LatLng(13.0880, 80.2740),
      LatLng(13.0930, 80.2730),
      LatLng(13.0985, 80.2700),
      LatLng(13.1050, 80.2600),
    ],
  ),
];

// ── Risky areas (low light / low crowd) shown as red circles on the map.
final List<DangerZone> kDangerZones = [
  DangerZone(const LatLng(13.0895, 80.2745), 220, 'Low lighting reported'),
  DangerZone(const LatLng(13.0965, 80.2695), 180, 'Low foot traffic at night'),
  DangerZone(const LatLng(13.0935, 80.2620), 160, '2 incidents reported here'),
];

// ── Community incident reports
final List<IncidentReport> kReports = [
  IncidentReport(
    id: 'r1',
    type: 'Poor lighting',
    area: 'Anna Nagar 2nd Ave',
    note: 'Streetlights not working for the past week.',
    time: DateTime.now().subtract(const Duration(hours: 3)),
    location: const LatLng(13.0895, 80.2745),
  ),
  IncidentReport(
    id: 'r2',
    type: 'Harassment',
    area: 'Near Metro exit',
    note: 'Group loitering near the underpass after 9 PM.',
    time: DateTime.now().subtract(const Duration(hours: 8)),
    location: const LatLng(13.0965, 80.2695),
  ),
  IncidentReport(
    id: 'r3',
    type: 'Stalking',
    area: 'T. Nagar lane',
    note: 'Felt followed walking from the bus stop.',
    time: DateTime.now().subtract(const Duration(days: 1)),
    location: const LatLng(13.0935, 80.2620),
  ),
];

const kReportTypes = [
  'Harassment',
  'Stalking',
  'Poor lighting',
  'Unsafe crowd',
  'Theft',
  'Other',
];
