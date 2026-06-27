import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'error_result.g.dart';

@JsonSerializable()
class ErrorResult {
  @JsonKey(name: 'error_code')
  int? errorCode;
  String message;

  ErrorResult(this.errorCode, this.message);

  factory ErrorResult.fromJson(Map<String, dynamic> json) =>
      _$ErrorResultFromJson(json);

  Map<String, dynamic> toJson() => _$ErrorResultToJson(this);

  @override
  String toString() => jsonEncode(this);
}
