import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import '../IModel.dart';
import 'message_type.dart';

part 'send_message.g.dart';

@JsonSerializable()
class SendMessage extends IModel {
  @JsonKey(name: 'room_id')
  String roomId;
  @JsonKey(name: 'message_type')
  MessageType messageType;
  @JsonKey(name: 'message')
  String? message;
  @JsonKey(name: 'image')
  String? image;

  SendMessage(
      {required this.roomId,
      required this.messageType,
      this.message,
      this.image});

  factory SendMessage.fromJson(Map<String, dynamic> json) =>
      _$SendMessageFromJson(json);

  factory SendMessage.asMessage(
          {required String roomId, required String message}) =>
      SendMessage(
          roomId: roomId, messageType: MessageType.TEXT, message: message);

  factory SendMessage.asImage(
          {required String roomId, required String base64Image}) =>
      SendMessage(
          roomId: roomId,
          messageType: MessageType.PHOTO,
          image: 'data:image/jpeg;base64,$base64Image');

  Map<String, dynamic> toJson() => _$SendMessageToJson(this);

  @override
  String toString() => jsonEncode(this);
}
