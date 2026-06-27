import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import '../IModel.dart';

part 'point_model.g.dart';

@JsonSerializable()
class PointModel extends IModel {
  @JsonKey(name: 'process_date')
  String processDate;
  @JsonKey(name: 'process_type')
  String processType;
  @JsonKey(name: 'point')
  int point;

  PointModel(this.processDate, this.processType, this.point);

  factory PointModel.fromJson(Map<String, dynamic> json) =>
      _$PointModelFromJson(json);

  Map<String, dynamic> toJson() => _$PointModelToJson(this);

  @override
  String toString() => jsonEncode(this);
}
