// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stavkaNarudzbe.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StavkaNarudzbe _$StavkaNarudzbeFromJson(Map<String, dynamic> json) =>
    StavkaNarudzbe(
      (json['stavkaNarudzbeId'] as num?)?.toInt(),
      (json['kolicina'] as num?)?.toInt(),
      (json['proizvodId'] as num?)?.toInt(),
      (json['narudzbaId'] as num?)?.toInt(),
    );

Map<String, dynamic> _$StavkaNarudzbeToJson(StavkaNarudzbe instance) =>
    <String, dynamic>{
      'stavkaNarudzbeId': instance.stavkaNarudzbeId,
      'kolicina': instance.kolicina,
      'proizvodId': instance.proizvodId,
      'narudzbaId': instance.narudzbaId,
    };
