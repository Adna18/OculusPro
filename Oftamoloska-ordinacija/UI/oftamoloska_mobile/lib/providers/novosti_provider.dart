import 'package:oftamoloska_mobile/providers/base_provider.dart';
import '../models/novost.dart';

class NovostiProvider<T> extends BaseProvider<Novost>{
  NovostiProvider(): super("Novosti"); 

  @override
  Novost fromJson(data) {
    return Novost.fromJson(data);
  }

}