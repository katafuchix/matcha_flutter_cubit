import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import '../IModel.dart';
import '../basic/sex.dart';

part 'sign_up_response.g.dart';

@JsonSerializable()
class SignUpResponse extends IModel {
  @JsonKey(name: 'user_id')
  int userId;
  @JsonKey(name: 'nickname')
  String nickname;
  @JsonKey(name: 'sex')
  SexAsResponse sex;
  @JsonKey(name: 'birthday')
  String birthday;
  @JsonKey(name: 'authentication_token')
  String? authenticationToken;

  SignUpResponse(this.userId, this.nickname, this.sex, this.birthday);

  factory SignUpResponse.fromJson(Map<String, dynamic> json) =>
      _$SignUpResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SignUpResponseToJson(this);

  @override
  String toString() => jsonEncode(this);
}
