// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorites.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Favorites _$FavoritesFromJson(Map<String, dynamic> json) => Favorites(
  (json['omiljeniProizvodId'] as num?)?.toInt(),
  json['datumDodavanja'] == null
      ? null
      : DateTime.parse(json['datumDodavanja'] as String),
  (json['proizvodId'] as num?)?.toInt(),
  (json['korisnikId'] as num?)?.toInt(),
);

Map<String, dynamic> _$FavoritesToJson(Favorites instance) => <String, dynamic>{
  'omiljeniProizvodId': instance.omiljeniProizvodId,
  'datumDodavanja': instance.datumDodavanja?.toIso8601String(),
  'proizvodId': instance.proizvodId,
  'korisnikId': instance.korisnikId,
};
