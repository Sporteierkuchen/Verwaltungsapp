import 'package:json_annotation/json_annotation.dart';
import 'package:verwaltungsapp/dto/MengeDTO.dart';

part 'ArticleDTO.g.dart';

@JsonSerializable()

class ArticleDTO {

  @JsonKey(includeIfNull: false)
  int? artikel_id;

  String logo;
  String name;
  int sollmenge;

  @JsonKey(includeIfNull: false)
  int? istmenge;

  int warnzeit;

  List<MengeDTO>? mengenListe = [];

  ArticleDTO({

    this.artikel_id,
    required this.logo,
    required this.name,
    required this.sollmenge,
    this.istmenge,
    required this.warnzeit,
    this.mengenListe

  });

  factory ArticleDTO.fromJson(Map<String, dynamic> json) =>
      _$ArticleDTOFromJson(json);

  Map<String, dynamic> toJson() => _$ArticleDTOToJson(this);
}
