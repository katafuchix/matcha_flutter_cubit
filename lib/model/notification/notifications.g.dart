// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notifications.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Notifications _$NotificationsFromJson(Map<String, dynamic> json) =>
    Notifications(
      json['notification_id'] as int,
      json['title'] as String,
      _$enumDecode(_$NoticeTypeEnumMap, json['notice_type'],
          unknownValue: NoticeType.UNKNOWN),
      json['created_at'] as String,
      _$enumDecode(_$NotificationTypeEnumMap, json['notification_type'],
          unknownValue: NotificationType.UNKNOWN),
      json['read'] as bool,
    );

Map<String, dynamic> _$NotificationsToJson(Notifications instance) =>
    <String, dynamic>{
      'notification_id': instance.notificationId,
      'title': instance.title,
      'notice_type': _$NoticeTypeEnumMap[instance.noticeType],
      'created_at': instance.createdAt,
      'notification_type': _$NotificationTypeEnumMap[instance.notificationType],
      'read': instance.read,
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

const _$NoticeTypeEnumMap = {
  NoticeType.EMERGENCY: 'emergency',
  NoticeType.NORMAL: 'normal',
  NoticeType.UNKNOWN: 'UNKNOWN',
};

const _$NotificationTypeEnumMap = {
  NotificationType.COMMON: 'common',
  NotificationType.USER: 'user',
  NotificationType.UNKNOWN: 'UNKNOWN',
};
