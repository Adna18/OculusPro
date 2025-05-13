import 'package:oftamoloska_desktop/models/narudzba.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:oftamoloska_desktop/providers/orders_provider.dart';

import 'order_detail_screen.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final OrdersProvider _ordersProvider = OrdersProvider();
  List<Narudzba> _narudzba = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchNarudzbe();
  }

  Future<void> _fetchNarudzbe() async {
    try {
      var result = await _ordersProvider.get();
      setState(() {
        _narudzba = result.result;
        isLoading = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Zadržavamo padding koji već koristiš
        child: Column(
          children: [
            _buildDataListView(),
          ],
        ),
      ),
    );
  }

  Widget _buildDataListView() {
    if (isLoading) {
      return Expanded(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_narudzba.isEmpty) {
      return Expanded(
        child: Center(
          child: Text(
            'No orders found.',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        ),
      );
    }

    return Expanded(
      child: ListView.builder(
        itemCount: _narudzba.length,
        itemBuilder: (context, index) {
          var narudzba = _narudzba[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Card(
                elevation: 4, // Veća sjenka za bolji kontrast
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: Colors.white,
                child: ListTile(
                  onTap: () async {
                    var refresh = await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => OrderDetailScreen(narudzba: narudzba),
                      ),
                    );
                    if (refresh == 'reload') {
                      _fetchNarudzbe();
                    }
                  },
                  leading: Icon(Icons.shopping_cart, color: Colors.green[800]), // Ikona
                  title: Text(
                    narudzba.brojNarudzbe ?? '',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.green[800],
                        ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 4),
                      Text(
                        'Total: ${narudzba.iznos.toString()} KM',
                        style: TextStyle(fontSize: 16, color: Colors.green[700]),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Created on: ${narudzba.datum != null ? DateFormat('yyyy-MM-dd').format(narudzba.datum!) : 'Unknown Date'}',
                        style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
