import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:oftamoloska_mobile/models/search_result.dart';
import 'package:oftamoloska_mobile/models/termin.dart';
import 'package:oftamoloska_mobile/providers/termini_provider.dart';

class DateTest extends StatefulWidget {
  const DateTest({super.key});

  @override
  State<DateTest> createState() => _DateTestState();
}

class _DateTestState extends State<DateTest> {
  DateTime? selectedDate;
  late TerminiProvider _terminiProvider;
  SearchResult<Termin>? terminiResult;
  int hour = 0;

  @override
  void initState() {
    super.initState();
    _terminiProvider = TerminiProvider();
  }

  Future<void> _fetchOcuppiedAppointments() async {
    try {
      var data = await _terminiProvider.get(filter: {
        'datum': selectedDate!.toIso8601String(),
      });

      setState(() {
        terminiResult = data;
      });
    } catch (e) {
      print(e);
    }
  }

  bool isOcuppiedHour(int h) {
    if (terminiResult == null || terminiResult!.result.isEmpty) {
      return false; 
    }

    for (int i = 0; i < terminiResult!.result.length; i++) {
      if (terminiResult!.result[i].datum!.hour == h) {
        return true; 
      }
    }

    return false;
  }

  bool isPastDate(DateTime datetime) {
    DateTime currentDate = DateTime.now();
    if (datetime.year < currentDate.year) {
      return true;
    }
    if (datetime.year == currentDate.year &&
        datetime.month < currentDate.month) {
      return true;
    }
    if (datetime.year == currentDate.year &&
        datetime.month == currentDate.month &&
        datetime.day <= currentDate.day) {
      return true;
    }

    return false;
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) async {
    setState(() {
      if (args.value is DateTime) {
        selectedDate = args.value;
      }
    });
    await _fetchOcuppiedAppointments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Appointment"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Calendar Section
          Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: SfDateRangePicker(
              onSelectionChanged: _onSelectionChanged,
              selectionMode: DateRangePickerSelectionMode.single,
              selectionColor: Theme.of(context).primaryColor,
              todayHighlightColor: Theme.of(context).primaryColor,
            ),
          ),

          // Time Slots Section
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
                    child: Row(
                      children: [
                        Text(
                          selectedDate == null 
                              ? 'Select a date'
                              : 'Available time slots',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (selectedDate == null || isPastDate(selectedDate!))
                    Expanded(
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.calendar_today,
                              size: 48,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              selectedDate == null
                                  ? 'Please select a date first'
                                  : 'Cannot book appointments in the past',
                              style: TextStyle(
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                        itemCount: 13,
                        itemBuilder: (context, index) {
                          final currentHour = index + 8;
                          final isOccupied = isOcuppiedHour(currentHour);

                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 2,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(8),
                              onTap: isOccupied
                                  ? null
                                  : () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            AlertDialog(
                                          title: const Text("Confirm Appointment"),
                                          content: Text(
                                            "Appointment on ${DateFormat('dd/MM/yyyy').format(selectedDate!)} at ${currentHour}:00",
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: (() {
                                                Navigator.pop(context);
                                              }),
                                              child: const Text("Cancel"),
                                            ),
                                            TextButton(
                                              onPressed: () async {
                                                try {
                                                  selectedDate = DateTime(
                                                    selectedDate!.year,
                                                    selectedDate!.month,
                                                    selectedDate!.day,
                                                    currentHour,
                                                  );
                                                  Navigator.pop(context);
                                                  Navigator.pop(
                                                      context, selectedDate);
                                                } catch (e) {
                                                  print(e.toString());
                                                }
                                              },
                                              child: const Text('Confirm'),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "${currentHour}:00",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: isOccupied
                                            ? Colors.red
                                            : Colors.green,
                                      ),
                                    ),
                                    if (isOccupied)
                                      Text(
                                        "Unavailable",
                                        style: TextStyle(
                                          color: Colors.red[400],
                                          fontStyle: FontStyle.italic,
                                        ),
                                      )
                                    else
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        size: 16,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}