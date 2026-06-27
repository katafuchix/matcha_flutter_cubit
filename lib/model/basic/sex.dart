import 'package:json_annotation/json_annotation.dart';

enum Sex {
  @JsonValue("male")
  Male,
  @JsonValue("female")
  Female
}

enum SexAsResponse {
  @JsonValue("男性")
  Male,
  @JsonValue("女性")
  Female
}

enum SexAsCondition {
  @JsonValue(0)
  Male,
  @JsonValue(1)
  Female
}

extension SexAsResponseExt on SexAsResponse {
  String get displayText {
    switch (this) {
      case SexAsResponse.Male:
        {
          return '男性';
        }
      case SexAsResponse.Female:
        {
          return '女性';
        }
      default:
        throw StateError('unexpected');
    }
  }
}
