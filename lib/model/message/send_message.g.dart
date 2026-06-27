// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'send_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SendMessage _$SendMessageFromJson(Map<String, dynamic> json) => SendMessage(
      roomId: json['room_id'] as String,
      messageType: _$enumDecode(_$MessageTypeEnumMap, json['message_type']),
      message: json['message'] as String?,
      image: json['image'] as String?,
    );

Map<String, dynamic> _$SendMessageToJson(SendMessage instance) =>
    <String, dynamic>{
      'room_id': instance.roomId,
      'message_type': _$MessageTypeEnumMap[instance.messageType],
      'message': instance.message,
      'image': instance.image,
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
