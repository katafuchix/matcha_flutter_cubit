import 'package:json_annotation/json_annotation.dart';

enum MessageType {
  @JsonValue('text')
  TEXT,
  @JsonValue('photo')
  PHOTO
}
