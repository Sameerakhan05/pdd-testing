import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../core/session.dart';
import '../core/api_service.dart';
import 'main_shell.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _email = TextEditingController();
  final _pass = TextEditingController();
  final _confirm = TextEditingController();
  bool _obscure = true;
  bool _loading = false;

  void _fail(String m) {
    if (!mounted) return;
    setState(() => _loading = false);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));
  }

  Future<void> _signup() async {
    if (_name.text.trim().isEmpty ||
        _email.text.trim().isEmpty ||
        _pass.text.isEmpty) {
      _fail('Please fill name, email and password');
      return;
    }
    if (_pass.text != _confirm.text) {
      _fail('Passwords do not match');
      return;
    }
    setState(() => _loading = true);
    try {
      final user = await ApiService.signup(
        name: _name.text.trim(),
        email: _email.text.trim(),
        password: _pass.text,
        confirmPassword: _confirm.text,
        phone: _phone.text.trim(),
      );
      Session.setUser(user);
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const MainShell()),
        (_) => false,
      );
    } on ApiException catch (e) {
      _fail(e.message);
    } catch (_) {
      _fail('Cannot reach server. Is the backend running?');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create account')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _name,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.person_outline, size: 20),
                hintText: 'Full name',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _phone,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.phone_outlined, size: 20),
                hintText: 'Phone number',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.mail_outline, size: 20),
                hintText: 'Email',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _pass,
              obscureText: _obscure,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.lock_outline, size: 20),
                hintText: 'Password',
                suffixIcon: IconButton(
                  icon: Icon(
                      _obscure ? Icons.visibility_off : Icons.visibility,
                      size: 20),
                  onPressed: () => setState(() => _obscure = !_obscure),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _confirm,
              obscureText: _obscure,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.lock_outline, size: 20),
                hintText: 'Confirm password',
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _loading ? null : _signup,
                child: _loading
                    ? const SizedBox(
                        width: 20, height: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white))
                    : const Text('Create account'),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Already have an account? ',
                    style: TextStyle(color: kTextMuted)),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Text('Log in',
                      style: TextStyle(
                          color: kPrimary, fontWeight: FontWeight.w700)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
