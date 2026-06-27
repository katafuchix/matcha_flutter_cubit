import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import '../IModel.dart';

part 'target_user_id.g.dart';

@JsonSerializable()
class TargetUserRequest extends IModel {
  @JsonKey(name: 'user_id')
  int userId;

  TargetUserRequest(this.userId);

  factory TargetUserRequest.fromJson(Map<String, dynamic> json) {
    return _$TargetUserRequestFromJson(json);
  }

  Map<String, dynamic> toJson() => _$TargetUserRequestToJson(this);

  @override
  String toString() => jsonEncode(this);
}
