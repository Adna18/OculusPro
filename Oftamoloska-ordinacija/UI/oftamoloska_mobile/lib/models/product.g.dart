// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map<String, dynamic> json) => Product(
  (json['proizvodId'] as num?)?.toInt(),
  json['naziv'] as String?,
  json['sifra'] as String?,
  (json['cijena'] as num?)?.toDouble(),
  json['slika'] as String?,
  (json['vrstaId'] as num?)?.toInt(),
);

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
  'proizvodId': instance.proizvodId,
  'naziv': instance.naziv,
  'sifra': instance.sifra,
  'cijena': instance.cijena,
  'slika': instance.slika,
  'vrstaId': instance.vrstaId,
};
