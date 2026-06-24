import 'package:flutter/material.dart';
import '../core/constants.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About SafeRoute AI')),
      body: ListView(
        padding: const EdgeInsets.all(kPad),
        children: [
          Center(
            child: Column(
              children: [
                Container(
                  width: 84,
                  height: 84,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                        colors: [kPrimary, kPrimaryDark]),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Icon(Icons.shield_moon_rounded,
                      color: Colors.white, size: 46),
                ),
                const SizedBox(height: 14),
                const Text('SafeRoute AI',
                    style:
                        TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
                const Text('Version 1.0.0',
                    style: TextStyle(color: kTextMuted)),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _section('What it does',
              'SafeRoute AI helps you reach your destination safely — not just quickly. It compares routes by safety, warns you about risky areas, and gives you a fast way to call for help.'),
          _section('How routes are scored',
              'Each route is scored by how close it passes to reported incidents and risky zones. The safest route is highlighted in green, with quicker but less-safe options shown alongside.'),
          _section('Built with',
              'Maps by Google Maps. Routing and place search powered by the OpenStreetMap community (OSRM and Photon).'),
          _section('A note on safety',
              'This app is a helpful companion, not a replacement for emergency services. In a real emergency, always call 112 (India) or your local emergency number.'),
        ],
      ),
    );
  }

  Widget _section(String title, String body) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: kCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
          const SizedBox(height: 6),
          Text(body,
              style: const TextStyle(
                  fontSize: 13.5, color: kTextMuted, height: 1.4)),
        ],
      ),
    );
  }
}
