import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../core/constants.dart';
import '../core/alarm_service.dart';
import '../core/session.dart';
import '../core/api_service.dart';
import '../core/location_service.dart';
import '../core/mock_data.dart';

class EmergencyScreen extends StatefulWidget {
  const EmergencyScreen({super.key});
  @override
  State<EmergencyScreen> createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;
  bool _active = false;
  List<EmergencyContact> _contacts = [];

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..repeat(reverse: true);
    _loadContacts();
  }

  Future<void> _loadContacts() async {
    if (Session.userId == null) return;
    try {
      final c = await ApiService.getContacts(Session.userId!);
      if (mounted) setState(() => _contacts = c);
    } catch (_) {/* keep empty on failure */}
  }

  @override
  void dispose() {
    _pulse.dispose();
    AlarmService.stop();
    super.dispose();
  }

  Future<void> _trigger() async {
    setState(() => _active = true);
    await AlarmService.start();
    // log the SOS with current location (fire-and-forget)
    final pos = await LocationService.getCurrent();
    if (pos != null) {
      ApiService.sendSos(
          userId: Session.userId, lat: pos.latitude, lng: pos.longitude);
    }
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: kDanger,
          content: Text(
              'Alert logged with your location · ${_contacts.length} contact(s) ready'),
        ),
      );
    }
  }

  Future<void> _stop() async {
    await AlarmService.stop();
    setState(() => _active = false);
  }

  Future<void> _callFirst() async {
    if (_contacts.isEmpty) return;
    await launchUrl(Uri.parse('tel:${_contacts.first.phone}'),
        mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final bg = _active ? kDanger : kBg;
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        iconTheme: IconThemeData(color: _active ? Colors.white : kText),
        title: Text('Emergency',
            style: TextStyle(color: _active ? Colors.white : kText)),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(kPad),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Text(
                _active
                    ? 'ALARM ACTIVE'
                    : 'Press & hold in danger',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: _active ? Colors.white : kText),
              ),
              const SizedBox(height: 6),
              Text(
                _active
                    ? 'Buzzer on · contacts alerted'
                    : 'Triggers a loud buzzer and alerts your contacts',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: _active ? Colors.white70 : kTextMuted),
              ),
              const Spacer(),
              GestureDetector(
                onTap: _active ? _stop : _trigger,
                child: AnimatedBuilder(
                  animation: _pulse,
                  builder: (_, child) {
                    final scale = _active ? 1 + _pulse.value * .08 : 1.0;
                    return Transform.scale(scale: scale, child: child);
                  },
                  child: Container(
                    width: 220,
                    height: 220,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _active ? Colors.white : kDanger,
                      boxShadow: [
                        BoxShadow(
                          color: (_active ? Colors.white : kDanger)
                              .withValues(alpha: .4),
                          blurRadius: 40,
                          spreadRadius: 6,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _active ? Icons.stop_rounded : Icons.sos_rounded,
                          size: 64,
                          color: _active ? kDanger : Colors.white,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _active ? 'TAP TO STOP' : 'SOS',
                          style: TextStyle(
                              fontSize: _active ? 16 : 30,
                              fontWeight: FontWeight.w900,
                              color: _active ? kDanger : Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const Spacer(),
              if (_contacts.isNotEmpty)
                _quickAction(
                  icon: Icons.call,
                  label: 'Call ${_contacts.first.name}',
                  onTap: _callFirst,
                ),
              const SizedBox(height: 12),
              _quickAction(
                icon: Icons.local_police,
                label: 'Call Police — 112',
                onTap: () => launchUrl(Uri.parse('tel:112'),
                    mode: LaunchMode.externalApplication),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _quickAction({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, color: _active ? Colors.white : kPrimary),
        label: Text(label,
            style: TextStyle(
                color: _active ? Colors.white : kText,
                fontWeight: FontWeight.w600)),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 15),
          side: BorderSide(color: _active ? Colors.white54 : kBorder),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14)),
        ),
      ),
    );
  }
}
