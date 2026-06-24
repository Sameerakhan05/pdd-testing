import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../core/constants.dart';
import '../core/session.dart';
import '../core/api_service.dart';
import '../core/mock_data.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});
  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  List<EmergencyContact> _contacts = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    if (Session.userId == null) {
      setState(() => _loading = false);
      return;
    }
    setState(() => _loading = true);
    try {
      final c = await ApiService.getContacts(Session.userId!);
      if (mounted) {
        setState(() {
          _contacts = c;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _loading = false);
        _snack('Could not load contacts');
      }
    }
  }

  void _snack(String m) => ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text(m)));

  void _addOrEdit({EmergencyContact? existing}) {
    final nameCtrl = TextEditingController(text: existing?.name);
    final phoneCtrl = TextEditingController(text: existing?.phone);
    final relCtrl = TextEditingController(text: existing?.relation);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: kCard,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: kPad,
          right: kPad,
          top: 20,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(existing == null ? 'Add contact' : 'Edit contact',
                style: const TextStyle(
                    fontSize: 17, fontWeight: FontWeight.w700)),
            const SizedBox(height: 16),
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.person, size: 20), hintText: 'Name'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: phoneCtrl,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.phone, size: 20),
                  hintText: 'Phone number'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: relCtrl,
              decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.group, size: 20),
                  hintText: 'Relation (e.g. Mother, Friend)'),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (nameCtrl.text.trim().isEmpty ||
                      phoneCtrl.text.trim().isEmpty) {
                    return;
                  }
                  Navigator.pop(ctx);
                  await _save(
                    existing: existing,
                    name: nameCtrl.text.trim(),
                    phone: phoneCtrl.text.trim(),
                    relation: relCtrl.text.trim(),
                  );
                },
                child: const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _save({
    EmergencyContact? existing,
    required String name,
    required String phone,
    required String relation,
  }) async {
    try {
      if (existing?.id != null) {
        await ApiService.updateContact(
            id: existing!.id!, name: name, phone: phone, relation: relation);
      } else {
        await ApiService.addContact(
            userId: Session.userId!,
            name: name,
            phone: phone,
            relation: relation);
      }
      await _load();
    } catch (e) {
      _snack('Could not save contact');
    }
  }

  Future<void> _delete(EmergencyContact c) async {
    if (c.id == null) return;
    try {
      await ApiService.deleteContact(c.id!);
      await _load();
    } catch (e) {
      _snack('Could not delete contact');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency Contacts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add, color: kPrimary),
            onPressed: () => _addOrEdit(),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _contacts.isEmpty
              ? const Center(
                  child: Text('No contacts yet. Add someone you trust.',
                      style: TextStyle(color: kTextMuted)))
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView.separated(
                    padding: const EdgeInsets.all(kPad),
                    itemCount: _contacts.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (_, i) {
                      final c = _contacts[i];
                      return Container(
                        padding: const EdgeInsets.all(12),
                        decoration: kCardDecoration(),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundColor: kPrimarySoft,
                              child: Text(
                                c.name.isNotEmpty
                                    ? c.name[0].toUpperCase()
                                    : '?',
                                style: const TextStyle(
                                    color: kPrimary,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 18),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(c.name,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 15)),
                                  Text(
                                      '${c.relation.isEmpty ? "Contact" : c.relation} · ${c.phone}',
                                      style: const TextStyle(
                                          color: kTextMuted, fontSize: 13)),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.call, color: kSafe),
                              onPressed: () => launchUrl(
                                  Uri.parse('tel:${c.phone}'),
                                  mode: LaunchMode.externalApplication),
                            ),
                            IconButton(
                              icon: const Icon(Icons.sms, color: kPrimary),
                              onPressed: () => launchUrl(
                                  Uri.parse('sms:${c.phone}'),
                                  mode: LaunchMode.externalApplication),
                            ),
                            PopupMenuButton<String>(
                              onSelected: (v) {
                                if (v == 'edit') {
                                  _addOrEdit(existing: c);
                                } else {
                                  _delete(c);
                                }
                              },
                              itemBuilder: (_) => const [
                                PopupMenuItem(
                                    value: 'edit', child: Text('Edit')),
                                PopupMenuItem(
                                    value: 'delete', child: Text('Delete')),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
