// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'termin.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Termin _$TerminFromJson(Map<String, dynamic> json) => Termin(
  (json['terminId'] as num?)?.toInt(),
  (json['korisnikIdDoktor'] as num?)?.toInt(),
  (json['korisnikIdPacijent'] as num?)?.toInt(),
  json['datum'] == null ? null : DateTime.parse(json['datum'] as String),
);

Map<String, dynamic> _$TerminToJson(Termin instance) => <String, dynamic>{
  'terminId': instance.terminId,
  'korisnikIdDoktor': instance.korisnikIdDoktor,
  'korisnikIdPacijent': instance.korisnikIdPacijent,
  'datum': instance.datum?.toIso8601String(),
};
