// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UserDto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserDto _$UserDtoFromJson(Map<String, dynamic> json) => UserDto(
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      userNumber: json['userNumber'] as String?,
      email: json['email'] as String?,
      uuid: json['uuid'] as String?,
      password: json['password'] as String?,
    );

Map<String, dynamic> _$UserDtoToJson(UserDto instance) => <String, dynamic>{
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'userNumber': instance.userNumber,
      'email': instance.email,
      'uuid': instance.uuid,
      'password': instance.password,
    };
