import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../core/mock_data.dart';
import '../core/api_service.dart';
import 'report_incident_screen.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});
  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  String _filter = 'All';
  List<IncidentReport> _reports = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final r = await ApiService.getReports();
      if (mounted) {
        setState(() {
          _reports = r;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  String _timeAgo(DateTime t) {
    final d = DateTime.now().difference(t);
    if (d.inMinutes < 1) return 'just now';
    if (d.inMinutes < 60) return '${d.inMinutes}m ago';
    if (d.inHours < 24) return '${d.inHours}h ago';
    return '${d.inDays}d ago';
  }

  IconData _icon(String type) {
    switch (type) {
      case 'Harassment':
        return Icons.report_gmailerrorred;
      case 'Stalking':
        return Icons.directions_walk;
      case 'Poor lighting':
        return Icons.lightbulb_outline;
      case 'Theft':
        return Icons.lock_outline;
      default:
        return Icons.warning_amber_rounded;
    }
  }

  Future<void> _openReportForm() async {
    final added = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ReportIncidentScreen()),
    );
    if (added == true) {
      _load();
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filter == 'All'
        ? _reports
        : _reports.where((r) => r.type == _filter).toList();
    final chips = ['All', ...kReportTypes.where((t) => t != 'Other')];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Community Reports'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle, color: kPrimary),
            onPressed: _openReportForm,
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: kPad),
              itemCount: chips.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final c = chips[i];
                final sel = c == _filter;
                return ChoiceChip(
                  label: Text(c),
                  selected: sel,
                  onSelected: (_) => setState(() => _filter = c),
                  selectedColor: kPrimary,
                  backgroundColor: kCard,
                  side: const BorderSide(color: kBorder),
                  labelStyle: TextStyle(
                      color: sel ? Colors.white : kText,
                      fontWeight: FontWeight.w600),
                );
              },
            ),
          ),
          const SizedBox(height: 6),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : filtered.isEmpty
                    ? const Center(
                        child: Text('No reports yet.',
                            style: TextStyle(color: kTextMuted)))
                    : RefreshIndicator(
                        onRefresh: _load,
                        child: ListView.separated(
                          padding: const EdgeInsets.all(kPad),
                          itemCount: filtered.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 12),
                          itemBuilder: (_, i) {
                            final r = filtered[i];
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
                                      color: kDangerSoft,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(_icon(r.type), color: kDanger),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(r.type,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 15)),
                                            ),
                                            Text(_timeAgo(r.time),
                                                style: const TextStyle(
                                                    color: kTextMuted,
                                                    fontSize: 12)),
                                          ],
                                        ),
                                        const SizedBox(height: 2),
                                        if (r.area.isNotEmpty)
                                          Row(
                                            children: [
                                              const Icon(Icons.place,
                                                  size: 13, color: kTextMuted),
                                              const SizedBox(width: 3),
                                              Expanded(
                                                child: Text(r.area,
                                                    style: const TextStyle(
                                                        color: kTextMuted,
                                                        fontSize: 12.5)),
                                              ),
                                            ],
                                          ),
                                        if (r.note.isNotEmpty) ...[
                                          const SizedBox(height: 6),
                                          Text(r.note,
                                              style: const TextStyle(
                                                  fontSize: 13.5)),
                                        ],
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}
