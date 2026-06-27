// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_contents.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationContents _$NotificationContentsFromJson(
        Map<String, dynamic> json) =>
    NotificationContents(
      json['body'] as String,
    );

Map<String, dynamic> _$NotificationContentsToJson(
        NotificationContents instance) =>
    <String, dynamic>{
      'body': instance.body,
    };

NotificationContentsRequest _$NotificationContentsRequestFromJson(
        Map<String, dynamic> json) =>
    NotificationContentsRequest(
      json['notification_id'] as int,
      _$enumDecode(_$NotificationTypeEnumMap, json['notification_type']),
    );

Map<String, dynamic> _$NotificationContentsRequestToJson(
        NotificationContentsRequest instance) =>
    <String, dynamic>{
      'notification_id': instance.notificationId,
      'notification_type': _$NotificationTypeEnumMap[instance.notificationType],
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

const _$NotificationTypeEnumMap = {
  NotificationType.COMMON: 'common',
  NotificationType.USER: 'user',
  NotificationType.UNKNOWN: 'UNKNOWN',
};
