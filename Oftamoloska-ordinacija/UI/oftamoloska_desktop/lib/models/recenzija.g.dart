// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recenzija.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Recenzija _$RecenzijaFromJson(Map<String, dynamic> json) => Recenzija(
      (json['recenzijaId'] as num?)?.toInt(),
      json['sadrzaj'] as String?,
      json['datum'] == null ? null : DateTime.parse(json['datum'] as String),
      (json['proizvodId'] as num?)?.toInt(),
      (json['korisnikId'] as num?)?.toInt(),
    );

Map<String, dynamic> _$RecenzijaToJson(Recenzija instance) => <String, dynamic>{
      'recenzijaId': instance.recenzijaId,
      'sadrzaj': instance.sadrzaj,
      'datum': instance.datum?.toIso8601String(),
      'proizvodId': instance.proizvodId,
      'korisnikId': instance.korisnikId,
    };
