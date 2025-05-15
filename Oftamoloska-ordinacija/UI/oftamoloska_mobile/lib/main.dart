 import 'package:oftamoloska_mobile/models/recommendResult.dart';
import 'package:oftamoloska_mobile/providers/cart_provider.dart';
import 'package:oftamoloska_mobile/providers/dojam_provider.dart';
import 'package:oftamoloska_mobile/providers/favorites_provider.dart';
import 'package:oftamoloska_mobile/providers/korisnik_provider.dart';
import 'package:oftamoloska_mobile/providers/novosti_provider.dart';
import 'package:oftamoloska_mobile/providers/order_provider.dart';
import 'package:oftamoloska_mobile/providers/product_provider.dart';
import 'package:oftamoloska_mobile/providers/recenzija_provider.dart';
import 'package:oftamoloska_mobile/providers/recommend_result_provider.dart';
import 'package:oftamoloska_mobile/providers/termini_provider.dart';
import 'package:oftamoloska_mobile/providers/transakcija_provider.dart';
import 'package:oftamoloska_mobile/providers/vrste_proizvoda_provider.dart';
import 'package:oftamoloska_mobile/providers/zdravstveni_karton_provider.dart';
import 'package:oftamoloska_mobile/screens/product_list_screen.dart';
import 'package:oftamoloska_mobile/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(MyMaterialApp());
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
        ChangeNotifierProvider(create: (_) => NovostiProvider()),
        ChangeNotifierProvider(create: (_) => TerminiProvider()),
        ChangeNotifierProvider(create: (_) => KorisniciProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => ProductDetailState()),
        ChangeNotifierProvider(create: (_) => VrsteProizvodaProvider()),
        ChangeNotifierProvider(create: (_) => DojamProvider()),
        ChangeNotifierProvider(create: (_) => RecenzijaProvider()),
        ChangeNotifierProvider(create: (_) => ZdravstveniKartonProvider()),
        ChangeNotifierProvider(create: (_) => TransakcijaProvider()),
        ChangeNotifierProvider(create: (_) => RecommendResultProvider()),
      ],
      child: MaterialApp(
        title: 'OculusPro',
        theme: ThemeData(
          primarySwatch: Colors.green,
          colorScheme: ColorScheme.light(
            primary: Colors.green[800]!,
            secondary: Colors.green[600]!,
          ),
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.green[800],
            foregroundColor: Colors.white,
            elevation: 4,
            centerTitle: true,
            titleTextStyle: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
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
              elevation: 2,
            ),
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: Colors.green[800],
              textStyle: TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            filled: true,
            fillColor: Colors.green[50],
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
          cardTheme: CardTheme(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: EdgeInsets.all(8),
          ),
        ),
        home: Welcome(),
      ),
    );
  }
}

