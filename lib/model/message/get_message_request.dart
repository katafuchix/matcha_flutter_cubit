import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import '../IModel.dart';

part 'get_message_request.g.dart';

@JsonSerializable()
class GetMessageRequest extends IModel {
  @JsonKey(name: 'room_id')
  String roomId;
  @JsonKey(name: 'page')
  final int? page;

  GetMessageRequest(this.roomId, this.page);

  factory GetMessageRequest.fromJson(Map<String, dynamic> json) =>
      _$GetMessageRequestFromJson(json);

  Map<String, dynamic> toJson() => _$GetMessageRequestToJson(this);

  @override
  String toString() => jsonEncode(this);
}
