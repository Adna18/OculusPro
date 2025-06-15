// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'narudzba.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Narudzba _$NarudzbaFromJson(Map<String, dynamic> json) => Narudzba(
      (json['narudzbaId'] as num?)?.toInt(),
      json['brojNarudzbe'] as String?,
      json['status'] as String?,
      json['datum'] == null ? null : DateTime.parse(json['datum'] as String),
      (json['iznos'] as num?)?.toDouble(),
      (json['korisnikId'] as num?)?.toInt(),
      json['korisnik'] == null
          ? null
          : Korisnik.fromJson(json['korisnik'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$NarudzbaToJson(Narudzba instance) => <String, dynamic>{
      'narudzbaId': instance.narudzbaId,
      'brojNarudzbe': instance.brojNarudzbe,
      'status': instance.status,
      'datum': instance.datum?.toIso8601String(),
      'iznos': instance.iznos,
      'korisnikId': instance.korisnikId,
      'korisnik': instance.korisnik,
    };
