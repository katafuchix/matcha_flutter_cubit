import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import '../IModel.dart';

part 'matching_response.g.dart';

@JsonSerializable()
class MatchingResponse extends IModel {
  @JsonKey(name: 'room_id')
  String roomId;
  @JsonKey(name: 'target_user_id')
  int targetUserId;
  @JsonKey(name: 'created_at')
  String createdAt;

  MatchingResponse(this.roomId, this.targetUserId, this.createdAt);

  factory MatchingResponse.fromJson(Map<String, dynamic> json) =>
      _$MatchingResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MatchingResponseToJson(this);

  @override
  String toString() => jsonEncode(this);
}
