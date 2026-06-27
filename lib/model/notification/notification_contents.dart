import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import '../IModel.dart';
import 'notifications.dart';

part 'notification_contents.g.dart';

@JsonSerializable()
class NotificationContents extends IModel {
  @JsonKey(name: 'body')
  String body;

  NotificationContents(this.body);

  factory NotificationContents.fromJson(Map<String, dynamic> json) =>
      _$NotificationContentsFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationContentsToJson(this);

  @override
  String toString() => jsonEncode(this);
}

@JsonSerializable()
class NotificationContentsRequest extends IModel {
  @JsonKey(name: 'notification_id')
  int notificationId;
  @JsonKey(name: 'notification_type')
  NotificationType notificationType;

  NotificationContentsRequest(this.notificationId, this.notificationType);

  factory NotificationContentsRequest.fromJson(Map<String, dynamic> json) =>
      _$NotificationContentsRequestFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationContentsRequestToJson(this);
}
