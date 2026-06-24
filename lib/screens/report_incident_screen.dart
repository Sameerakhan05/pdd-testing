import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../core/mock_data.dart';
import '../core/session.dart';
import '../core/api_service.dart';
import '../core/location_service.dart';

class ReportIncidentScreen extends StatefulWidget {
  const ReportIncidentScreen({super.key});
  @override
  State<ReportIncidentScreen> createState() => _ReportIncidentScreenState();
}

class _ReportIncidentScreenState extends State<ReportIncidentScreen> {
  String _type = kReportTypes.first;
  final _areaCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();
  bool _anonymous = true;
  bool _submitting = false;

  Future<void> _submit() async {
    if (_areaCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add the area / landmark')),
      );
      return;
    }
    setState(() => _submitting = true);

    // attach current location (falls back to default centre if GPS off)
    final pos = await LocationService.getCurrent();
    final lat = pos?.latitude ?? kDefaultLat;
    final lng = pos?.longitude ?? kDefaultLng;

    try {
      await ApiService.addReport(
        userId: _anonymous ? null : Session.userId,
        type: _type,
        area: _areaCtrl.text.trim(),
        note: _noteCtrl.text.trim(),
        lat: lat,
        lng: lng,
        anonymous: _anonymous,
      );
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          icon: const Icon(Icons.check_circle, color: kSafe, size: 48),
          title: const Text('Report submitted'),
          content: const Text(
              'Thanks for helping keep others safe. This area will now factor into route safety scores.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // dialog
                Navigator.pop(context, true); // screen → signal refresh
              },
              child: const Text('Done'),
            ),
          ],
        ),
      );
    } on ApiException catch (e) {
      _fail(e.message);
    } catch (_) {
      _fail('Cannot reach server. Is the backend running?');
    }
  }

  void _fail(String m) {
    if (!mounted) return;
    setState(() => _submitting = false);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Report an incident')),
      body: ListView(
        padding: const EdgeInsets.all(kPad),
        children: [
          const Text('Incident type',
              style: TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: kReportTypes.map((t) {
              final sel = t == _type;
              return ChoiceChip(
                label: Text(t),
                selected: sel,
                onSelected: (_) => setState(() => _type = t),
                selectedColor: kPrimary,
                backgroundColor: kCard,
                side: const BorderSide(color: kBorder),
                labelStyle: TextStyle(
                    color: sel ? Colors.white : kText,
                    fontWeight: FontWeight.w600),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          const Text('Area / landmark',
              style: TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          TextField(
            controller: _areaCtrl,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.place, color: kPrimary, size: 20),
              hintText: 'e.g. Near Anna Nagar metro exit',
            ),
          ),
          const SizedBox(height: 16),
          const Text('What happened?',
              style: TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          TextField(
            controller: _noteCtrl,
            maxLines: 4,
            decoration: const InputDecoration(
              hintText: 'Describe briefly (optional)',
            ),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: kCardDecoration(),
            child: SwitchListTile(
              value: _anonymous,
              onChanged: (v) => setState(() => _anonymous = v),
              activeThumbColor: kPrimary,
              title: const Text('Report anonymously',
                  style: TextStyle(fontWeight: FontWeight.w600)),
              subtitle: const Text('Your name won’t be linked to this report'),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: kCardDecoration(color: kPrimarySoft),
            child: const Row(
              children: [
                Icon(Icons.info_outline, color: kPrimary, size: 20),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                      'Your current location is attached so nearby routes can be adjusted.',
                      style: TextStyle(fontSize: 12.5, color: kPrimaryDark)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: _submitting ? null : _submit,
            icon: _submitting
                ? const SizedBox(
                    width: 18, height: 18,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white))
                : const Icon(Icons.send_rounded, size: 18),
            label: Text(_submitting ? 'Submitting…' : 'Submit report'),
          ),
        ],
      ),
    );
  }
}
