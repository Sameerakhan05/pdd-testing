import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../core/session.dart';
import '../core/api_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final _name = TextEditingController(text: Session.name);
  late final _phone = TextEditingController(text: Session.phone);
  bool _saving = false;

  Future<void> _save() async {
    if (_name.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Name cannot be empty')),
      );
      return;
    }
    if (Session.userId == null) return;
    setState(() => _saving = true);
    try {
      final user = await ApiService.updateProfile(
        userId: Session.userId!,
        name: _name.text.trim(),
        phone: _phone.text.trim(),
      );
      Session.setUser(user);
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Profile updated')));
      Navigator.pop(context, true);
    } on ApiException catch (e) {
      _fail(e.message);
    } catch (_) {
      _fail('Cannot reach server.');
    }
  }

  void _fail(String m) {
    if (!mounted) return;
    setState(() => _saving = false);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit profile')),
      body: ListView(
        padding: const EdgeInsets.all(kPad),
        children: [
          Center(
            child: CircleAvatar(
              radius: 44,
              backgroundColor: kPrimarySoft,
              child: Text(
                _name.text.isNotEmpty ? _name.text[0].toUpperCase() : '?',
                style: const TextStyle(
                    color: kPrimary, fontSize: 34, fontWeight: FontWeight.w800),
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text('Name', style: TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          TextField(
            controller: _name,
            onChanged: (_) => setState(() {}),
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.person_outline, size: 20),
              hintText: 'Your name',
            ),
          ),
          const SizedBox(height: 16),
          const Text('Phone', style: TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          TextField(
            controller: _phone,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.phone_outlined, size: 20),
              hintText: 'Phone number',
            ),
          ),
          const SizedBox(height: 28),
          ElevatedButton.icon(
            onPressed: _saving ? null : _save,
            icon: _saving
                ? const SizedBox(
                    width: 18, height: 18,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white))
                : const Icon(Icons.check, size: 18),
            label: Text(_saving ? 'Saving…' : 'Save changes'),
          ),
        ],
      ),
    );
  }
}
