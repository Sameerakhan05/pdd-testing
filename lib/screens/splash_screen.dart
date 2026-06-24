import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../core/session.dart';
import 'main_shell.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _go();
  }

  Future<void> _go() async {
    await Session.restore();
    await Future.delayed(const Duration(milliseconds: 1500));
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => Session.isLoggedIn ? const MainShell() : const LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [kPrimary, kPrimaryDark],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: .15),
                  borderRadius: BorderRadius.circular(28),
                ),
                child: const Icon(Icons.shield_moon_rounded,
                    color: Colors.white, size: 54),
              ),
              const SizedBox(height: 22),
              const Text('SafeRoute AI',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              Text('Reach safely, not just quickly',
                  style: TextStyle(
                      color: Colors.white.withValues(alpha: .8), fontSize: 14)),
              const SizedBox(height: 40),
              const SizedBox(
                width: 26,
                height: 26,
                child: CircularProgressIndicator(
                    color: Colors.white, strokeWidth: 2.4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
