import 'package:json_annotation/json_annotation.dart';

part 'UserDto.g.dart';

@JsonSerializable()
class UserDto {
  String? firstName;
  String? lastName;

  String? userNumber;
  String? email;
  String? uuid;
  String? password;

  UserDto({
    this.firstName,
    this.lastName,


    this.userNumber,
    this.email,
    this.uuid,
    this.password
  });

  factory UserDto.fromJson(Map<String, dynamic> json) =>
      _$UserDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UserDtoToJson(this);
}
