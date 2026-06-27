import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import '../IModel.dart';
import '../basic/sex.dart';

part 'sign_in_response.g.dart';

@JsonSerializable()
class SignInResponse extends IModel {
  @JsonKey(name: 'user_id')
  int userId;
  @JsonKey(name: 'nickname')
  String nickname;
  @JsonKey(name: 'sex')
  SexAsResponse sex;
  @JsonKey(name: 'birthday')
  String birthday;
  @JsonKey(name: 'authentication_token')
  String authenticationToken;

  SignInResponse(this.userId, this.nickname, this.sex, this.birthday,
      this.authenticationToken);

  factory SignInResponse.fromJson(Map<String, dynamic> json) =>
      _$SignInResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SignInResponseToJson(this);

  @override
  String toString() => jsonEncode(this);
}
