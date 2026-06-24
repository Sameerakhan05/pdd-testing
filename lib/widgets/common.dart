import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../core/mock_data.dart';

/// Coloured pill showing a safety level.
class SafetyBadge extends StatelessWidget {
  final SafetyLevel level;
  final String? label;
  const SafetyBadge({super.key, required this.level, this.label});

  @override
  Widget build(BuildContext context) {
    late Color fg, bg;
    late String text;
    switch (level) {
      case SafetyLevel.safe:
        fg = kSafe;
        bg = kSafeSoft;
        text = label ?? 'Safe';
        break;
      case SafetyLevel.caution:
        fg = kCaution;
        bg = kCautionSoft;
        text = label ?? 'Caution';
        break;
      case SafetyLevel.danger:
        fg = kDanger;
        bg = kDangerSoft;
        text = label ?? 'Risky';
        break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.circle, size: 8, color: fg),
          const SizedBox(width: 6),
          Text(text,
              style: TextStyle(
                  color: fg, fontWeight: FontWeight.w700, fontSize: 12.5)),
        ],
      ),
    );
  }
}

/// Card summarising a route option.
class RouteCard extends StatelessWidget {
  final RouteOption route;
  final bool selected;
  final VoidCallback onTap;
  const RouteCard({
    super.key,
    required this.route,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scoreColor = route.safetyScore >= 75
        ? kSafe
        : route.safetyScore >= 50
            ? kCaution
            : kDanger;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(kRadius),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected ? kPrimarySoft : kCard,
          borderRadius: BorderRadius.circular(kRadius),
          border: Border.all(
            color: selected ? kPrimary : kBorder,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: scoreColor.withValues(alpha: .12),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text('${route.safetyScore}',
                  style: TextStyle(
                      color: scoreColor,
                      fontWeight: FontWeight.w800,
                      fontSize: 16)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(route.label,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 15)),
                  const SizedBox(height: 4),
                  Text('${route.minutes} min · ${route.km} km',
                      style: const TextStyle(
                          color: kTextMuted, fontSize: 13)),
                ],
              ),
            ),
            SafetyBadge(level: route.level),
          ],
        ),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  final String? action;
  final VoidCallback? onAction;
  const SectionHeader(this.title, {super.key, this.action, this.onAction});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
        if (action != null)
          TextButton(
            onPressed: onAction,
            child: Text(action!,
                style: const TextStyle(
                    color: kPrimary, fontWeight: FontWeight.w600)),
          ),
      ],
    );
  }
}
