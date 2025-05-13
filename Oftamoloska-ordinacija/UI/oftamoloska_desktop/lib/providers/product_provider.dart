
import 'package:oftamoloska_desktop/models/product.dart';
import 'package:oftamoloska_desktop/providers/base_provider.dart';

class ProductProvider extends BaseProvider<Product> {
  ProductProvider(): super("Proizvodi");

   @override
  Product fromJson(data) {
    // TODO: implement fromJson
    return Product.fromJson(data);
  }

 
}