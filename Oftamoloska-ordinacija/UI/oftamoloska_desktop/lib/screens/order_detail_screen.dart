import 'package:oftamoloska_desktop/models/narudzba.dart';
import 'package:oftamoloska_desktop/models/stavkaNarudzbe.dart';
import 'package:oftamoloska_desktop/providers/orders_provider.dart';
import 'package:oftamoloska_desktop/providers/stavka_narudzbe_provider.dart';
import 'package:oftamoloska_desktop/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../providers/product_provider.dart';

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
  List<StavkaNarudzbe> _stavke = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _initialValue = {
      'brojNarudzbe': widget.narudzba?.brojNarudzbe,
      'status': widget.narudzba?.status,
      'datum': widget.narudzba?.datum.toString(),
      'iznos': widget.narudzba?.iznos.toString(),
    };
    _ordersProvider = context.read<OrdersProvider>();
    _stavkaProvider = StavkaNarudzbeProvider();
    _productProvider = ProductProvider();
    _loadItems();
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

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: "Order ${widget.narudzba?.brojNarudzbe ?? ''}",
      child: _loading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildSectionCard(
                    title: "Basic Info",
                    child: _buildBasicInfo(),
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
          FormBuilderTextField(
            name: 'status',
            decoration: const InputDecoration(labelText: "Status"),
            validator: _validateStatus,
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
        return FutureBuilder<String>(
          future: _getProductName(s.proizvodId),
          builder: (c, snap) {
            final name = snap.data ?? '...';
            return ListTile(
              contentPadding: const EdgeInsets.symmetric(vertical: 4),
              leading: CircleAvatar(child: Text(s.kolicina.toString())),
              title: Text(name),
            );
          },
        );
      }).toList(),
    );
  }

  Future<String> _getProductName(int? id) async {
    if (id == null) return 'N/A';
    try {
      final p = await _productProvider.getById(id);
      return p.naziv ?? 'N/A';
    } catch (_) {
      return 'N/A';
    }
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
        await _ordersProvider.update(
            widget.narudzba!.narudzbaId!, data);
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
