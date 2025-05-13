import 'package:oftamoloska_desktop/models/vrste_proizvoda.dart';
import 'package:oftamoloska_desktop/providers/base_provider.dart';

class VrsteProizvodaProvider<T> extends BaseProvider<VrsteProizvoda>{
  VrsteProizvodaProvider(): super("VrstaProizvodum"); 

  @override
  VrsteProizvoda fromJson(data) {
    return VrsteProizvoda.fromJson(data);
  }

}