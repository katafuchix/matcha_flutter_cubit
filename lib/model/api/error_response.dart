import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'error_response.g.dart';

@JsonSerializable()
class ErrorResponse {
  bool result;
  String message;
  @JsonKey(name: 'error_code')
  int errorCode;

  ErrorResponse(this.result, this.message, this.errorCode);

  factory ErrorResponse.fromJson(Map<String, dynamic> json) =>
      _$ErrorResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ErrorResponseToJson(this);

  @override
  String toString() => jsonEncode(this);
}
