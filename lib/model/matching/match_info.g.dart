// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'match_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MatchInfo _$MatchInfoFromJson(Map<String, dynamic> json) => MatchInfo(
      json['id'] as int,
      json['room_id'] as String,
      json['message'] as String?,
      json['message_created_at'] as String?,
      json['last_updated_at'] as String,
      json['unread_count'] as int,
    );

Map<String, dynamic> _$MatchInfoToJson(MatchInfo instance) => <String, dynamic>{
      'id': instance.id,
      'room_id': instance.roomId,
      'message': instance.message,
      'message_created_at': instance.messageCreatedAt,
      'last_updated_at': instance.lastUpdatedAt,
      'unread_count': instance.unreadCount,
    };
