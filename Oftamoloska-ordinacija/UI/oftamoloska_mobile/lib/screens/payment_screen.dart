import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';
import 'success_screen.dart';
import 'cancel_screen.dart';

class PaymentScreen extends StatefulWidget {
  final List<Map<String, dynamic>> items;
  final int korisnikId;
  final int? narudzbaId;
  final double? iznos;

  const PaymentScreen({
    required this.items,
    required this.korisnikId,
    required this.narudzbaId,
    required this.iznos,
    super.key
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool isLoading = true;
  late final double _totalAmount;

  final String clientId = "AWKCtp1D13eNQNe-fd7ujF0i-Cv4zUxhrd2q4D4qMUnKDjHRSVonKq-yHmG8d8nPg3NunJTKvldTDFVY";
  final String clientSecret = "EKL3tGhOxJZYeyufMqNaLrJkHI0Z2Z6qF9FINKp8ht8V8wOLp9bV8mQ9nlA8FoxE0pkFcDif_ifpSv_b";
  final String _paypalBaseUrl = 'https://api.sandbox.paypal.com';

  @override
  void initState() {
    super.initState();
    _totalAmount = widget.iznos ?? 0.0;
    _startPaymentProcess();
  }

  Future<void> _startPaymentProcess() async {
    try {
      final accessToken = await _getAccessToken();
      final orderUrl = await _createOrder(accessToken, _totalAmount);
      _redirectToPayPal(orderUrl);
    } catch (e) {
      print("Error during PayPal payment process: $e");
    }
  }

  Future<String> _getAccessToken() async {
    final response = await http.post(
      Uri.parse('$_paypalBaseUrl/v1/oauth2/token'),
      headers: {
        'Authorization': 'Basic ${base64Encode(utf8.encode('$clientId:$clientSecret'))}',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: 'grant_type=client_credentials',
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['access_token'];
    } else {
      throw Exception('Failed to obtain PayPal access token');
    }
  }

  Future<String> _createOrder(String accessToken, double total) async {
    final response = await http.post(
      Uri.parse('$_paypalBaseUrl/v2/checkout/orders'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode({
        'intent': 'CAPTURE',
        'purchase_units': [
          {
            'amount': {
              'currency_code': 'USD',
              'value': total.toStringAsFixed(2),
            },
          },
        ],
        'application_context': {
          'return_url': 'https://success.example.com',
          'cancel_url': 'https://cancel.example.com',
        }
      }),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      final approvalUrl = data['links']
          .firstWhere((link) => link['rel'] == 'approve')['href'];
      return approvalUrl;
    } else {
      throw Exception('Failed to create PayPal order');
    }
  }

  void _redirectToPayPal(String approvalUrl) {
    final webviewController = _createWebViewController(approvalUrl);
    Navigator.of(context).push(MaterialPageRoute(builder: (builder) {
      return Scaffold(
        body: WebViewWidget(
          controller: webviewController,
        ),
      );
    }));
  }

  WebViewController _createWebViewController(String approvalUrl) {
    return WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            setState(() {
              isLoading = true;
            });
          },
          onPageFinished: (url) {
            setState(() {
              isLoading = false;
            });
          },
          onNavigationRequest: (request) {
            final url = request.url;
            if (url.startsWith('https://success.example.com')) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => SuccessScreen(
                    items: widget.items,
                    narudzbaId: widget.narudzbaId,
                    iznos: _totalAmount,
                  ),
                ),
              );
              return NavigationDecision.prevent;
            }
            if (url.startsWith('https://cancel.example.com')) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const CancelScreen(),
                ),
              );
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(approvalUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: (!isLoading)
                ? ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Back"),
                  )
                : const CircularProgressIndicator(),
          ),
        ],
      ),
    );
  }
}