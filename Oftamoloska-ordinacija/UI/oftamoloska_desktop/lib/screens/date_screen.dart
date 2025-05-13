import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/SearchResult.dart';
import '../models/termin.dart';
import '../providers/termini_provider.dart';

class DateTest extends StatefulWidget {
  const DateTest({super.key});
  @override
  State<DateTest> createState() => _DateTestState();
}

class _DateTestState extends State<DateTest> {
  DateTime _focusedDate = DateTime.now();
  DateTime? _pickedDate;
  late TerminiProvider _terminiProvider;
  SearchResult<Termin>? _occupied;
  int? _selectedHour;

  @override
  void initState() {
    super.initState();
    _terminiProvider = TerminiProvider();
  }

  Future<void> _loadOccupied(DateTime day) async {
    final res = await _terminiProvider.get(filter: {'datum': day.toIso8601String()});
    setState(() => _occupied = res);
  }

  bool _isOccupied(int h) {
    return _occupied?.result.any((t) => t.datum!.hour == h) ?? false;
  }

  void _onDatePicked(DateTime date) {
    setState(() {
      _pickedDate = date;
      _selectedHour = null;
    });
    _loadOccupied(date);
  }

  void _onHourTap(int h) async {
    if (_isOccupied(h)) return;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirm'),
        content: Text('Book ${h.toString().padLeft(2,'0')}:00 on '
            '${DateFormat('dd.MM.yyyy').format(_pickedDate!)}?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context,false), child: const Text('No')),
          TextButton(onPressed: () => Navigator.pop(context,true), child: const Text('Yes')),
        ],
      ),
    );
    if (confirm == true) {
      final dt = DateTime(
        _pickedDate!.year,
        _pickedDate!.month,
        _pickedDate!.day,
        h,
      );
      Navigator.pop(context, dt);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Appointment'),
      ),
      body: Column(
        children: [
          // Standard calendar picker
          CalendarDatePicker(
            initialDate: _focusedDate,
            firstDate: DateTime.now(),
            lastDate: DateTime.now().add(const Duration(days: 365)),
            onDateChanged: _onDatePicked,
          ),
          // Show chosen date
          if (_pickedDate != null) ...[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'Slots for ${DateFormat('dd.MM.yyyy').format(_pickedDate!)}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            // Horizontal chips
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: 13,
                itemBuilder: (_, i) {
                  final hour = 8 + i;
                  final occupied = _isOccupied(hour);
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text('${hour.toString().padLeft(2,'0')}:00'),
                      selected: _selectedHour == hour,
                      onSelected: occupied
                          ? null
                          : (sel) {
                              setState(() => _selectedHour = hour);
                            },
                      selectedColor: Colors.green.shade300,
                      disabledColor: Colors.red.shade200,
                      backgroundColor: Colors.grey.shade200,
                    ),
                  );
                },
              ),
            ),
            const Spacer(),
            // Save button
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: (_pickedDate != null && _selectedHour != null)
                    ? () {
                        final dt = DateTime(
                          _pickedDate!.year,
                          _pickedDate!.month,
                          _pickedDate!.day,
                          _selectedHour!,
                        );
                        Navigator.pop(context, dt);
                      }
                    : null,
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  child: Text('Save Appointment'),
                ),
              ),
            ),
          ] else
            const Expanded(
              child: Center(child: Text('Please pick a date above')),
            ),
        ],
      ),
    );
  }
}
