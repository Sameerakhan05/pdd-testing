import 'package:flutter/material.dart';
import '../core/constants.dart';

class FakeCallScreen extends StatefulWidget {
  const FakeCallScreen({super.key});
  @override
  State<FakeCallScreen> createState() => _FakeCallScreenState();
}

class _FakeCallScreenState extends State<FakeCallScreen> {
  bool _ringing = true;
  bool _accepted = false;
  int _seconds = 0;

  @override
  void initState() {
    super.initState();
    _tick();
  }

  void _tick() async {
    while (mounted && _accepted) {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) setState(() => _seconds++);
    }
  }

  String get _timer {
    final m = (_seconds ~/ 60).toString().padLeft(2, '0');
    final s = (_seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF14131A),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 60),
            const CircleAvatar(
              radius: 56,
              backgroundColor: kPrimary,
              child: Icon(Icons.person, size: 60, color: Colors.white),
            ),
            const SizedBox(height: 20),
            const Text('Appa',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            Text(
              _accepted ? _timer : (_ringing ? 'Incoming call…' : 'Calling…'),
              style: const TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const Spacer(),
            if (_accepted)
              Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: _circleBtn(Icons.call_end, kDanger,
                    () => Navigator.pop(context)),
              )
            else
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        _circleBtn(Icons.call_end, kDanger,
                            () => Navigator.pop(context)),
                        const SizedBox(height: 8),
                        const Text('Decline',
                            style: TextStyle(color: Colors.white70)),
                      ],
                    ),
                    Column(
                      children: [
                        _circleBtn(Icons.call, kSafe, () {
                          setState(() {
                            _accepted = true;
                            _ringing = false;
                          });
                          _tick();
                        }),
                        const SizedBox(height: 8),
                        const Text('Accept',
                            style: TextStyle(color: Colors.white70)),
                      ],
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _circleBtn(IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        child: Icon(icon, color: Colors.white, size: 30),
      ),
    );
  }
}
