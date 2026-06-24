import 'package:flutter/material.dart';
import '../core/constants.dart';
import 'map_screen.dart';
import 'reports_screen.dart';
import 'contacts_screen.dart';
import 'settings_screen.dart';
import 'emergency_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});
  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  final _tabs = const [
    MapScreen(),
    ReportsScreen(),
    SizedBox(), // placeholder for SOS slot
    ContactsScreen(),
    SettingsScreen(),
  ];

  void _openSos() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const EmergencyScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _tabs),
      bottomNavigationBar: _buildNav(),
    );
  }

  Widget _buildNav() {
    return Container(
      decoration: const BoxDecoration(
        color: kCard,
        border: Border(top: BorderSide(color: kBorder)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            children: [
              _navItem(0, Icons.map_rounded, 'Map'),
              _navItem(1, Icons.warning_amber_rounded, 'Reports'),
              _sosButton(),
              _navItem(3, Icons.contacts_rounded, 'Contacts'),
              _navItem(4, Icons.settings_rounded, 'More'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(int i, IconData icon, String label) {
    final active = _index == i;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _index = i),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: active ? kPrimary : kTextMuted, size: 24),
            const SizedBox(height: 3),
            Text(label,
                style: TextStyle(
                    fontSize: 11,
                    color: active ? kPrimary : kTextMuted,
                    fontWeight: active ? FontWeight.w700 : FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  Widget _sosButton() {
    return Expanded(
      child: Center(
        child: GestureDetector(
          onTap: _openSos,
          child: Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFF5A6E), kDanger],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: kDanger.withValues(alpha: .4),
                  blurRadius: 14,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.sos_rounded, color: Colors.white, size: 22),
                Text('SOS',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w800)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
