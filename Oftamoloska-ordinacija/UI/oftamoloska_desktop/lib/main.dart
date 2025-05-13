import 'package:oftamoloska_desktop/providers/korisnik_provider.dart';
import 'package:oftamoloska_desktop/providers/novosti_provider.dart';
import 'package:oftamoloska_desktop/providers/orders_provider.dart';
import 'package:oftamoloska_desktop/providers/product_provider.dart';
import 'package:oftamoloska_desktop/providers/recommend_result_provider.dart';
import 'package:oftamoloska_desktop/providers/stavka_narudzbe_provider.dart';
import 'package:oftamoloska_desktop/providers/termini_provider.dart';
import 'package:oftamoloska_desktop/providers/vrste_proizvoda_provider.dart';
import 'package:oftamoloska_desktop/providers/zdravstveni_karton_provider.dart';
import 'package:oftamoloska_desktop/screens/product_list_screen.dart';
import 'package:oftamoloska_desktop/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Europe/Belgrade')); 
  runApp(MyMaterialApp());
}

class OrderDetailState extends ChangeNotifier {
  Map<String, dynamic>? _orderDetails;

  Map<String, dynamic>? get orderDetails => _orderDetails;

  void updateOrderDetails(Map<String, dynamic> newOrderDetails) {
    _orderDetails = Map<String, dynamic>.from(newOrderDetails);
    notifyListeners();
  }
}

class ProductDetailState extends ChangeNotifier {
  Map<String, dynamic>? _productDetails;

  Map<String, dynamic>? get productDetails => _productDetails;

  void updateProductDetails(Map<String, dynamic> newProductDetails) {
    _productDetails = Map<String, dynamic>.from(newProductDetails);
    notifyListeners();
  }
}

class MyMaterialApp extends StatelessWidget {
  const MyMaterialApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => VrsteProizvodaProvider()),
        ChangeNotifierProvider(create: (_) => NovostiProvider()),
        ChangeNotifierProvider(create: (_) => OrdersProvider()),
        ChangeNotifierProvider(create: (_) => OrderDetailState()),
        ChangeNotifierProvider(create: (_) => ProductDetailState()),
        ChangeNotifierProvider(create: (_) => TerminiProvider()),
        ChangeNotifierProvider(create: (_) => KorisniciProvider()),
        ChangeNotifierProvider(create: (_) => ZdravstveniKartonProvider()),
        ChangeNotifierProvider(create: (_) => RecommendResultProvider()),
        ChangeNotifierProvider(create: (_) => StavkaNarudzbeProvider()),
      ],
     child: MaterialApp(
  title: 'OculusPro',
  theme: ThemeData(
    primarySwatch: Colors.green,
    scaffoldBackgroundColor: Colors.grey[100],
    colorScheme: ColorScheme.light(
      primary: Colors.green[800]!,
      secondary: Colors.green[600]!,
    ),
    fontFamily: 'Roboto', // možeš promijeniti ako imaš drugi font
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.green[800],
      foregroundColor: Colors.white,
      elevation: 4,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      iconTheme: IconThemeData(color: Colors.white),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green[800],
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.green.shade800),
      ),
      labelStyle: TextStyle(
        color: Colors.green.shade800,
      ),
      prefixIconColor: Colors.green.shade800,
    ),
    textTheme: TextTheme(
      bodyMedium: TextStyle(
        fontSize: 16,
        color: Colors.black87,
      ),
      titleLarge: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.green[800],
      ),
    ),
  ),
  home: LoginPage(),
),

    );
  }
}


class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late ProductProvider _productProvider;

  @override
  Widget build(BuildContext context) {
    _productProvider = context.read<ProductProvider>();

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Container(
            constraints: BoxConstraints(maxWidth: 450),
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 6,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Welcome to OculusPro",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[800],
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Image.asset("assets/images/logo.png", height: 120),
                    const SizedBox(height: 24),
                    TextField(
                      decoration: InputDecoration(
                        labelText: "Username",
                        prefixIcon: Icon(Icons.person),
                      ),
                      controller: _usernameController,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      decoration: InputDecoration(
                        labelText: "Password",
                        prefixIcon: Icon(Icons.lock),
                      ),
                      obscureText: true,
                      controller: _passwordController,
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          var username = _usernameController.text;
                          var password = _passwordController.text;

                          Authorization.username = username;
                          Authorization.password = password;

                          try {
                            await _productProvider.get();
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => const ProductListScreen(),
                              ),
                            );
                          } on Exception catch (e) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: Text("Login Error"),
                                content: Text(e.toString()),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text("OK"),
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                        child: Text("Login"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
