// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UserDto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserDto _$UserDtoFromJson(Map<String, dynamic> json) => UserDto(
      vorname: json['vorname'] as String?,
      nachname: json['nachname'] as String?,
      strase: json['strase'] as String?,
      hausnummer: json['hausnummer'] as String?,
      plz: json['plz'] as String?,
      stadt: json['stadt'] as String?,
      profil: json['profil'] as String?,
      userid: json['userid'] as String?,
      email: json['email'] as String,
      passwort: json['passwort'] as String,
    );

Map<String, dynamic> _$UserDtoToJson(UserDto instance) => <String, dynamic>{
      'vorname': instance.vorname,
      'nachname': instance.nachname,
      'strase': instance.strase,
      'hausnummer': instance.hausnummer,
      'plz': instance.plz,
      'stadt': instance.stadt,
      'profil': instance.profil,
      'userid': instance.userid,
      'email': instance.email,
      'passwort': instance.passwort,
    };
