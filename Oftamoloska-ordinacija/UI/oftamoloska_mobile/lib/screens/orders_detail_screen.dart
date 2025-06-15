import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:oftamoloska_mobile/models/narudzba.dart';
import 'package:oftamoloska_mobile/models/stavkaNarudzbe.dart';
import 'package:oftamoloska_mobile/models/product.dart';
import 'package:oftamoloska_mobile/providers/stavkanarudzbe_provider.dart';
import 'package:oftamoloska_mobile/providers/product_provider.dart';

class OrderDetailsScreen extends StatefulWidget {
  final Narudzba narudzba;

  const OrderDetailsScreen({Key? key, required this.narudzba}) : super(key: key);

  @override
  _OrderDetailsScreenState createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  final StavkaNarudzbeProvider _stavkaProvider = StavkaNarudzbeProvider();
  final ProductProvider _productProvider = ProductProvider();

  List<StavkaNarudzbe> _stavke = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadStavke();
  }

  Future<void> _loadStavke() async {
    if (widget.narudzba.narudzbaId == null) {
      setState(() => _loading = false);
      return;
    }
    try {
      final stavke = await _stavkaProvider.getStavkeNarudzbeByNarudzbaId(widget.narudzba.narudzbaId!);
      setState(() {
        _stavke = stavke;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
     
    }
  }

  @override
  Widget build(BuildContext context) {
  
    final dateFormatted = widget.narudzba.datum != null
        ? DateFormat('dd.MM.yyyy').format(widget.narudzba.datum!)
        : 'Unknown date';


    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow(Icons.confirmation_number, "Order Number:", widget.narudzba.brojNarudzbe ?? 'N/A'),
                    _buildDetailRow(Icons.date_range, "Order Date:", dateFormatted),
                    _buildDetailRow(Icons.info, "Status:", widget.narudzba.status ?? 'Unknown'),
                    const SizedBox(height: 20),
                    const Text('Order Items', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const Divider(),
                    _stavke.isEmpty
                        ? const Text('No items in this order')
                        : Column(
                            children: _stavke.map((stavka) {
                              return FutureBuilder<Product>(
                                future: _productProvider.getById(stavka.proizvodId!),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return ListTile(
                                      title: Text('Loading product...'),
                                      leading: CircleAvatar(child: Text(stavka.kolicina.toString())),
                                    );
                                  }
                                  final product = snapshot.data!;
                                  final cijena = product.cijena ?? 0.0;
                                  return ListTile(
                                    leading: CircleAvatar(child: Text(stavka.kolicina.toString())),
                                    title: Text(product.naziv ?? 'No name'),
                                    subtitle: Text('Price: ${cijena.toStringAsFixed(2)} KM\nQuantity: ${stavka.kolicina}'),
                                  );
                                },
                              );
                            }).toList(),
                          ),
                    const SizedBox(height: 16),
                   
                    Text(
                      "Total Amount: ${widget.narudzba.iznos?.toStringAsFixed(2) ?? '0.00'} KM",
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildDetailRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.blue),
          const SizedBox(width: 12),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 16, color: Colors.black),
                children: [
                  TextSpan(text: '$title ', style: const TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: value),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
