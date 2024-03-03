// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'MengeDTO.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MengeDTO _$MengeDTOFromJson(Map<String, dynamic> json) => MengeDTO(
      mengen_id: json['mengen_id'] as int?,
      artikel_id: json['artikel_id'] as int,
      datum: json['datum'] as String,
      menge: json['menge'] as int,
    );

Map<String, dynamic> _$MengeDTOToJson(MengeDTO instance) => <String, dynamic>{
      'mengen_id': instance.mengen_id,
      'artikel_id': instance.artikel_id,
      'datum': instance.datum,
      'menge': instance.menge,
    };
