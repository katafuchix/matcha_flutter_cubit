import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import '../IModel.dart';

part 'matching_request.g.dart';

@JsonSerializable()
class MatchingRequest extends IModel {
  @JsonKey(name: 'target_user_id')
  int targetUserId;

  MatchingRequest(this.targetUserId);

  factory MatchingRequest.fromJson(Map<String, dynamic> json) =>
      _$MatchingRequestFromJson(json);

  Map<String, dynamic> toJson() => _$MatchingRequestToJson(this);

  @override
  String toString() => jsonEncode(this);
}
