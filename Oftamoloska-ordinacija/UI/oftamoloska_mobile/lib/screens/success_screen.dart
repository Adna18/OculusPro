import 'package:flutter/material.dart';
import '../models/transakcija.dart';
import '../providers/cart_provider.dart';
import '../providers/product_provider.dart';
import '../providers/transakcija_provider.dart';
import 'package:provider/provider.dart';

class SuccessScreen extends StatefulWidget {
  final List<Map<String, dynamic>> items;
  final int? narudzbaId;
  final double? iznos;

  const SuccessScreen({
    Key? key,
    required this.items,
    required this.narudzbaId,
    required this.iznos,
  }) : super(key: key);

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  late ProductProvider _productProvider;
  late TransakcijaProvider _transakcijaProvider;
  late CartProvider _cartProvider;
  bool isProcessing = true;

  @override
  void initState() {
    super.initState();
    _productProvider = Provider.of<ProductProvider>(context, listen: false);
    _transakcijaProvider = Provider.of<TransakcijaProvider>(context, listen: false);
    _cartProvider = Provider.of<CartProvider>(context, listen: false);
    _processTransaction();
  }

  Future<void> _processTransaction() async {    try {
      final totalAmount = await calculateTotalAmount(widget.items);
      Map<String, dynamic> transactionBody = {
        'id': 0,
        'narudzbaId': widget.narudzbaId ?? 0,
        'iznos': widget.iznos ?? totalAmount,
        'transId': DateTime.now().millisecondsSinceEpoch.toString(),
        'statusTransakcije': 'ok'
      };

      Transakcija transaction = Transakcija.fromJson(transactionBody);
      await _transakcijaProvider.insert(transaction);
      _cartProvider.cart.items.clear();

      if (mounted) {
        setState(() => isProcessing = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Payment successful'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      print("Error processing transaction: $e");
      if (mounted) {
        setState(() => isProcessing = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error processing payment'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
  Future<double> calculateTotalAmount(List<Map<String, dynamic>> items) async {
    double total = 0.0;
    print('Starting total calculation');
    for (var item in items) {
      print('Processing item: $item');
      final proizvodId = item["proizvodId"] as int?;
      final quantity = item["kolicina"] as int?;
      
      if (proizvodId == null || quantity == null) {
        print('Warning: Invalid item data - proizvodId: $proizvodId, quantity: $quantity');
        continue;
      }      try {
        final product = await _productProvider.getById(proizvodId);
        final price = product.cijena;
        if (price != null) {
          print('Product price: $price, Quantity: $quantity');
          total += price * quantity;
        } else {
          print('Warning: Product $proizvodId has no price');
        }
      } catch (e) {
        print('Error processing product $proizvodId: $e');
      }
    }
    print('Final total: $total');
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Successful'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: isProcessing
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.check_circle_outline,
                    color: Colors.green,
                    size: 100,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Payment Completed Successfully!',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context)
                        .popUntil((route) => route.isFirst),
                    child: const Text('DONE'),
                  ),
                ],
              ),
      ),
    );
  }
}