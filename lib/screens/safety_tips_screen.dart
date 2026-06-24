import 'package:flutter/material.dart';
import '../core/constants.dart';

class SafetyTipsScreen extends StatelessWidget {
  const SafetyTipsScreen({super.key});

  static const _tips = [
    (
      Icons.share_location,
      'Share your live location',
      'Before heading out, share your trip with a trusted contact so someone always knows where you are.'
    ),
    (
      Icons.lightbulb_outline,
      'Prefer well-lit, busy routes',
      'A slightly longer route through lit, populated areas is safer than a quick shortcut through quiet lanes.'
    ),
    (
      Icons.psychology_alt,
      'Trust your instincts',
      'If a place or person feels wrong, leave. You never owe anyone an explanation for keeping yourself safe.'
    ),
    (
      Icons.phone_in_talk,
      'Use the fake call',
      'A fake incoming call can help you exit an uncomfortable situation without confrontation.'
    ),
    (
      Icons.contacts,
      'Keep contacts updated',
      'Make sure your emergency contacts are people who can actually respond quickly when it matters.'
    ),
    (
      Icons.battery_charging_full,
      'Keep your phone charged',
      'Carry a power bank. A dead phone is the one thing that turns a scare into a crisis.'
    ),
    (
      Icons.directions_walk,
      'Walk with purpose',
      'Stay aware of your surroundings, keep your head up, and avoid being fully absorbed in your phone or headphones.'
    ),
    (
      Icons.local_police,
      'Know the helplines',
      'In India, 112 is the national emergency number and 1091 is the women’s helpline. Save them.'
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Safety tips')),
      body: ListView.separated(
        padding: const EdgeInsets.all(kPad),
        itemCount: _tips.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (_, i) {
          final (icon, title, body) = _tips[i];
          return Container(
            padding: const EdgeInsets.all(14),
            decoration: kCardDecoration(),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: kPrimarySoft,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: kPrimary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: const TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 15)),
                      const SizedBox(height: 4),
                      Text(body,
                          style: const TextStyle(
                              fontSize: 13.5, color: kTextMuted, height: 1.35)),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