class Welcome extends StatelessWidget {
  const Welcome({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size; 
    return Scaffold(
      backgroundColor: Colors.green[50],
      body: SingleChildScrollView(
        child: Container(
          height: size.height,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/logo.png", 
                height: 150,
                width: 300,
              ),
              SizedBox(height: 24),
              Text(
                'WELCOME TO OCULUSPRO', 
                style: TextStyle(
                  fontSize: 24, 
                  fontWeight: FontWeight.bold,
                  color: Colors.green[900],
                  letterSpacing: 1.2,
                ),
              ),
              SizedBox(height: size.height * 0.05),
              Container(
                width: size.width * 0.7,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                  child: Text("LOGIN"),
                ),
              ),
              SizedBox(height: 16),
              Container(
                width: size.width * 0.7,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.green[800],
                    side: BorderSide(color: Colors.green[800]!),
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUpPage()),
                    );
                  },
                  child: Text("SIGN UP"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  TextEditingController _usernameController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  late ProductProvider _productProvider;

  @override
  Widget build(BuildContext context) {
    _productProvider = context.read<ProductProvider>();
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Center( 
        child: SingleChildScrollView(
          child: Container(
            constraints: BoxConstraints(maxHeight: 600, maxWidth: 400), 
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      "assets/images/logo.png", 
                      height: 120,
                      width: 240,
                    ),
                    SizedBox(height: 24),
                    TextField(
                      decoration: InputDecoration(
                        labelText: "Username",
                        prefixIcon: Icon(Icons.person),
                      ),
                      controller: _usernameController,
                    ),
                    SizedBox(height: 16),
                    TextField(
                      decoration: InputDecoration(
                        labelText: "Password",
                        prefixIcon: Icon(Icons.lock),
                      ),
                      controller: _passwordController,
                      obscureText: true,
                    ),
                    SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          var username = _usernameController.text;
                          var password = _passwordController.text;

                          print("login proceed $username $password");

                          Authorization.username = username;
                          Authorization.password = password;

                          try {
                            await _productProvider.get();
            
                            Navigator.of(context).push( 
                            MaterialPageRoute(builder: (context) => const ProductListScreen()
                            ),
                            );
                          } on Exception catch (e) {
                            showDialog(
                                  context: context, 
                                  builder: (BuildContext context) => AlertDialog(
                                  title: Text("Error"),
                                  content: Text(e.toString()),
                                  actions: [
                                    TextButton(onPressed: ()=> Navigator.pop(context), child: Text("OK"))
                                  ],
                                ));
                          }
                        }, 
                        child: Text("LOGIN"),
                      ),
                    ),
                    SizedBox(height: 16),
                   
                     
                    
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

class SignUpPage extends StatelessWidget {
  SignUpPage({super.key});

  TextEditingController _firstnameController = new TextEditingController();
  TextEditingController _lastnameController = new TextEditingController();
  TextEditingController _usernameController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _phoneController = new TextEditingController();
  TextEditingController _addressController = new TextEditingController();
  TextEditingController _genderController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  TextEditingController _confirmPasswordController = new TextEditingController();

  late KorisniciProvider _korisniciProvider;

  @override
  Widget build(BuildContext context) {
    _korisniciProvider = Provider.of<KorisniciProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: Text("Sign Up")),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            constraints: BoxConstraints(maxWidth: 500),
            child: Card(
              margin: EdgeInsets.all(16),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Image.asset(
                      "assets/images/logo.png", 
                      height: 120,
                      width: 240,
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Create your account",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[800],
                      ),
                    ),
                    SizedBox(height: 24),
                    TextField(
                      decoration: InputDecoration(
                        labelText: "First Name",
                        prefixIcon: Icon(Icons.person),
                      ),
                      controller: _firstnameController,
                    ),
                    SizedBox(height: 16),
                    TextField(
                      decoration: InputDecoration(
                        labelText: "Last Name",
                        prefixIcon: Icon(Icons.person),
                      ),
                      controller: _lastnameController,
                    ),
                    SizedBox(height: 16),
                    TextField(
                      decoration: InputDecoration(
                        labelText: "Username",
                        prefixIcon: Icon(Icons.account_circle),
                      ),
                      controller: _usernameController,
                    ),
                    SizedBox(height: 16),
                    TextField(
                      decoration: InputDecoration(
                        labelText: "Email",
                        prefixIcon: Icon(Icons.email),
                      ),
                      controller: _emailController,
                    ),
                    SizedBox(height: 16),
                    TextField(
                      decoration: InputDecoration(
                        labelText: "Phone",
                        prefixIcon: Icon(Icons.phone),
                      ),
                      controller: _phoneController,
                    ),
                    SizedBox(height: 16),
                    TextField(
                      decoration: InputDecoration(
                        labelText: "Address",
                        prefixIcon: Icon(Icons.location_on),
                      ),
                      controller: _addressController,
                    ),
                    SizedBox(height: 16),
                    TextField(
                      decoration: InputDecoration(
                        labelText: "Select gender: 1-MALE, 2-FEMALE",
                        prefixIcon: Icon(Icons.transgender),
                      ),
                      controller: _genderController,
                    ),
                    SizedBox(height: 16),
                    TextField(
                      decoration: InputDecoration(
                        labelText: "Password",
                        prefixIcon: Icon(Icons.lock),
                      ),
                      controller: _passwordController,
                      obscureText: true,
                    ),
                    SizedBox(height: 16),
                    TextField(
                      decoration: InputDecoration(
                        labelText: "Confirm Password",
                        prefixIcon: Icon(Icons.lock),
                      ),
                      controller: _confirmPasswordController,
                      obscureText: true,
                    ),
                    SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_firstnameController.text.isEmpty ||
                              _lastnameController.text.isEmpty ||
                              _emailController.text.isEmpty ||
                              _phoneController.text.isEmpty ||
                              _addressController.text.isEmpty ||
                              _usernameController.text.isEmpty ||
                              _passwordController.text.isEmpty ||
                              _confirmPasswordController.text.isEmpty ||
                              _genderController.text.isEmpty) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: Text("Error"),
                                content: Text("All fields are required!"),
                                actions: [
                                  TextButton(onPressed: () => Navigator.pop(context), child: Text("OK")),
                                ],
                              ),
                            );
                          }else if(_genderController.text.toUpperCase() != '1' && _genderController.text.toUpperCase() != '2')
                              showDialog(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: Text("Error"),
                                  content: Text("Please enter '1' or '2' for gender."),
                                  actions: [
                                    TextButton(onPressed: () => Navigator.pop(context), child: Text("OK")),
                                  ],
                                ),
                              );
                          else if (_passwordController.text !=_confirmPasswordController.text) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: Text("Error"),
                                content: Text("Password needs to match the confirmation password."),
                                actions: [
                                  TextButton(onPressed: () => Navigator.pop(context), child: Text("OK")),
                                ],
                              ),
                            );
                          } else if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(_emailController.text)) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: Text("Error"),
                                content: Text("Incorrect email format.-example@gmail.com"),
                                actions: [
                                  TextButton(onPressed: () => Navigator.pop(context), child: Text("OK")),
                                ],
                              ),
                            );
                          } else if (!RegExp(r"^(?:\+?\d{10}|\d{9})$").hasMatch(_phoneController.text)) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: Text("Error"),
                                content: Text("Incorrect phone format.- 063519756"),
                                actions: [
                                  TextButton(onPressed: () => Navigator.pop(context), child: Text("OK")),
                                ],
                              ),
                            );
                          } else {
                            Map order = {
                              "ime": _firstnameController.text,
                              "prezime": _lastnameController.text,
                              "username": _usernameController.text,
                              "email": _emailController.text,
                              "telefon": _phoneController.text,
                              "adresa": _addressController.text,
                              "password": _passwordController.text,
                              "passwordPotvrda": _confirmPasswordController.text,
                              "spolId": _genderController.text,
                              "tipKorisnikaId": 1
                            };

                            var x = await _korisniciProvider.SignUp(order);
                            print(x);
                            if (x != null) {
                              Authorization.username = _usernameController.text;
                              Authorization.password = _passwordController.text;

                              Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => const ProductListScreen()
                              ),
                              );
                            }
                          }
                        },
                        child: Text("CREATE ACCOUNT"),
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Already have an account?"),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => LoginPage()),
                            );
                          },
                          child: Text("Login"),
                        ),
                      ],
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