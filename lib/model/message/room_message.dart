import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import '../IModel.dart';
import 'message_type.dart';

part 'room_message.g.dart';

@JsonSerializable()
class RoomMessage extends IModel {
  @JsonKey(name: 'id')
  int id;
  @JsonKey(name: 'room_id')
  String roomId;
  @JsonKey(name: 'sender_user_id')
  int senderUserId;
  @JsonKey(name: 'receiver_user_id')
  int receiverUserId;
  @JsonKey(name: 'type')
  MessageType type;
  @JsonKey(name: 'content')
  String content;
  @JsonKey(name: 'is_paid')
  bool? isPaid;
  @JsonKey(name: 'created_at')
  String createdAt;
  @JsonKey(name: 'is_read')
  bool isRead;

  RoomMessage(this.id, this.roomId, this.senderUserId, this.receiverUserId,
      this.type, this.content, this.isPaid, this.createdAt, this.isRead);

  factory RoomMessage.fromJson(Map<String, dynamic> json) =>
      _$RoomMessageFromJson(json);

  Map<String, dynamic> toJson() => _$RoomMessageToJson(this);

  @override
  String toString() => jsonEncode(this);
}
