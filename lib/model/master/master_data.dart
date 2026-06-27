import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import '../IModel.dart';

part 'master_data.g.dart';

@JsonSerializable()
class MasterData extends IModel {
  @JsonKey(name: 'id')
  int id;
  @JsonKey(name: 'name')
  String name;
  @JsonKey(name: 'enabled')
  bool? enabled;
  @JsonKey(name: 'sort_order')
  int? sortOrder;

  MasterData(this.id, this.name, this.enabled, this.sortOrder);

  factory MasterData.fromJson(Map<String, dynamic> json) =>
      _$MasterDataFromJson(json);

  Map<String, dynamic> toJson() => _$MasterDataToJson(this);

  @override
  String toString() => jsonEncode(this);
}
