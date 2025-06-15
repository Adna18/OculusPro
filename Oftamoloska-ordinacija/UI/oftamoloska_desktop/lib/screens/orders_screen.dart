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
  List<Narudzba> _filteredNarudzba = [];
  bool isLoading = true;

 
  String? _selectedStatus = 'All';

  final List<String> _statusOptions = [
    'All',
    'Pending',
    'Completed',
    'Cancelled',
  ];

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
        _applyFilter();
        isLoading = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
    }
  }

  void _applyFilter() {
    if (_selectedStatus == null || _selectedStatus == 'All') {
      _filteredNarudzba = List.from(_narudzba);
    } else {
      _filteredNarudzba = _narudzba
          .where((n) => n.status != null && n.status == _selectedStatus)
          .toList();
    }
  }

  void _onStatusChanged(String? newValue) {
    setState(() {
      _selectedStatus = newValue;
      _applyFilter();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
           
            Row(
              children: [
                const Text(
                  'Filter by status: ',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(width: 12),
                DropdownButton<String>(
                  value: _selectedStatus,
                  items: _statusOptions
                      .map((status) => DropdownMenuItem(
                            value: status,
                            child: Text(status),
                          ))
                      .toList(),
                  onChanged: _onStatusChanged,
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildDataListView(),
          ],
        ),
      ),
    );
  }

  Widget _buildDataListView() {
    if (isLoading) {
      return const Expanded(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_filteredNarudzba.isEmpty) {
      return const Expanded(
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
        itemCount: _filteredNarudzba.length,
        itemBuilder: (context, index) {
          var narudzba = _filteredNarudzba[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: Colors.white,
                child: ListTile(
                  onTap: () async {
                    var refresh = await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            OrderDetailScreen(narudzba: narudzba),
                      ),
                    );
                    if (refresh == 'reload') {
                      _fetchNarudzbe();
                    }
                  },
                  leading: Icon(Icons.shopping_cart, color: Colors.green[800]),
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
                      const SizedBox(height: 4),
                      Text(
                        'Status: ${narudzba.status ?? 'Unknown'}',
                        style: const TextStyle(fontSize: 14, color: Colors.black87),
                      ),
                      Text(
                        'Total: ${narudzba.iznos != null ? narudzba.iznos!.toStringAsFixed(2) : '0.00'} KM',
                        style:
                            TextStyle(fontSize: 16, color: Colors.green[700]),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Created on: ${narudzba.datum != null ? DateFormat('yyyy-MM-dd').format(narudzba.datum!) : 'Unknown Date'}',
                        style: const TextStyle(
                            fontStyle: FontStyle.italic, color: Colors.grey),
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
