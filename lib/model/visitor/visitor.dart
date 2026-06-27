import 'dart:convert';

import '../user/profile_response.dart';
import 'package:json_annotation/json_annotation.dart';

import '../IModel.dart';

part 'visitor.g.dart';

@JsonSerializable()
class Visitor extends IModel {
  @JsonKey(name: 'visit_date')
  String visitDate;
  @JsonKey(name: 'profiles')
  List<ProfileResponse> profiles;

  Visitor(
    this.visitDate,
    this.profiles,
  );

  factory Visitor.fromJson(Map<String, dynamic> json) =>
      _$VisitorFromJson(json);

  Map<String, dynamic> toJson() => _$VisitorToJson(this);

  @override
  String toString() => jsonEncode(this);
}
