import 'package:flutter/material.dart';
import 'core/constants.dart';
import 'screens/splash_screen.dart';

void main() => runApp(const SafeRouteApp());

class SafeRouteApp extends StatelessWidget {
  const SafeRouteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SafeRoute AI',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: const SplashScreen(),
    );
  }
}
