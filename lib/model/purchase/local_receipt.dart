import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import '../IModel.dart';

part 'local_receipt.g.dart';

@JsonSerializable()
class LocalReceipt extends IModel {
  @JsonKey(name: 'product_id')
  String productId;
  @JsonKey(name: 'base64_receipt_data')
  String receiptData;

  LocalReceipt({required this.productId, required this.receiptData});

  factory LocalReceipt.fromJson(Map<String, dynamic> json) =>
      _$LocalReceiptFromJson(json);

  Map<String, dynamic> toJson() => _$LocalReceiptToJson(this);

  @override
  String toString() => jsonEncode(this);
}
