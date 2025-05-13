import 'package:oftamoloska_mobile/providers/base_provider.dart';
import '../models/vrste_proizvoda.dart';

class VrsteProizvodaProvider<T> extends BaseProvider<VrsteProizvoda>{
  VrsteProizvodaProvider(): super("VrstaProizvodum"); 

  @override
  VrsteProizvoda fromJson(data) {
    return VrsteProizvoda.fromJson(data);
  }

}