import 'package:json_annotation/json_annotation.dart';

part 'UserDto.g.dart';

@JsonSerializable()
class UserDto {
  String? vorname;
  String? nachname;
  String? strase;
  String? hausnummer;
  String? plz;
  String? stadt;
  String? profil;
  String? beschreibung;

  String? userid;
  String? email;
  String? passwort;

  UserDto({
    this.vorname,
    this.nachname,
    this.strase,
    this.hausnummer,
    this.plz,
    this.stadt,
    this.profil,
    this.beschreibung,

    this.userid,
    this.email,
 this.passwort
  });

  // @override
  // String toString() {
  //   // TODO: implement toString
  //   return vorname!+" "+nachname!+" Adresse: "+strase!+" "+hausnummer!+" "+plz!+" "+stadt!+" Email: "+email!+" Passwort: "+passwort!;
  // }


  factory UserDto.fromJson(Map<String, dynamic> json) =>
      _$UserDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UserDtoToJson(this);
}
