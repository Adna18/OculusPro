// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dojam.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Dojam _$DojamFromJson(Map<String, dynamic> json) => Dojam(
  json['isLiked'] as bool?,
  (json['korisnikId'] as num?)?.toInt(),
  (json['proizvodId'] as num?)?.toInt(),
);

Map<String, dynamic> _$DojamToJson(Dojam instance) => <String, dynamic>{
  'isLiked': instance.isLiked,
  'korisnikId': instance.korisnikId,
  'proizvodId': instance.proizvodId,
};
