import 'package:flutter/material.dart';
import 'package:oftamoloska_mobile/screens/product_list_screen.dart';
import 'package:provider/provider.dart';
import 'package:oftamoloska_mobile/screens/cart_screen.dart';
import 'package:oftamoloska_mobile/screens/favorites_screen.dart';
import 'package:oftamoloska_mobile/screens/home_page_screen.dart';
import 'package:oftamoloska_mobile/screens/my_profile_screen.dart';
import 'package:oftamoloska_mobile/screens/orders_screen.dart';
import 'package:oftamoloska_mobile/screens/termin_screen.dart';
import '../providers/korisnik_provider.dart';
import '../main.dart';

class MasterScreenWidget extends StatefulWidget {
  final Widget? child;
  final String? title;
  final Widget? title_widget; 
  final bool showBackButton;

  MasterScreenWidget({
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[800],
        title: widget.title_widget ?? Text(widget.title ?? ""),
        actions: [
     
          if (widget.showBackButton && !ModalRoute.of(context)!.isFirst) 
            TextButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              label: const Text(
                "Back",
                style: TextStyle(color: Colors.white),
              ),
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
              _buildDrawerItem(Icons.home, 'Home page', HomePageScreen()),
              _buildDrawerItem(Icons.shopping_bag, 'Products', ProductListScreen()),
              _buildDrawerItem(Icons.list_alt, 'Orders', OrdersScreen()),
              _buildDrawerItem(Icons.event, 'Appointments', TerminiScreen()),
              _buildDrawerItem(Icons.shopping_cart, 'Cart', CartScreen()),
              _buildDrawerItem(Icons.favorite, 'Favorites', FavoritesScreen()),
              _buildDrawerItem(Icons.person, 'My Profile', MyProfileScreen()),
              Divider(),
              _buildDrawerItem(Icons.logout, 'Log Out', null, onTap: _logout),
            ],
          ),
        ),
      ),
      body: widget.child,
    );
  }


  ListTile _buildDrawerItem(IconData icon, String title, Widget? screen, {VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.green[800]),
      title: Text(title, style: TextStyle(color: Colors.green[800])),
      onTap: () {
        if (onTap != null) {
          onTap();
        } else if (screen != null) {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
        }
      },
    );
  }

  
  void _logout() {
    final korisniciProvider = Provider.of<KorisniciProvider>(context, listen: false);
    korisniciProvider.logout();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
      (route) => false,
    );
  }
}
