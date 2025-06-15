import 'package:oftamoloska_desktop/models/narudzba.dart';
import 'package:oftamoloska_desktop/models/korisnik.dart';
import 'package:oftamoloska_desktop/models/stavkaNarudzbe.dart';
import 'package:oftamoloska_desktop/models/product.dart';
import 'package:oftamoloska_desktop/models/transakcija.dart';
import 'package:oftamoloska_desktop/providers/korisnik_provider.dart';
import 'package:oftamoloska_desktop/providers/orders_provider.dart';
import 'package:oftamoloska_desktop/providers/stavka_narudzbe_provider.dart';
import 'package:oftamoloska_desktop/providers/product_provider.dart';
import 'package:oftamoloska_desktop/providers/transakcija_provider.dart';
import 'package:oftamoloska_desktop/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

class OrderDetailScreen extends StatefulWidget {
  final Narudzba? narudzba;
  OrderDetailScreen({super.key, this.narudzba});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  late OrdersProvider _ordersProvider;
  late StavkaNarudzbeProvider _stavkaProvider;
  late ProductProvider _productProvider;
  late KorisniciProvider _korisniciProvider;
  final TransakcijaProvider _transakcijaProvider = TransakcijaProvider();
  List<Transakcija> _transakcije = [];

  List<StavkaNarudzbe> _stavke = [];
  Korisnik? _korisnik;
  bool _loading = true;
  bool _loadingKorisnik = true;

  @override
  void initState() {
    super.initState();

    _initialValue = {
      'brojNarudzbe': widget.narudzba?.brojNarudzbe,
      'status': widget.narudzba?.status,
      'datum': (widget.narudzba?.datum != null)
          ? _formatDate(widget.narudzba!.datum!)
          : '',
      'iznos': widget.narudzba?.iznos != null
          ? widget.narudzba!.iznos!.toStringAsFixed(2)
          : '',
    };

    _ordersProvider = context.read<OrdersProvider>();
    _stavkaProvider = StavkaNarudzbeProvider();
    _productProvider = ProductProvider();
    _korisniciProvider = KorisniciProvider();

    _loadItems();
    _loadKorisnik();
    _fetchTransakcije(); 
  }

  Future<void> _fetchTransakcije() async {
    var data = await _transakcijaProvider.get();
    setState(() {
      _transakcije = data.result
          .where(
              (transakcija) => transakcija.narudzbaId == widget.narudzba?.narudzbaId)
          .toList();
    });
  }

  String _formatDate(DateTime date) {
    return "${date.year.toString().padLeft(4, '0')}-"
        "${date.month.toString().padLeft(2, '0')}-"
        "${date.day.toString().padLeft(2, '0')}";
  }

  Future<void> _loadItems() async {
    if (widget.narudzba?.narudzbaId == null) {
      setState(() => _loading = false);
      return;
    }
    try {
      final items = await _stavkaProvider
          .getStavkeNarudzbeByNarudzbaId(widget.narudzba!.narudzbaId!);
      setState(() {
        _stavke = items;
        _loading = false;
      });
    } catch (_) {
      setState(() => _loading = false);
    }
  }

