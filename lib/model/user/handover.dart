import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import '../IModel.dart';

part 'handover.g.dart';

@JsonSerializable()
class HandOver extends IModel {
  @JsonKey(name: 'email')
  String email;
  @JsonKey(name: 'password')
  String password;

  HandOver(this.email, this.password);

  factory HandOver.fromJson(Map<String, dynamic> json) {
    return _$HandOverFromJson(json);
  }

  Map<String, dynamic> toJson() => _$HandOverToJson(this);

  @override
  String toString() => jsonEncode(this);
}
