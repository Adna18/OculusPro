import 'package:oftamoloska_desktop/models/zdravstveni_karton.dart';
import 'package:oftamoloska_desktop/providers/base_provider.dart';

class ZdravstveniKartonProvider<T> extends BaseProvider<ZdravstveniKarton>{
  ZdravstveniKartonProvider(): super("ZdravstveniKarton"); 

  @override
  ZdravstveniKarton fromJson(data) {
    return ZdravstveniKarton.fromJson(data);
  }

}