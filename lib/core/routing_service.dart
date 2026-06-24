import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'mock_data.dart';

/// Place suggestion for autocomplete.
class PlaceSuggestion {
  final String title;
  final String subtitle;
  final LatLng coord;
  PlaceSuggestion(
      {required this.title, required this.subtitle, required this.coord});
}

/// Free OSM services: Photon (autocomplete/reverse) + OSRM (routing).
/// No API key. Rate-limited demo servers — fine for dev.
class RoutingService {
  static const _distance = Distance();
  static const _ua = {'User-Agent': 'SafeRouteApp/1.0 (dev)'};

  // ── Autocomplete (type-ahead) via Photon ──
  static Future<List<PlaceSuggestion>> autocomplete(String q,
      {LatLng? near}) async {
    if (q.trim().length < 3) return [];
    var url = 'https://photon.komoot.io/api/'
        '?q=${Uri.encodeComponent(q)}&limit=6&lang=en';
    if (near != null) url += '&lat=${near.latitude}&lon=${near.longitude}';
    try {
      final res = await http.get(Uri.parse(url), headers: _ua);
      if (res.statusCode != 200) return [];
      final feats = (jsonDecode(res.body)['features'] as List?) ?? [];
      final out = <PlaceSuggestion>[];
      for (final f in feats) {
        final c = f['geometry']['coordinates'] as List; // [lon, lat]
        final p = f['properties'] as Map<String, dynamic>;
        final title = (p['name'] ?? p['street'] ?? 'Unknown').toString();
        final ctx = [p['street'], p['city'] ?? p['county'], p['state']]
            .where((e) =>
                e != null &&
                e.toString().isNotEmpty &&
                e.toString() != title)
            .map((e) => e.toString())
            .toList();
        out.add(PlaceSuggestion(
          title: title,
          subtitle: ctx.take(2).join(', '),
          coord: LatLng((c[1] as num).toDouble(), (c[0] as num).toDouble()),
        ));
      }
      return out;
    } catch (_) {
      return [];
    }
  }

  // ── Reverse geocode (for tap-to-set destination) ──
  static Future<String> reverseLabel(LatLng p) async {
    try {
      final url = 'https://photon.komoot.io/reverse'
          '?lat=${p.latitude}&lon=${p.longitude}&lang=en';
      final res = await http.get(Uri.parse(url), headers: _ua);
      if (res.statusCode != 200) return 'Dropped pin';
      final feats = (jsonDecode(res.body)['features'] as List?) ?? [];
      if (feats.isEmpty) return 'Dropped pin';
      final pr = feats[0]['properties'];
      return (pr['name'] ?? pr['street'] ?? pr['city'] ?? 'Dropped pin')
          .toString();
    } catch (_) {
      return 'Dropped pin';
    }
  }

  // ── Forward geocode (search button) ──
  static Future<LatLng?> geocode(String query) async {
    final url = Uri.parse('https://nominatim.openstreetmap.org/search'
        '?q=${Uri.encodeComponent(query)}&format=json&limit=1');
    final res = await http.get(url, headers: _ua);
    if (res.statusCode != 200) return null;
    final List data = jsonDecode(res.body);
    if (data.isEmpty) return null;
    return LatLng(double.parse(data[0]['lat']), double.parse(data[0]['lon']));
  }

