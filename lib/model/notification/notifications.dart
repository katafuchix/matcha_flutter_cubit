import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import '../IModel.dart';

part 'notifications.g.dart';

@JsonSerializable()
class Notifications extends IModel {
  @JsonKey(name: 'notification_id')
  int notificationId;
  @JsonKey(name: 'title')
  String title;
  @JsonKey(name: 'notice_type', unknownEnumValue: NoticeType.UNKNOWN)
  NoticeType noticeType;
  @JsonKey(name: 'created_at')
  String createdAt;
  @JsonKey(
      name: 'notification_type', unknownEnumValue: NotificationType.UNKNOWN)
  NotificationType notificationType;
  @JsonKey(name: 'read')
  bool read;

  Notifications(this.notificationId, this.title, this.noticeType,
      this.createdAt, this.notificationType, this.read);

  factory Notifications.fromJson(Map<String, dynamic> json) =>
      _$NotificationsFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationsToJson(this);

  @override
  String toString() => jsonEncode(this);
}

enum NoticeType {
  @JsonValue("emergency")
  EMERGENCY,
  @JsonValue("normal")
  NORMAL,
  UNKNOWN
}

enum NotificationType {
  @JsonValue("common")
  COMMON,
  @JsonValue("user")
  USER,
  UNKNOWN
}
