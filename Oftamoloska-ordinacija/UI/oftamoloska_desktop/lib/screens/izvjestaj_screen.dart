import 'package:oftamoloska_desktop/models/stavkaNarudzbe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';

import '../models/korisnik.dart';
import '../models/narudzba.dart';
import '../models/SearchResult.dart';
import '../models/zdravstveni_karton.dart';
import '../providers/korisnik_provider.dart';
import '../providers/orders_provider.dart';
import '../providers/product_provider.dart';
import '../providers/stavka_narudzbe_provider.dart';
import '../providers/zdravstveni_karton_provider.dart';

class IzvjestajScreen extends StatefulWidget {
  const IzvjestajScreen({Key? key}) : super(key: key);

  @override
  State<IzvjestajScreen> createState() => _IzvjestajScreenState();
}

class _IzvjestajScreenState extends State<IzvjestajScreen> {
  late KorisniciProvider _korProvider;
  late OrdersProvider _orderProvider;
  late ZdravstveniKartonProvider _kartonProvider;
  late StavkaNarudzbeProvider _stavkaProvider;
  late ProductProvider _productProvider;

  SearchResult<Korisnik>? _patientsResult;
  List<Narudzba>? _orders;
  List<ZdravstveniKarton>? _kartoni;
  List<StavkaNarudzbe> _stavke = [];

  int? _selectedPatient;
  String _selectedReportType = 'Narudzbe';

  @override
  void initState() {
    super.initState();
    _korProvider = context.read<KorisniciProvider>();
    _orderProvider = context.read<OrdersProvider>();
    _kartonProvider = context.read<ZdravstveniKartonProvider>();
    _stavkaProvider = StavkaNarudzbeProvider();
    _productProvider = ProductProvider();
    _loadPatients();
  }

  Future<void> _loadPatients() async {
    final data = await _korProvider.get(filter: {'tipKorisnika': 'pacijent'});
    setState(() {
      _patientsResult = data;
      if (data.result.isNotEmpty) {
        _selectedPatient = data.result.first.korisnikId;
        _loadReportData();
      }
    });
  }

  Future<void> _loadReportData() async {
    if (_selectedPatient == null) return;
    if (_selectedReportType == 'Narudzbe') {
      final d = await _orderProvider.get(filter: {'korisnikId': _selectedPatient});
      setState(() => _orders = d.result);
    } else {
      final d = await _kartonProvider.get(filter: {'korisnikId': _selectedPatient});
      setState(() => _kartoni = d.result);
    }
  }

  Future<void> _loadOrderItems(Narudzba o) async {
    final items = await _stavkaProvider.getStavkeNarudzbeByNarudzbaId(o.narudzbaId!);
    setState(() => _stavke = items);
  }

  Future<String> _getProductName(int? id) async {
    if (id == null) return 'N/A';
    final p = await _productProvider.getById(id);
    return p.naziv ?? 'N/A';
  }

  pw.Widget _pdfContent() {
    if (_selectedReportType == 'Narudzbe' && _orders != null) {
      return pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: _orders!.map((o) {
          return pw.Column(children: [
            pw.Text('Narudžba: ${o.brojNarudzbe}', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.Text('Iznos: ${o.iznos} KM    Datum: ${DateFormat('yyyy-MM-dd').format(o.datum!)}'),
            pw.SizedBox(height: 5),
          ]);
        }).toList(),
      );
    } else if (_selectedReportType == 'Zdravstveni karton' && _kartoni != null) {
      return pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: _kartoni!.map((k) => pw.Text(k.sadrzaj ?? '')).toList(),
      );
    } else {
      return pw.Text('Nema podataka za odabrani izvještaj.');
    }
  }

  Future<pw.Document> _generatePDF() async {
    final pdf = pw.Document();
    pdf.addPage(pw.Page(build: (_) {
      return pw.Padding(
        padding: pw.EdgeInsets.all(20),
        child: pw.Column(children: [
          pw.Text('Izvještaj ($_selectedReportType)', style: pw.TextStyle(fontSize: 24)),
          pw.SizedBox(height: 20),
          _pdfContent(),
        ]),
      );
    }));
    return pdf;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reports')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
        
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(children: [
                Expanded(
                  child: DropdownButtonFormField<int>(
                    value: _selectedPatient,
                    decoration: const InputDecoration(labelText: 'Pacijent'),
                    items: _patientsResult?.result.map((p) {
                      return DropdownMenuItem(
                        value: p.korisnikId,
                        child: Text(p.ime ?? ''),
                      );
                    }).toList(),
                    onChanged: (v) => setState(() {
                      _selectedPatient = v;
                      _loadReportData();
                    }),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedReportType,
                    decoration: const InputDecoration(labelText: 'Tip izvještaja'),
                    items: ['Narudzbe', 'Zdravstveni karton'].map((t) {
                      return DropdownMenuItem(value: t, child: Text(t));
                    }).toList(),
                    onChanged: (v) => setState(() {
                      _selectedReportType = v!;
                      _loadReportData();
                    }),
                  ),
                ),
              ]),
            ),
          ),
          const SizedBox(height: 20),
          
          Expanded(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: _selectedReportType == 'Narudzbe'
                    ? _orders == null
                        ? const Center(child: CircularProgressIndicator())
                        : ListView.builder(
                            itemCount: _orders!.length,
                            itemBuilder: (_, i) {
                              final o = _orders![i];
                              return Card(
                                elevation: 1,
                                margin: const EdgeInsets.symmetric(vertical: 6),
                                child: ListTile(
                                  title: Text(o.brojNarudzbe ?? ''),
                                  subtitle: Text(
                                      'Iznos: ${o.iznos} KM • ${DateFormat('yyyy-MM-dd').format(o.datum!)}'),
                                  trailing: TextButton(
                                    child: const Text('Details'),
                                    onPressed: () async {
                                      await _loadOrderItems(o);
                                      showDialog(
                                        context: context,
                                        builder: (_) => AlertDialog(
                                          title: const Text('Stavke'),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: _stavke.map((s) {
                                              return FutureBuilder<String>(
                                                future: _getProductName(s.proizvodId),
                                                builder: (c, snap) {
                                                  final name = snap.data ?? '...';
                                                  return Text(
                                                      '${s.kolicina} × $name');
                                                },
                                              );
                                            }).toList(),
                                          ),
                                          actions: [
                                            TextButton(
                                                onPressed: () => Navigator.pop(context),
                                                child: const Text('Close'))
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              );
                            })
                    : _kartoni == null
                        ? const Center(child: CircularProgressIndicator())
                        : ListView(
                            children: _kartoni!
                                .map((k) => Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 4),
                                      child: Text('- ${k.sadrzaj}'),
                                    ))
                                .toList(),
                          ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              final pdf = await _generatePDF();
              await Printing.layoutPdf(onLayout: (format) => pdf.save());
            },
            child: const Text('Save & Print'),
          ),
        ]),
      ),
    );
  }
}
