// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ArticleDTO.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ArticleDTO _$ArticleDTOFromJson(Map<String, dynamic> json) => ArticleDTO(
      artikel_id: json['artikel_id'] as int?,
      logo: json['logo'] as String,
      name: json['name'] as String,
      sollmenge: json['sollmenge'] as int,
      istmenge: json['istmenge'] as int?,
      warnzeit: json['warnzeit'] as int,
      mengenListe: (json['mengenListe'] as List<dynamic>?)
          ?.map((e) => MengeDTO.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ArticleDTOToJson(ArticleDTO instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('artikel_id', instance.artikel_id);
  val['logo'] = instance.logo;
  val['name'] = instance.name;
  val['sollmenge'] = instance.sollmenge;
  writeNotNull('istmenge', instance.istmenge);
  val['warnzeit'] = instance.warnzeit;
  val['mengenListe'] = instance.mengenListe;
  return val;
}
