import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:oftamoloska_mobile/models/termin.dart';
import 'package:oftamoloska_mobile/providers/korisnik_provider.dart';
import 'package:oftamoloska_mobile/providers/termini_provider.dart';
import 'package:oftamoloska_mobile/screens/termin_detail_screen.dart';
import 'package:oftamoloska_mobile/screens/termin_info_screen.dart';
import '../models/korisnik.dart';
import '../utils/util.dart';

class TerminiScreen extends StatefulWidget {
  const TerminiScreen({Key? key}) : super(key: key);

  @override
  _TerminiScreenState createState() => _TerminiScreenState();
}

class _TerminiScreenState extends State<TerminiScreen> {
  final TerminiProvider _terminiProvider = TerminiProvider();
  final KorisniciProvider _korisniciProvider = KorisniciProvider();
  List<Termin> _termini = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTermini();
  }

  Future<void> _fetchTermini() async {
    try {
      var result = await _terminiProvider.get(
        filter: {
          'pacijent': Authorization.username.toString(),
        },
      );
      setState(() {
        _termini = result.result;
        isLoading = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<Korisnik?> _fetchKorisnik(int? korisnikId) async {
    if (korisnikId == null) return null;
    try {
      return await _korisniciProvider.getById(korisnikId);
    } catch (e) {
      print("Greška pri dohvaćanju korisnika: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appointments'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : _termini.isEmpty
                      ? Center(child: Text('There are no appointments.'))
                      : ListView.separated(
                          itemCount: _termini.length,
                          separatorBuilder: (context, index) =>
                              Divider(height: 16),
                          itemBuilder: (context, index) {
                            final termin = _termini[index];
                            return FutureBuilder(
                              future: Future.wait([
                                _fetchKorisnik(termin.korisnikIdDoktor),
                                _fetchKorisnik(termin.korisnikIdPacijent),
                              ]),
                              builder: (context,
                                  AsyncSnapshot<List<Korisnik?>> snapshot) {
                                if (!snapshot.hasData) {
                                  return Center(
                                      child: CircularProgressIndicator());
                                }

                                final doktor = snapshot.data![0];
                                final pacijent = snapshot.data![1];

                                return Card(
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: ListTile(
                                    contentPadding: EdgeInsets.all(16),
                                    title: Text(
                                      'Doctor: ${doktor != null ? "${doktor.ime} ${doktor.prezime}" : "Unknown"}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 8),
                                        Text(
                                          'Patient: ${pacijent != null ? "${pacijent.ime} ${pacijent.prezime}" : "Unknown"}',
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          'Date: ${DateFormat('dd.MM.yyyy - HH:mm').format(termin.datum!)}',
                                        ),
                                      ],
                                    ),
                                    trailing: IconButton(
                                       icon: const Icon(Icons.info, color: Colors.blue),
                                      onPressed: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                TerminInfoScreen(termin: termin),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _navigateToTerminDetailScreen(null);
                },
                child: Text('Add Appointment'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToTerminDetailScreen(Termin? termin) async {
    final modifiedTermin = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TerminDetailScreen(termin: termin),
      ),
    );

    if (modifiedTermin != null && modifiedTermin is Termin) {
      setState(() {
        int index = _termini
            .indexWhere((element) => element.terminId == modifiedTermin.terminId);
        if (index != -1) {
          _termini[index] = modifiedTermin;
        } else {
          _termini.add(modifiedTermin);
        }
      });
    }
  }
}
