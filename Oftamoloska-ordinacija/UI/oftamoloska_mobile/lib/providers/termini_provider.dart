import 'package:oftamoloska_mobile/providers/base_provider.dart';
import '../models/termin.dart';

class TerminiProvider<T> extends BaseProvider<Termin>{
  TerminiProvider(): super("Termin");  
 
 @override
  Termin fromJson(data) {
    return Termin.fromJson(data);
  }
}