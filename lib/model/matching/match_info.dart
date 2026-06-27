import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import '../IModel.dart';

part 'match_info.g.dart';

@JsonSerializable()
class MatchInfo extends IModel {
  // user id
  @JsonKey(name: 'id')
  int id;
  @JsonKey(name: 'room_id')
  String roomId;
  @JsonKey(name: 'message')
  String? message;
  @JsonKey(name: 'message_created_at')
  String? messageCreatedAt;
  @JsonKey(name: 'last_updated_at')
  String lastUpdatedAt;
  @JsonKey(name: 'unread_count')
  int unreadCount;

  MatchInfo(this.id, this.roomId, this.message, this.messageCreatedAt,
      this.lastUpdatedAt, this.unreadCount);

  factory MatchInfo.fromJson(Map<String, dynamic> json) =>
      _$MatchInfoFromJson(json);

  Map<String, dynamic> toJson() => _$MatchInfoToJson(this);

  @override
  String toString() => jsonEncode(this);
}
