import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:matcha_flutter_cubit/core/my_platform.dart';

import '../IModel.dart';

part 'point_master.g.dart';

@JsonSerializable()
class PointMaster extends IModel {
  @JsonKey(name: 'id')
  int id;
  @JsonKey(name: 'os')
  PointOs os;
  @JsonKey(name: 'product_id_str')
  String productIdStr;
  @JsonKey(name: 'name')
  String name;
  @JsonKey(name: 'price')
  int price;
  @JsonKey(name: 'price_before_discount')
  int? priceBeforeDiscount;
  @JsonKey(name: 'discount_percent')
  int? discountPercent;
  @JsonKey(name: 'point')
  int point;
  @JsonKey(name: 'sort_order')
  int sortOrder;
  @JsonKey(name: 'enabled')
  bool enabled;
  @JsonKey(name: 'created_at')
  String createdAt;
  @JsonKey(name: 'updated_at')
  String updatedAt;

  PointMaster(
      this.id,
      this.os,
      this.productIdStr,
      this.name,
      this.price,
      this.priceBeforeDiscount,
      this.discountPercent,
      this.point,
      this.sortOrder,
      this.enabled,
      this.createdAt,
      this.updatedAt);

  factory PointMaster.fromJson(Map<String, dynamic> json) =>
      _$PointMasterFromJson(json);

  Map<String, dynamic> toJson() => _$PointMasterToJson(this);

  @override
  String toString() => jsonEncode(this);
}

enum PointOs {
  @JsonValue('android')
  Android,
  @JsonValue('iOS')
  Ios
}

PointOs? getPointOsAsCurrentOs() {
  if (MyPlatform.isIOS) {
    return PointOs.Ios;
  }

  if (MyPlatform.isAndroid) {
    return PointOs.Android;
  }

  return null;
}
