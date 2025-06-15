import 'package:oftamoloska_desktop/providers/base_provider.dart';
import '../models/transakcija.dart';

class TransakcijaProvider extends BaseProvider<Transakcija> {
  TransakcijaProvider() : super("Transakcija");

  @override
  Transakcija fromJson(data) {
    return Transakcija.fromJson(data);
  }
}
