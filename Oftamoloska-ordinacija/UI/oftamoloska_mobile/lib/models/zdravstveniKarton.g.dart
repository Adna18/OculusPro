// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'zdravstveniKarton.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ZdravstveniKarton _$ZdravstveniKartonFromJson(Map<String, dynamic> json) =>
    ZdravstveniKarton(
      (json['zdravstveniKartonId'] as num?)?.toInt(),
      json['sadrzaj'] as String?,
      (json['korisnikId'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ZdravstveniKartonToJson(ZdravstveniKarton instance) =>
    <String, dynamic>{
      'zdravstveniKartonId': instance.zdravstveniKartonId,
      'sadrzaj': instance.sadrzaj,
      'korisnikId': instance.korisnikId,
    };
