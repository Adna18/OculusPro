import 'package:flutter/material.dart';
import 'package:oftamoloska_desktop/models/transakcija.dart';
import 'package:oftamoloska_desktop/providers/transakcija_provider.dart';

class TransakcijeScreen extends StatefulWidget {
  const TransakcijeScreen({Key? key}) : super(key: key);

  @override
  State<TransakcijeScreen> createState() => _TransakcijeScreenState();
}

class _TransakcijeScreenState extends State<TransakcijeScreen> {
  final TransakcijaProvider _transakcijaProvider = TransakcijaProvider();
  List<Transakcija> _transakcije = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTransakcije();
  }

  Future<void> _fetchTransakcije() async {
    try {
      var data = await _transakcijaProvider.get();
      setState(() {
        _transakcije = data.result;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching transactions: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  DataRow _buildDataRow(Transakcija t) {
    return DataRow(cells: [
      DataCell(Text(t.narudzbaId?.toString() ?? "")),
      DataCell(Text(t.iznos?.toStringAsFixed(2) ?? "")),
      DataCell(Text(t.transId ?? "")),
      DataCell(Text(t.statusTransakcije ?? "")),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Transactions"),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SizedBox(
                    width: constraints.maxWidth,
                    child: SingleChildScrollView(
                      child: DataTable(
                        headingRowColor: MaterialStateColor.resolveWith(
                          (states) => Colors.grey[300]!,
                        ),
                        columnSpacing: 50,
                        columns: const [
                          DataColumn(label: Text("Order ID")),
                          DataColumn(label: Text("Amount")),
                          DataColumn(label: Text("Transaction ID")),
                          DataColumn(label: Text("Status")),
                        ],
                        rows: _transakcije.map((t) => _buildDataRow(t)).toList(),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
