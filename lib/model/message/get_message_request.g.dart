// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_message_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetMessageRequest _$GetMessageRequestFromJson(Map<String, dynamic> json) =>
    GetMessageRequest(
      json['room_id'] as String,
      json['page'] as int?,
    );

Map<String, dynamic> _$GetMessageRequestToJson(GetMessageRequest instance) =>
    <String, dynamic>{
      'room_id': instance.roomId,
      'page': instance.page,
    };
