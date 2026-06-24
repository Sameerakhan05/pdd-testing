import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:latlong2/latlong.dart' as ll;
import '../core/constants.dart';
import '../core/mock_data.dart';
import '../core/location_service.dart';
import '../core/routing_service.dart';
import '../widgets/common.dart';
import 'report_incident_screen.dart';
import '../core/session.dart';
import '../core/api_service.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapCtrl;
  final _fromCtrl = TextEditingController(text: 'My location');
  final _toCtrl = TextEditingController();

  ll.LatLng? _currentPos;
  ll.LatLng? _destPos;
  bool _locating = true;
  bool _searching = false;
  bool _showRoutes = false;
  bool _navigating = false;

  List<RouteOption> _routes = [];
  int _selectedRoute = 0;

  // live safety data from the backend (mock until first load completes)
  List<DangerZone> _zones = List.of(kDangerZones);
  List<IncidentReport> _mapReports = List.of(kReports);

  List<PlaceSuggestion> _suggestions = [];
  Timer? _debounce;
  StreamSubscription<ll.LatLng>? _posSub;
  int _currentStep = 0;

  LatLng _g(ll.LatLng p) => LatLng(p.latitude, p.longitude);

  @override
  void initState() {
    super.initState();
    _initLocation();
    _loadSafetyData();
    _toCtrl.addListener(_onSearchChanged);
  }

  Future<void> _loadSafetyData() async {
    try {
      final zones = await ApiService.getDangerZones();
      final reports = await ApiService.getReports();
      if (mounted) {
        setState(() {
          _zones = zones;
          _mapReports = reports;
        });
      }
    } catch (_) {
      // backend unreachable → keep the mock fallback so the map isn't bare
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _posSub?.cancel();
    _toCtrl.dispose();
    _fromCtrl.dispose();
    super.dispose();
  }

  Future<void> _initLocation() async {
    final pos = await LocationService.getCurrent();
    if (!mounted) return;
    setState(() {
      _currentPos = pos;
      _locating = false;
    });
    if (pos != null) {
      _mapCtrl?.animateCamera(CameraUpdate.newLatLngZoom(_g(pos), 15));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Location off — enable GPS & permission to center the map'),
      ));
    }
  }

  // ── AUTOCOMPLETE ───────────────────────────
  void _onSearchChanged() {
    final q = _toCtrl.text;
    _debounce?.cancel();
    if (q.trim().length < 3) {
      if (_suggestions.isNotEmpty) setState(() => _suggestions = []);
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 350), () async {
      final res = await RoutingService.autocomplete(q, near: _currentPos);
      if (mounted) setState(() => _suggestions = res);
    });
  }

  void _selectSuggestion(PlaceSuggestion s) {
    _toCtrl.removeListener(_onSearchChanged);
    _toCtrl.text = s.title;
    _toCtrl.addListener(_onSearchChanged);
    setState(() => _suggestions = []);
    FocusScope.of(context).unfocus();
    _routeTo(s.coord);
  }

  // ── TAP TO SET DESTINATION ─────────────────
  Future<void> _onMapTap(LatLng latLng) async {
    if (_navigating) return;
    final p = ll.LatLng(latLng.latitude, latLng.longitude);
    setState(() => _suggestions = []);
    FocusScope.of(context).unfocus();
    final label = await RoutingService.reverseLabel(p);
    _toCtrl.removeListener(_onSearchChanged);
    _toCtrl.text = label;
    _toCtrl.addListener(_onSearchChanged);
    _routeTo(p);
  }

  // ── ROUTING ────────────────────────────────
  Future<void> _findRoute() async {
    if (_toCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a destination first')),
      );
      return;
    }
    FocusScope.of(context).unfocus();
    setState(() {
      _searching = true;
      _suggestions = [];
    });
    final dest = await RoutingService.geocode(_toCtrl.text.trim());
    if (dest == null) {
      _err('Could not find "${_toCtrl.text.trim()}". Try a fuller name.');
      return;
    }
    _routeTo(dest);
  }

  Future<void> _routeTo(ll.LatLng dest) async {
    setState(() {
      _searching = true;
      _suggestions = [];
    });
    try {
      final start = _currentPos;
      if (start == null) {
        _err('Could not get your start location. Turn on GPS.');
        return;
      }
      final routes = await RoutingService.getRoutes(start, dest, zones: _zones);
      if (routes.isEmpty) {
        _err('No route found between those points.');
        return;
      }
      setState(() {
        _destPos = dest;
        _routes = routes;
        _selectedRoute = 0;
        _showRoutes = true;
        _searching = false;
      });
      final sw = LatLng(
        start.latitude < dest.latitude ? start.latitude : dest.latitude,
        start.longitude < dest.longitude ? start.longitude : dest.longitude,
      );
      final ne = LatLng(
        start.latitude > dest.latitude ? start.latitude : dest.latitude,
        start.longitude > dest.longitude ? start.longitude : dest.longitude,
      );
      _mapCtrl?.animateCamera(
          CameraUpdate.newLatLngBounds(LatLngBounds(southwest: sw, northeast: ne), 70));
    } catch (e) {
      _err('Network error. Check your connection and try again.');
    }
  }

  void _err(String msg) {
    if (!mounted) return;
    setState(() => _searching = false);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  // ── LIVE NAVIGATION ────────────────────────
  void _startNav() {
    setState(() {
      _navigating = true;
      _showRoutes = false;
      _currentStep = 0;
    });
    if (_currentPos != null) {
      _mapCtrl?.animateCamera(CameraUpdate.newLatLngZoom(_g(_currentPos!), 17));
    }
    _posSub?.cancel();
    _posSub = LocationService.stream().listen((pos) {
      if (!mounted) return;
      setState(() => _currentPos = pos);
      _mapCtrl?.animateCamera(CameraUpdate.newLatLngZoom(_g(pos), 17));
      _maybeAdvanceStep(pos);
    });
  }

  void _stopNav() {
    _posSub?.cancel();
    _posSub = null;
    setState(() => _navigating = false);
  }

  void _maybeAdvanceStep(ll.LatLng pos) {
    final steps = _routes[_selectedRoute].steps;
    if (_currentStep >= steps.length - 1) return;
    final d = const ll.Distance()(pos, steps[_currentStep].location);
    if (d < 25) setState(() => _currentStep++);
  }

  // ── QUICK CALL EMERGENCY CONTACT ───────────
  Future<void> _showCallContacts() async {
    List<EmergencyContact> contacts = [];
    if (Session.userId != null) {
      try {
        contacts = await ApiService.getContacts(Session.userId!);
      } catch (_) {/* show empty state */}
    }
    if (!mounted) return;
    showModalBottomSheet(
      context: context,
      backgroundColor: kCard,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 14),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                  color: kBorder, borderRadius: BorderRadius.circular(4)),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(kPad, 14, kPad, 6),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('Call a contact',
                    style:
                        TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
              ),
            ),
            if (contacts.isEmpty)
              const Padding(
                padding: EdgeInsets.all(24),
                child: Text('No contacts yet. Add them in the Contacts tab.',
                    style: TextStyle(color: kTextMuted)),
              )
            else
              ...contacts.map((c) => ListTile(
                    leading: CircleAvatar(
                      backgroundColor: kPrimarySoft,
                      child: Text(
                        c.name.isNotEmpty ? c.name[0].toUpperCase() : '?',
                        style: const TextStyle(
                            color: kPrimary, fontWeight: FontWeight.w800),
                      ),
                    ),
                    title: Text(c.name,
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text(
                        '${c.relation.isEmpty ? "Contact" : c.relation} · ${c.phone}'),
                    trailing: const Icon(Icons.call, color: kSafe),
                    onTap: () {
                      Navigator.pop(ctx);
                      launchUrl(Uri.parse('tel:${c.phone}'),
                          mode: LaunchMode.externalApplication);
                    },
                  )),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  String _fmtDist(double m) =>
      m < 1000 ? '${m.round()} m' : '${(m / 1000).toStringAsFixed(1)} km';

  IconData _turnIcon(String instr) {
    final s = instr.toLowerCase();
    if (s.contains('arrive')) return Icons.flag_rounded;
    if (s.contains('roundabout')) return Icons.roundabout_right;
    if (s.contains('slight left')) return Icons.turn_slight_left;
    if (s.contains('slight right')) return Icons.turn_slight_right;
    if (s.contains('left')) return Icons.turn_left;
    if (s.contains('right')) return Icons.turn_right;
    if (s.contains('head') || s.contains('start')) return Icons.navigation_rounded;
    return Icons.straight;
  }

  // ── MAP OVERLAYS ───────────────────────────
  Set<Polyline> get _polylines {
    if (!_showRoutes && !_navigating) return {};
    final set = <Polyline>{};
    for (int i = _routes.length - 1; i >= 0; i--) {
      final selected = i == _selectedRoute;
      // while navigating, only draw the chosen route
      if (_navigating && !selected) continue;
      set.add(Polyline(
        polylineId: PolylineId('route_$i'),
        points: _routes[i].points.map(_g).toList(),
        width: selected ? 7 : 4,
        color: selected
            ? (_routes[i].level == SafetyLevel.safe
                ? kSafe
                : _routes[i].level == SafetyLevel.caution
                    ? kCaution
                    : kDanger)
            : kTextMuted.withValues(alpha: .4),
        consumeTapEvents: true,
        onTap: () => setState(() => _selectedRoute = i),
      ));
    }
    return set;
  }

  Set<Circle> get _circles => {
        for (int i = 0; i < _zones.length; i++)
          Circle(
            circleId: CircleId('danger_$i'),
            center: _g(_zones[i].center),
            radius: _zones[i].radiusMeters,
            fillColor: kDanger.withValues(alpha: .15),
            strokeColor: kDanger.withValues(alpha: .5),
            strokeWidth: 1,
          ),
      };

  Set<Marker> get _markers {
    final set = <Marker>{};
    if (_destPos != null) {
      set.add(Marker(
        markerId: const MarkerId('dest'),
        position: _g(_destPos!),
        infoWindow: const InfoWindow(title: 'Destination'),
      ));
    }
    for (int i = 0; i < _mapReports.length; i++) {
      final r = _mapReports[i];
      set.add(Marker(
        markerId: MarkerId('report_$i'),
        position: _g(r.location),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose),
        infoWindow: InfoWindow(title: r.type, snippet: r.area),
      ));
    }
    return set;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(kDefaultLat, kDefaultLng),
              zoom: 14,
            ),
            onMapCreated: (c) {
              _mapCtrl = c;
              if (_currentPos != null) {
                c.animateCamera(CameraUpdate.newLatLngZoom(_g(_currentPos!), 15));
              }
            },
            onTap: _onMapTap,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            polylines: _polylines,
            circles: _circles,
            markers: _markers,
          ),

          if (_locating)
            const Positioned(
              top: 0, left: 0, right: 0,
              child: LinearProgressIndicator(minHeight: 3, color: kPrimary),
            ),

          // top area: search + suggestions  (hidden while navigating)
          if (!_navigating)
            Positioned(
              top: MediaQuery.of(context).padding.top + 10,
              left: kPad,
              right: kPad,
              child: Column(
                children: [
                  _searchCard(),
                  if (_suggestions.isNotEmpty) _suggestionList(),
                ],
              ),
            ),

          // turn-by-turn banner while navigating
          if (_navigating) _navBanner(),

          // right-side actions (hidden while navigating)
          if (!_navigating)
            Positioned(
              right: kPad,
              bottom: _showRoutes ? 320 : 30,
              child: Column(
                children: [
                  _fab(Icons.my_location, 'Recenter', () {
                    if (_currentPos != null) {
                      _mapCtrl?.animateCamera(
                          CameraUpdate.newLatLngZoom(_g(_currentPos!), 15));
                    }
                  }, color: kPrimary),
                  const SizedBox(height: 12),
                  _fab(Icons.call, 'Call a contact', _showCallContacts,
                      color: kSafe),
                  const SizedBox(height: 12),
                  _fab(Icons.add_alert_rounded, 'Report', () {
                    Navigator.push(context,
                        MaterialPageRoute(
                            builder: (_) => const ReportIncidentScreen()));
                  }, color: kDanger),
                ],
              ),
            ),

          if (_showRoutes && !_navigating)
            Positioned(left: 0, right: 0, bottom: 0, child: _routeSheet()),

          // bottom nav bar while navigating
          if (_navigating)
            Positioned(left: 0, right: 0, bottom: 0, child: _navBottomBar()),
        ],
      ),
    );
  }

  // ── WIDGETS ────────────────────────────────
  Widget _searchCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.circular(kRadius),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: .08),
              blurRadius: 16,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.shield_moon_rounded, color: kPrimary),
              const SizedBox(width: 8),
              const Text('SafeRoute AI',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
              const Spacer(),
              SafetyBadge(
                level: SafetyLevel.safe,
                label: _currentPos != null ? 'GPS on' : 'GPS off',
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _fromCtrl,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.my_location, color: kSafe, size: 20),
              hintText: 'Starting point',
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _toCtrl,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.location_on, color: kDanger, size: 20),
              hintText: 'Search or tap the map…',
              suffixIcon: _toCtrl.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, size: 18),
                      onPressed: () {
                        _toCtrl.clear();
                        setState(() => _suggestions = []);
                      },
                    )
                  : null,
            ),
            onSubmitted: (_) => _findRoute(),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _searching ? null : _findRoute,
              icon: _searching
                  ? const SizedBox(
                      width: 18, height: 18,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white))
                  : const Icon(Icons.navigation_rounded, size: 18),
              label: Text(_searching ? 'Finding route…' : 'Find safest route'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _suggestionList() {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.circular(kRadius),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: .08), blurRadius: 14),
        ],
      ),
      child: Column(
        children: [
          for (final s in _suggestions)
            ListTile(
              dense: true,
              leading: const Icon(Icons.place_outlined, color: kPrimary),
              title: Text(s.title,
                  maxLines: 1, overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w600)),
              subtitle: s.subtitle.isEmpty
                  ? null
                  : Text(s.subtitle,
                      maxLines: 1, overflow: TextOverflow.ellipsis),
              onTap: () => _selectSuggestion(s),
            ),
        ],
      ),
    );
  }

  Widget _routeSheet() {
    return Container(
      padding: const EdgeInsets.fromLTRB(kPad, 14, kPad, 24),
      decoration: const BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40, height: 4,
            decoration: BoxDecoration(
                color: kBorder, borderRadius: BorderRadius.circular(4)),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              const Text('Route options',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
              const Spacer(),
              IconButton(
                onPressed: () => setState(() => _showRoutes = false),
                icon: const Icon(Icons.close, color: kTextMuted),
              ),
            ],
          ),
          for (int i = 0; i < _routes.length; i++) ...[
            RouteCard(
              route: _routes[i],
              selected: _selectedRoute == i,
              onTap: () => setState(() => _selectedRoute = i),
            ),
            const SizedBox(height: 10),
          ],
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _startNav,
              icon: const Icon(Icons.navigation_rounded),
              label: Text('Start "${_routes[_selectedRoute].label}"'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _navBanner() {
    final steps = _routes[_selectedRoute].steps;
    final step = steps.isNotEmpty && _currentStep < steps.length
        ? steps[_currentStep]
        : null;
    final distToTurn = (step != null && _currentPos != null)
        ? const ll.Distance()(_currentPos!, step.location)
        : 0.0;
    return Positioned(
      top: MediaQuery.of(context).padding.top + 10,
      left: kPad,
      right: kPad,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: kPrimary,
          borderRadius: BorderRadius.circular(kRadius),
          boxShadow: [
            BoxShadow(color: kPrimary.withValues(alpha: .35), blurRadius: 16),
          ],
        ),
        child: Row(
          children: [
            Icon(_turnIcon(step?.instruction ?? ''),
                color: Colors.white, size: 40),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (step != null)
                    Text(_fmtDist(distToTurn),
                        style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                            fontWeight: FontWeight.w600)),
                  Text(step?.instruction ?? 'Proceed to route',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _navBottomBar() {
    final r = _routes[_selectedRoute];
    return Container(
      padding: EdgeInsets.fromLTRB(
          kPad, 12, kPad, MediaQuery.of(context).padding.bottom + 12),
      decoration: const BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${r.minutes} min · ${r.km} km',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w700)),
              Text(r.label, style: const TextStyle(color: kTextMuted)),
            ],
          ),
          const Spacer(),
          OutlinedButton(
            onPressed: _showAllSteps,
            child: const Text('Steps'),
          ),
          const SizedBox(width: 8),
          ElevatedButton.icon(
            onPressed: _stopNav,
            style: ElevatedButton.styleFrom(backgroundColor: kDanger),
            icon: const Icon(Icons.close, size: 18),
            label: const Text('End'),
          ),
        ],
      ),
    );
  }

  void _showAllSteps() {
    final steps = _routes[_selectedRoute].steps;
    showModalBottomSheet(
      context: context,
      backgroundColor: kCard,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => ListView.separated(
        padding: const EdgeInsets.all(kPad),
        itemCount: steps.length,
        separatorBuilder: (_, __) => const Divider(height: 1, color: kBorder),
        itemBuilder: (_, i) => ListTile(
          leading: Icon(_turnIcon(steps[i].instruction), color: kPrimary),
          title: Text(steps[i].instruction),
          trailing: Text(_fmtDist(steps[i].meters),
              style: const TextStyle(color: kTextMuted, fontSize: 13)),
        ),
      ),
    );
  }

  Widget _fab(IconData icon, String tip, VoidCallback onTap,
      {required Color color}) {
    return Tooltip(
      message: tip,
      child: Material(
        color: kCard,
        shape: const CircleBorder(),
        elevation: 3,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Icon(icon, color: color, size: 24),
          ),
        ),
      ),
    );
  }
}
