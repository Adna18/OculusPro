import 'package:json_annotation/json_annotation.dart';

part 'product.g.dart';

@JsonSerializable()
class Product{
  int? proizvodId;
  String? naziv;
  String? sifra;
  double? cijena;
  String? slika;
  bool? dostupno;
  int? vrstaId;

  Product(this.proizvodId, this.naziv, this.sifra, this.cijena, this.slika, this.dostupno, this.vrstaId);

  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);

  Map<String, dynamic> toJson() => _$ProductToJson(this);

}