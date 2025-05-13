import 'package:flutter/material.dart';
import 'package:oftamoloska_desktop/models/termin.dart';
import 'package:intl/intl.dart';
import 'package:oftamoloska_desktop/providers/termini_provider.dart';
import 'package:oftamoloska_desktop/screens/termin_detail_screen.dart';
import '../utils/util.dart';

class TerminiScreen extends StatefulWidget {
  const TerminiScreen({Key? key}) : super(key: key);

  @override
  State<TerminiScreen> createState() => _TerminiScreenState();
}

class _TerminiScreenState extends State<TerminiScreen> {
  final TerminiProvider _terminiProvider = TerminiProvider();
  List<Termin> _termini = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTermini();
  }

  Future<void> _loadTermini() async {
    try {
      final result = await _terminiProvider.get(filter: {
        'doktor': Authorization.username,
      });
      setState(() {
        _termini = result.result;
        _isLoading = false;
      });
    } catch (e) {
      print(e);
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointments'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _termini.isEmpty
              ? const Center(child: Text('No appointments found.'))
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: _termini.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (ctx, i) => _buildCard(_termini[i]),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateDetail(null),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildCard(Termin t) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Dr: ${t.korisnikIdDoktor}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text('Patient: ${t.korisnikIdPacijent}'),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('dd.MM.yyyy – HH:mm').format(t.datum!),
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            IconButton(
              tooltip: 'Edit',
              icon: const Icon(Icons.edit, color: Colors.blueGrey),
              onPressed: () => _navigateDetail(t),
            ),
            IconButton(
              tooltip: 'Mark Complete',
              icon: const Icon(Icons.check_circle, color: Colors.green),
              onPressed: () => _confirmDelete(t),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateDetail(Termin? t) async {
    final modified = await Navigator.of(context).push<Termin>(
      MaterialPageRoute(
        builder: (_) => TerminDetailScreen(
          termin: t,
          selectedPatient: t?.korisnikIdPacijent,
        ),
      ),
    );
    if (modified != null) {
      setState(() {
        final idx = _termini.indexWhere((x) => x.terminId == modified.terminId);
        if (idx != -1) {
          _termini[idx] = modified;
        } else {
          _termini.add(modified);
        }
      });
    }
  }

  void _confirmDelete(Termin t) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Complete Appointment?'),
        content: const Text('Mark this appointment as completed (and remove)?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteTermin(t);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Complete'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteTermin(Termin t) async {
    try {
      await _terminiProvider.delete(t.terminId);
      setState(() => _termini.removeWhere((x) => x.terminId == t.terminId));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Appointment completed.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to complete appointment.')),
      );
    }
  }
}
