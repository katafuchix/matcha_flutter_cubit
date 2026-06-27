// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'matching_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MatchingResponse _$MatchingResponseFromJson(Map<String, dynamic> json) =>
    MatchingResponse(
      json['room_id'] as String,
      json['target_user_id'] as int,
      json['created_at'] as String,
    );

Map<String, dynamic> _$MatchingResponseToJson(MatchingResponse instance) =>
    <String, dynamic>{
      'room_id': instance.roomId,
      'target_user_id': instance.targetUserId,
      'created_at': instance.createdAt,
    };
