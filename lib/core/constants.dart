import 'package:flutter/material.dart';

/// ─────────────────────────────────────────────
///  SafeRoute AI — global constants & theme
///  (k-prefixed shared constants pattern)
/// ─────────────────────────────────────────────

// Brand colours
const kPrimary = Color(0xFF6246EA);
const kPrimaryDark = Color(0xFF4B33C7);
const kPrimarySoft = Color(0xFFEDE9FE);

// Semantic / safety colours
const kSafe = Color(0xFF12A35A);
const kSafeSoft = Color(0xFFD9F4E6);
const kCaution = Color(0xFFF59E0B);
const kCautionSoft = Color(0xFFFDEFD6);
const kDanger = Color(0xFFE53E51);
const kDangerSoft = Color(0xFFFBE2E5);

// Neutrals
const kBg = Color(0xFFF6F6FB);
const kCard = Colors.white;
const kText = Color(0xFF181826);
const kTextMuted = Color(0xFF73738A);
const kBorder = Color(0xFFE7E7F0);

// Spacing
const kPad = 16.0;
const kRadius = 18.0;

// Map default centre (Chennai) — used until live GPS is wired
const kDefaultLat = 13.0827;
const kDefaultLng = 80.2707;

// ─────────────────────────────────────────────
//  ThemeData
// ─────────────────────────────────────────────
ThemeData buildAppTheme() {
  final base = ThemeData(useMaterial3: true);
  return base.copyWith(
    scaffoldBackgroundColor: kBg,
    colorScheme: ColorScheme.fromSeed(
      seedColor: kPrimary,
      primary: kPrimary,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: kBg,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: kText,
        fontSize: 20,
        fontWeight: FontWeight.w700,
      ),
      iconTheme: IconThemeData(color: kText),
    ),
    textTheme: base.textTheme.apply(
      bodyColor: kText,
      displayColor: kText,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: kPrimary,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: kCard,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      hintStyle: const TextStyle(color: kTextMuted),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: kBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: kBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: kPrimary, width: 1.5),
      ),
    ),
  );
}

// Reusable soft card decoration
BoxDecoration kCardDecoration({Color? color}) => BoxDecoration(
      color: color ?? kCard,
      borderRadius: BorderRadius.circular(kRadius),
      border: Border.all(color: kBorder),
    );
