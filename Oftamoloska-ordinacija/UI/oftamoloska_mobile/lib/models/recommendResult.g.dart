// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recommendResult.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecommendResult _$RecommendResultFromJson(Map<String, dynamic> json) =>
    RecommendResult(
      (json['proizvodId'] as num?)?.toInt(),
      (json['drugiProizvodId'] as num?)?.toInt(),
      (json['treciProizvodId'] as num?)?.toInt(),
    )..prviProizvodId = (json['prviProizvodId'] as num?)?.toInt();

Map<String, dynamic> _$RecommendResultToJson(RecommendResult instance) =>
    <String, dynamic>{
      'proizvodId': instance.proizvodId,
      'prviProizvodId': instance.prviProizvodId,
      'drugiProizvodId': instance.drugiProizvodId,
      'treciProizvodId': instance.treciProizvodId,
    };
