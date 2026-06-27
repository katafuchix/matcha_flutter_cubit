import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import '../IModel.dart';

part 'target_user_action.g.dart';

@JsonSerializable()
class TargetUserAction extends IModel {
  @JsonKey(name: 'target_user_id')
  int targetUserId;

  TargetUserAction(this.targetUserId);

  factory TargetUserAction.fromJson(Map<String, dynamic> json) {
    return _$TargetUserActionFromJson(json);
  }

  Map<String, dynamic> toJson() => _$TargetUserActionToJson(this);

  @override
  String toString() => jsonEncode(this);
}