  // ── Real routes with turn-by-turn steps ──
  static Future<List<RouteOption>> getRoutes(LatLng start, LatLng end,
      {List<DangerZone> zones = const []}) async {
    final url = Uri.parse('https://router.project-osrm.org/route/v1/driving/'
        '${start.longitude},${start.latitude};${end.longitude},${end.latitude}'
        '?overview=full&geometries=geojson&alternatives=true&steps=true');
    final res = await http.get(url);
    if (res.statusCode != 200) return [];
    final data = jsonDecode(res.body);
    if (data['code'] != 'Ok') return [];
    final routes = data['routes'] as List;
    if (routes.isEmpty) return [];

    final raw = <({
      List<LatLng> pts,
      double meters,
      double secs,
      int score,
      List<NavStep> steps
    })>[];
    for (final r in routes) {
      final coords = (r['geometry']['coordinates'] as List)
          .map<LatLng>((c) => LatLng(c[1] as double, c[0] as double))
          .toList();
      raw.add((
        pts: coords,
        meters: (r['distance'] as num).toDouble(),
        secs: (r['duration'] as num).toDouble(),
        score: _safetyScore(coords, zones),
        steps: _parseSteps(r),
      ));
    }

    final safestIdx = _indexOfMax(raw.map((e) => e.score).toList());
    final fastestIdx = _indexOfMin(raw.map((e) => e.secs).toList());

    final result = <RouteOption>[];
    for (int i = 0; i < raw.length; i++) {
      final e = raw[i];
      String label;
      if (raw.length == 1) {
        label = 'Recommended route';
      } else if (i == safestIdx) {
        label = 'Safest route';
      } else if (i == fastestIdx) {
        label = 'Fastest route';
      } else {
        label = 'Alternative route';
      }
      result.add(RouteOption(
        label: label,
        safetyScore: e.score,
        minutes: (e.secs / 60).round(),
        km: double.parse((e.meters / 1000).toStringAsFixed(1)),
        level: e.score >= 75
            ? SafetyLevel.safe
            : e.score >= 50
                ? SafetyLevel.caution
                : SafetyLevel.danger,
        points: e.pts,
        steps: e.steps,
      ));
    }
    result.sort((a, b) => b.safetyScore.compareTo(a.safetyScore));
    return result;
  }

  static List<NavStep> _parseSteps(Map route) {
    final out = <NavStep>[];
    for (final leg in (route['legs'] as List? ?? [])) {
      for (final s in (leg['steps'] as List? ?? [])) {
        final man = s['maneuver'] as Map;
        final loc = man['location'] as List; // [lon, lat]
        out.add(NavStep(
          instruction: _instruction(man, (s['name'] ?? '').toString()),
          meters: (s['distance'] as num).toDouble(),
          location:
              LatLng((loc[1] as num).toDouble(), (loc[0] as num).toDouble()),
        ));
      }
    }
    return out;
  }

  static String _instruction(Map man, String road) {
    final type = (man['type'] ?? '').toString();
    final mod = (man['modifier'] ?? '').toString();
    final on = road.isNotEmpty ? ' onto $road' : '';
    switch (type) {
      case 'depart':
        return road.isNotEmpty ? 'Head out on $road' : 'Start';
      case 'arrive':
        return 'Arrive at your destination';
      case 'turn':
        return 'Turn $mod$on';
      case 'new name':
        return road.isNotEmpty ? 'Continue onto $road' : 'Continue';
      case 'continue':
        return road.isNotEmpty ? 'Continue on $road' : 'Continue';
      case 'merge':
        return 'Merge $mod$on';
      case 'on ramp':
        return 'Take the ramp$on';
      case 'off ramp':
        return 'Take the exit$on';
      case 'fork':
        return 'Keep $mod$on';
      case 'end of road':
        return 'Turn $mod$on';
      case 'roundabout':
      case 'rotary':
        return 'Enter the roundabout$on';
      case 'roundabout turn':
        return 'At the roundabout, turn $mod$on';
      default:
        return mod.isNotEmpty
            ? 'Turn $mod$on'
            : (road.isNotEmpty ? 'Continue onto $road' : 'Continue');
    }
  }

  static int _safetyScore(List<LatLng> pts, List<DangerZone> zones) {
    double penalty = 0;
    for (final z in zones) {
      double minD = double.infinity;
      for (int i = 0; i < pts.length; i += 3) {
        final d = _distance(z.center, pts[i]);
        if (d < minD) minD = d;
      }
      if (minD < z.radiusMeters) {
        penalty += 25;
      } else if (minD < z.radiusMeters + 150) {
        penalty += 12;
      }
    }
    return (100 - penalty).clamp(20, 99).round();
  }

  static int _indexOfMax(List<num> v) {
    var idx = 0;
    for (var i = 1; i < v.length; i++) {
      if (v[i] > v[idx]) idx = i;
    }
    return idx;
  }

  static int _indexOfMin(List<num> v) {
    var idx = 0;
    for (var i = 1; i < v.length; i++) {
      if (v[i] < v[idx]) idx = i;
    }
    return idx;
  }
}