  Future<void> _loadKorisnik() async {
    if (widget.narudzba?.korisnik != null) {
      setState(() {
        _korisnik = widget.narudzba!.korisnik;
        _loadingKorisnik = false;
      });
      return;
    }
    if (widget.narudzba?.korisnikId == null) {
      setState(() {
        _loadingKorisnik = false;
      });
      return;
    }
    try {
      final k = await _korisniciProvider.getById(widget.narudzba!.korisnikId!);
      setState(() {
        _korisnik = k;
        _loadingKorisnik = false;
      });
    } catch (e) {
      setState(() {
        _loadingKorisnik = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: "Order ${widget.narudzba?.brojNarudzbe ?? ''}",
      child: (_loading || _loadingKorisnik)
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildSectionCard(
                    title: "Basic Info",
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_korisnik != null) ...[
                          Text(
                            "Korisnik: ${_korisnik!.ime} ${_korisnik!.prezime}",
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 8),
                          if (_korisnik!.adresa != null &&
                              _korisnik!.adresa!.isNotEmpty)
                            Text(
                              "Adresa: ${_korisnik!.adresa}",
                              style: const TextStyle(fontSize: 16),
                            ),
                          if (_korisnik!.telefon != null &&
                              _korisnik!.telefon!.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                "Telefon: ${_korisnik!.telefon}",
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          if (_korisnik!.email != null &&
                              _korisnik!.email!.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                "Email: ${_korisnik!.email}",
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          const SizedBox(height: 12),
                        ],
                        _buildBasicInfo(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildSectionCard(
                    title: "Order Items",
                    child: _buildItemsList(),
                  ),
                  const SizedBox(height: 24),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: _onSave,
                      child: const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        child: Text("Save", style: TextStyle(fontSize: 16)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildSectionCard({required String title, required Widget child}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const Divider(),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildBasicInfo() {
    return FormBuilder(
      key: _formKey,
      initialValue: _initialValue,
      child: Column(
        children: [
          FormBuilderTextField(
            name: 'brojNarudzbe',
            readOnly: true,
            decoration: const InputDecoration(labelText: "Order Number"),
          ),
          const SizedBox(height: 12),
          FormBuilderDropdown<String>(
            name: 'status',
            decoration: const InputDecoration(
              labelText: 'Status',
              border: OutlineInputBorder(),
            ),
            validator: _validateStatus,
            items: ['Pending', 'Completed', 'Cancelled']
                .map((status) => DropdownMenuItem(
                      value: status,
                      child: Text(status),
                    ))
                .toList(),
          ),
          const SizedBox(height: 12),
          FormBuilderTextField(
            name: 'iznos',
            readOnly: true,
            decoration: const InputDecoration(labelText: "Total Amount"),
          ),
          const SizedBox(height: 12),
          FormBuilderTextField(
            name: 'datum',
            readOnly: true,
            decoration: const InputDecoration(labelText: "Order Date"),
          ),
          const SizedBox(height: 12),
          if (_transakcije.isNotEmpty) ...[
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Transaction Status: ${_transakcije.first.statusTransakcije ?? 'Unknown'}",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.blueGrey,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String? _validateStatus(String? val) {
    if (val == null || val.isEmpty) return null;
    final curr = _initialValue['status'];
    final next = val;
    final allowed = {
      'Pending': ['Completed', 'Cancelled'],
      'Cancelled': ['Pending'],
    };
    if (curr != next &&
        (!allowed.containsKey(curr) || !allowed[curr]!.contains(next))) {
      return "Allowed: Pending→Completed/Cancelled, Cancelled→Pending";
    }
    return null;
  }

  Widget _buildItemsList() {
    if (_stavke.isEmpty) {
      return const Text("No items in this order");
    }
    return Column(
      children: _stavke.map((s) {
        if (s.proizvodId == null) {
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(vertical: 4),
            leading: CircleAvatar(child: Text(s.kolicina.toString())),
            title: const Text('Proizvod ID nije dostupan'),
          );
        }
        return FutureBuilder<Product>(
          future: _productProvider.getById(s.proizvodId!),
          builder: (c, snap) {
            if (!snap.hasData) {
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 4),
                leading: CircleAvatar(child: Text(s.kolicina.toString())),
                title: const Text('Učitavanje...'),
              );
            }
            final product = snap.data!;
            final cijena = product.cijena ?? 0.0;
            return ListTile(
              contentPadding: const EdgeInsets.symmetric(vertical: 4),
              leading: CircleAvatar(child: Text(s.kolicina.toString())),
              title: Text(product.naziv ?? 'Bez naziva'),
              subtitle: Text(
                  'Cijena: ${cijena.toStringAsFixed(2)} KM\nKoličina: ${s.kolicina}'),
            );
          },
        );
      }).toList(),
    );
  }

  void _onSave() async {
    if (!(_formKey.currentState?.saveAndValidate() ?? false)) {
      return;
    }
    final data = _formKey.currentState!.value;
    try {
      if (widget.narudzba == null) {
        await _ordersProvider.insert(data);
      } else {
        if (_initialValue['status'] == 'Completed') {
          await showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text("Error"),
              content: const Text("Cannot change status after Completed."),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text("OK"))
              ],
            ),
          );
          return;
        }
        await _ordersProvider.update(widget.narudzba!.narudzbaId!, data);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Order saved'), backgroundColor: Colors.green),
      );
      Navigator.pop(context, 'reload');
    } catch (e) {
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("Error"),
          content: Text(e.toString()),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text("OK"))
          ],
        ),
      );
    }
  }
}
