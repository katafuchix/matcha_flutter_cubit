// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RoomMessage _$RoomMessageFromJson(Map<String, dynamic> json) => RoomMessage(
      json['id'] as int,
      json['room_id'] as String,
      json['sender_user_id'] as int,
      json['receiver_user_id'] as int,
      _$enumDecode(_$MessageTypeEnumMap, json['type']),
      json['content'] as String,
      json['is_paid'] as bool?,
      json['created_at'] as String,
      json['is_read'] as bool,
    );

Map<String, dynamic> _$RoomMessageToJson(RoomMessage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'room_id': instance.roomId,
      'sender_user_id': instance.senderUserId,
      'receiver_user_id': instance.receiverUserId,
      'type': _$MessageTypeEnumMap[instance.type],
      'content': instance.content,
      'is_paid': instance.isPaid,
      'created_at': instance.createdAt,
      'is_read': instance.isRead,
    };

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}

const _$MessageTypeEnumMap = {
  MessageType.TEXT: 'text',
  MessageType.PHOTO: 'photo',
};
