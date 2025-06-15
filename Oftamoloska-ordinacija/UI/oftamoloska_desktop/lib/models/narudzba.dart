import 'package:json_annotation/json_annotation.dart';
import 'package:oftamoloska_desktop/models/korisnik.dart';

part 'narudzba.g.dart';

@JsonSerializable()
class Narudzba{
	int? narudzbaId;
  String? brojNarudzbe; 
  String? status; 
  DateTime? datum; 
  double? iznos;
  int? korisnikId;
  Korisnik? korisnik;
  

  Narudzba(this.narudzbaId, this.brojNarudzbe, this.status, this.datum, this.iznos, this.korisnikId, [this.korisnik]);

  factory Narudzba.fromJson(Map<String, dynamic> json) => _$NarudzbaFromJson(json);

  Map<String, dynamic> toJson() => _$NarudzbaToJson(this);

}