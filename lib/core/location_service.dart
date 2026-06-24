import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

/// Real device location via GPS.
class LocationService {
  static Future<LatLng?> getCurrent() async {
    // 1. Location services on?
    final enabled = await Geolocator.isLocationServiceEnabled();
    if (!enabled) return null;

    // 2. Permission
    var perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) {
      perm = await Geolocator.requestPermission();
    }
    if (perm == LocationPermission.denied ||
        perm == LocationPermission.deniedForever) {
      return null;
    }

    // 3. Position
    final pos = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );
    return LatLng(pos.latitude, pos.longitude);
  }

  /// Continuous location updates for live tracking (fires every ~8 m moved).
  static Stream<LatLng> stream() {
    return Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 8,
      ),
    ).map((p) => LatLng(p.latitude, p.longitude));
  }
}
