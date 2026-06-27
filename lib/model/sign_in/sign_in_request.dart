import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import '../IModel.dart';

part 'sign_in_request.g.dart';

@JsonSerializable()
class SignInRequest extends IModel {
  @JsonKey(name: 'email')
  String email;
  String password;

  SignInRequest(
    this.email,
    this.password,
  );

  factory SignInRequest.fromJson(Map<String, dynamic> json) =>
      _$SignInRequestFromJson(json);

  Map<String, dynamic> toJson() => _$SignInRequestToJson(this);

  @override
  String toString() => jsonEncode(this);
}
