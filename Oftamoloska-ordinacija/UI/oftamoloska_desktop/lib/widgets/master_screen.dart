import 'package:oftamoloska_desktop/screens/product_list_screen.dart';
import 'package:oftamoloska_desktop/screens/home_page_screen.dart';
import 'package:oftamoloska_desktop/screens/termin_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../providers/korisnik_provider.dart';
import '../screens/izvjestaj_screen.dart';
import '../screens/orders_screen.dart';

class MasterScreenWidget extends StatefulWidget {
  final Widget? child;
  final String? title;
  final Widget? title_widget;
  final bool showBackButton;
  const MasterScreenWidget({
    this.child,
    this.title,
    this.title_widget,
    this.showBackButton = true,
    Key? key,
  }) : super(key: key);

  @override
  State<MasterScreenWidget> createState() => _MasterScreenWidgetState();
}

class _MasterScreenWidgetState extends State<MasterScreenWidget> {
  @override
  Widget build(BuildContext context) {
    final iconColor = Colors.green[800];
    final textStyle = TextStyle(color: iconColor, fontSize: 16);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[800],
        title: widget.title_widget ?? Text(widget.title ?? ""),
        actions: [
          if (widget.showBackButton && Navigator.canPop(context))
            TextButton.icon(
              onPressed: () => Navigator.pop(context, 'reload2'),
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              label: const Text("Back", style: TextStyle(color: Colors.white)),
            ),
        ],
      ),
      drawer: Drawer(
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(color: Colors.green[800]),
                child: Center(
                  child: Text(
                    'OculusPro',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.home, color: iconColor),
                title: Text('Home page', style: textStyle),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => HomePageScreen()),
                ),
              ),
              ListTile(
                leading: Icon(Icons.shopping_bag, color: iconColor),
                title: Text('Products', style: textStyle),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const ProductListScreen()),
                ),
              ),
              ListTile(
                leading: Icon(Icons.list_alt, color: iconColor),
                title: Text('Orders', style: textStyle),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const OrdersScreen()),
                ),
              ),
              ListTile(
                leading: Icon(Icons.event, color: iconColor),
                title: Text('Appointments', style: textStyle),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const TerminiScreen()),
                ),
              ),
              ListTile(
                leading: Icon(Icons.insert_drive_file, color: iconColor),
                title: Text('Reports', style: textStyle),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const IzvjestajScreen()),
                ),
              ),
              const Divider(),
              ListTile(
                leading: Icon(Icons.logout, color: iconColor),
                title: Text('Log Out', style: textStyle),
                onTap: () {
                  Provider.of<KorisniciProvider>(context, listen: false).logout();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => LoginPage()),
                    (_) => false,
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: widget.child,
    );
  }
}
