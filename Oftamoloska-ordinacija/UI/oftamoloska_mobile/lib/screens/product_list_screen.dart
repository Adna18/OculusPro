import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:oftamoloska_mobile/providers/korisnik_provider.dart';
import 'package:oftamoloska_mobile/providers/product_provider.dart';
import 'package:oftamoloska_mobile/screens/product_detail_screen.dart';
import 'package:oftamoloska_mobile/utils/util.dart';
import 'package:oftamoloska_mobile/widgets/master_screen.dart';
import '../models/product.dart';
import '../models/search_result.dart';
import '../providers/cart_provider.dart';
import '../providers/favorites_provider.dart';
import '../providers/recommend_result_provider.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({Key? key}) : super(key: key);

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  late ProductProvider _productProvider;
  late CartProvider _cartProvider;
  late FavoritesProvider _favoritesProvider;
  late KorisniciProvider _korisniciProvider;
  SearchResult<Product>? result;
  SearchResult<Product>? resultRecomm;
  bool isLoading = true;
  TextEditingController _ftsController = TextEditingController();
  TextEditingController _sifraController = TextEditingController();
  final _formKey = GlobalKey<FormBuilderState>();
  List<Product> dataRecomm = [];
  late RecommendResultProvider _recommendResultProvider;
  String _selectedSortDirection = 'ascending';

  @override
  void initState() {
    super.initState();
    _fetchProducts();
    _favoritesProvider = Provider.of<FavoritesProvider>(context, listen: false);
    _korisniciProvider = Provider.of<KorisniciProvider>(context, listen: false);
    _recommendResultProvider = context.read<RecommendResultProvider>();
  }

  Future<void> _fetchProducts() async {
    try {
      _productProvider = Provider.of<ProductProvider>(context, listen: false);
      _cartProvider = Provider.of<CartProvider>(context, listen: false);
      var data = await _productProvider.get(filter: {
        'fts': _ftsController.text,
        'sifra': _sifraController.text,
      });

      setState(() {
        result = data;
        if (_selectedSortDirection == 'ascending') {
          result?.result.sort((a, b) => a.cijena!.compareTo(b.cijena!));
        } else {
          result?.result.sort((a, b) => b.cijena!.compareTo(a.cijena!));
        }
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
    return MasterScreenWidget(
      title_widget: Text(
        "Products",
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSearch(),
              const SizedBox(height: 20),
              Text(
                "All Products",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.blueGrey,
                ),
              ),
              const SizedBox(height: 10),
              _buildProductGrid(result, false),
              const SizedBox(height: 30),
              Text(
                "Recommended for You",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.blueGrey,
                ),
              ),
              const SizedBox(height: 10),
              _buildProductGrid(resultRecomm, true),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearch() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: FormBuilder(
          key: _formKey,
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    labelText: "Search products",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                  controller: _ftsController,
                  onChanged: (_) => _fetchProducts(),
                ),
              ),
              const SizedBox(width: 10),
              DropdownButton<String>(
                value: _selectedSortDirection,
                onChanged: (newValue) {
                  setState(() {
                    _selectedSortDirection = newValue!;
                    _fetchProducts();
                  });
                },
                items: <String>['ascending', 'descending']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value == 'ascending' ? 'Price: Low to High' : 'Price: High to Low',
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductGrid(dataX, bool isRecommended) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (dataX?.result == null || dataX.result.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Center(
          child: Text(
            isRecommended ? "No recommendations available" : "No products found",
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
      ),
      itemCount: dataX.result.length,
      itemBuilder: (context, index) {
        final product = dataX.result[index];
        return _buildProductCard(product);
      },
    );
  }

  Widget _buildProductCard(Product product) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
         
          Expanded(
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ProductDetailsScreen(product),
                  ),
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                child: Container(
                  color: Colors.grey[100],
                 child: product.slika?.isEmpty ?? true
                      ? Image.asset(
                          "assets/images/no-image.jpg",
                          fit: BoxFit.contain,
                        )
                      : imageFromBase64String(product.slika!),
                ),
              ),
            ),
          ),
         
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.naziv ?? "",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 5),
                Text(
                  "${formatNumber(product.cijena)}",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.favorite_border),
                  color: Colors.grey,
                  onPressed: () async {
                    final isProductFavorite = await _favoritesProvider.exists(product.proizvodId!);

                    if (!isProductFavorite) {
                      _favoritesProvider.sendRabbit({
                        "datumDodavanja": DateTime.now().toUtc().toIso8601String(),
                        "ProizvodId": product.proizvodId,
                        "KorisnikId": await getPatientId(),
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.green,
                          duration: Duration(milliseconds: 1000),
                          content: Text("Added to favorites"),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Already in favorites"),
                        ),
                      );
                    }
                  },
                ),
                IconButton(
                  icon: Icon(Icons.shopping_cart),
                  color: Theme.of(context).primaryColor,
                  onPressed: () async {
                    _cartProvider.addToCart(product);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.green,
                        duration: Duration(milliseconds: 1000),
                        content: Text("Added to cart"),
                      ),
                    );

                    try {
                      var recommendResult = await _recommendResultProvider.get();
                      var filteredRecommendation = recommendResult.result
                          .where((x) => x.proizvodId == product.proizvodId)
                          .toList();
                      if (filteredRecommendation.isNotEmpty) {
                        var matchingRecommendation = filteredRecommendation.first;

                        int prviProizvodID = matchingRecommendation.prviProizvodId!;
                        int drugiProizvodID = matchingRecommendation.drugiProizvodId!;
                        int treciProizvodID = matchingRecommendation.treciProizvodId!;

                        var prviRecommendedProduct = await _productProvider.getById(prviProizvodID);
                        var drugiRecommendedProduct = await _productProvider.getById(drugiProizvodID);
                        var treciRecommendedProduct = await _productProvider.getById(treciProizvodID);

                        setState(() {
                          resultRecomm = SearchResult<Product>()
                            ..result = [prviRecommendedProduct, drugiRecommendedProduct, treciRecommendedProduct]
                            ..count = 3;
                        });
                      }
                    } on Exception catch (e) {
                      print(e);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<int> getPatientId() async {
    final pacijenti = await _korisniciProvider.get(filter: {
      'tipKorisnika': 'pacijent',
    });

    final pacijent = pacijenti.result.firstWhere(
        (korisnik) => korisnik.username == Authorization.username);

    return pacijent.korisnikId!;
  }
}