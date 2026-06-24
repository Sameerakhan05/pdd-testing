import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../core/session.dart';
import 'fake_call_screen.dart';
import 'profile_screen.dart';
import 'safety_tips_screen.dart';
import 'about_screen.dart';
import 'login_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _liveTracking = true;
  bool _voiceTrigger = false;
  bool _nightAlerts = true;

  String _name = '';

  @override
  void initState() {
    super.initState();
    _name = Session.name.isEmpty ? 'You' : Session.name;
  }

  Future<void> _openProfile() async {
    final changed = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ProfileScreen()),
    );
    if (changed == true && mounted) {
      setState(() => _name = Session.name.isEmpty ? 'You' : Session.name);
    }
  }

  Future<void> _logout() async {
    await Session.clear();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('More')),
      body: ListView(
        padding: const EdgeInsets.all(kPad),
        children: [
          // profile card (tappable → edit)
          InkWell(
            onTap: _openProfile,
            borderRadius: BorderRadius.circular(kRadius),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient:
                    const LinearGradient(colors: [kPrimary, kPrimaryDark]),
                borderRadius: BorderRadius.circular(kRadius),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.white24,
                    child: Text(
                      _name.isNotEmpty ? _name[0].toUpperCase() : '?',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w800),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_name,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w700)),
                        Text('Tap to edit profile',
                            style: TextStyle(
                                color: Colors.white.withValues(alpha: .85),
                                fontSize: 13)),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: Colors.white),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text('Safety preferences',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
          const SizedBox(height: 10),
          _toggle('Live location tracking', 'Share location during trips',
              Icons.location_on, _liveTracking,
              (v) => setState(() => _liveTracking = v)),
          _toggle('Voice trigger', 'Say a keyword to start SOS', Icons.mic,
              _voiceTrigger, (v) => setState(() => _voiceTrigger = v)),
          _toggle('Night-time alerts', 'Warn near risky areas after dark',
              Icons.nightlight, _nightAlerts,
              (v) => setState(() => _nightAlerts = v)),
          const SizedBox(height: 20),
          const Text('Tools',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
          const SizedBox(height: 10),
          _tile(Icons.phone_in_talk, 'Trigger fake call', () {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => const FakeCallScreen()));
          }),
          _tile(Icons.shield, 'Safety tips', () {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => const SafetyTipsScreen()));
          }),
          _tile(Icons.info_outline, 'About SafeRoute AI', () {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => const AboutScreen()));
          }),
          const SizedBox(height: 10),
          _tile(Icons.logout, 'Log out', _logout, danger: true),
        ],
      ),
    );
  }

  Widget _toggle(String title, String sub, IconData icon, bool val,
      ValueChanged<bool> onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: kCardDecoration(),
      child: SwitchListTile(
        value: val,
        onChanged: onChanged,
        activeThumbColor: kPrimary,
        secondary: Icon(icon, color: kPrimary),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(sub, style: const TextStyle(fontSize: 12.5)),
      ),
    );
  }

  Widget _tile(IconData icon, String title, VoidCallback onTap,
      {bool danger = false}) {
    final c = danger ? kDanger : kPrimary;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: kCardDecoration(),
      child: ListTile(
        leading: Icon(icon, color: c),
        title: Text(title,
            style: TextStyle(
                fontWeight: FontWeight.w600, color: danger ? kDanger : kText)),
        trailing: const Icon(Icons.chevron_right, color: kTextMuted),
        onTap: onTap,
      ),
    );
  }
}
