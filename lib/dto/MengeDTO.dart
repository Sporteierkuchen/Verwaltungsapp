import 'package:json_annotation/json_annotation.dart';

part 'MengeDTO.g.dart';

@JsonSerializable()

class MengeDTO {

  int? mengen_id;
  int artikel_id;
  String datum;
  int menge;

  MengeDTO({

    this.mengen_id,
    required this.artikel_id,
    required this.datum,
    required this.menge

  });

  factory MengeDTO.fromJson(Map<String, dynamic> json) =>
      _$MengeDTOFromJson(json);

  Map<String, dynamic> toJson() => _$MengeDTOToJson(this);
}