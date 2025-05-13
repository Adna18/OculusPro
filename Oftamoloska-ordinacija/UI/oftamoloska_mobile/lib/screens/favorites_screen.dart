import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:oftamoloska_mobile/providers/favorites_provider.dart';
import 'package:oftamoloska_mobile/providers/korisnik_provider.dart';
import 'package:oftamoloska_mobile/utils/util.dart';
import 'package:provider/provider.dart';

import '../models/favorites.dart';
import '../models/product.dart';
import '../providers/product_provider.dart';
import '../widgets/master_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late FavoritesProvider _favoritesProvider;
  late KorisniciProvider _korisniciProvider;
  late ProductProvider _productProvider;
  List<Favorites> favoriteProducts = [];

  @override
  void initState() {
    super.initState();
    _favoritesProvider = Provider.of<FavoritesProvider>(context, listen: false);
    _korisniciProvider = Provider.of<KorisniciProvider>(context, listen: false);
    _productProvider = Provider.of<ProductProvider>(context, listen: false);

    _fetchFavorites();
  }

  Future<void> _fetchFavorites() async {
    try {
      final patientId = await getPatientId();
      var data = await _favoritesProvider.get(filter: {
        'korisnikId': patientId.toString(),
      });
      setState(() {
        favoriteProducts = data.result;
      });
    } catch (e) {
      print("Greška prilikom dohvata omiljenih proizvoda: $e");
    }
  }

  Future<int> getPatientId() async {
    final pacijenti = await _korisniciProvider.get(filter: {
      'tipKorisnika': 'pacijent',
    });

    final pacijent = pacijenti.result.firstWhere(
      (korisnik) => korisnik.username == Authorization.username,
    );

    return pacijent.korisnikId!;
  }

  Future<Product?> _getProduct(int proizvodId) async {
    return await _productProvider.getById(proizvodId);
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title_widget: const Text("Favorites"),
      child: SingleChildScrollView(
        child: Column(
          children: favoriteProducts.map((favorite) {
            return FutureBuilder<Product?>(
              future: _getProduct(favorite.proizvodId!),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
                  return const Text('Error loading product');
                } else {
                  final product = snapshot.data!;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.memory(
                            base64Decode(product.slika!),
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          color: Colors.red,
                          tooltip: "Remove from favorites",
                          onPressed: () => _deleteFavorite(favorite.omiljeniProizvodId),
                        ),
                      ],
                    ),
                  );
                }
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  Future<void> _deleteFavorite(int? omiljeniProizvodId) async {
    try {
      await _favoritesProvider.delete(omiljeniProizvodId);
      await _fetchFavorites();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Product successfully removed from favorites.")),
      );
    } catch (e) {
      print("Greška prilikom brisanja: $e");
    }
  }
}
