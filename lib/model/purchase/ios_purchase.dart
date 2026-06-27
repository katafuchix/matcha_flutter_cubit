import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import '../IModel.dart';

part 'ios_purchase.g.dart';

@JsonSerializable()
class IosPurchaseRequest extends IModel {
  @JsonKey(name: 'product_id')
  String? productId;
  @JsonKey(name: 'base64_receipt_data')
  String base64ReceiptData;

  IosPurchaseRequest({this.productId, required this.base64ReceiptData});

  factory IosPurchaseRequest.fromJson(Map<String, dynamic> json) =>
      _$IosPurchaseRequestFromJson(json);

  factory IosPurchaseRequest.forPurchase(
          {required String productId, required String base64ReceiptData}) =>
      IosPurchaseRequest(
          productId: productId, base64ReceiptData: base64ReceiptData);

  factory IosPurchaseRequest.forRestore({required String base64ReceiptData}) =>
      IosPurchaseRequest(base64ReceiptData: base64ReceiptData);

  Map<String, dynamic> toJson() => _$IosPurchaseRequestToJson(this);

  @override
  String toString() => jsonEncode(this);
}

@JsonSerializable()
class IosResponse extends IModel {
  IosResponse();

  factory IosResponse.fromJson(Map<String, dynamic> json) =>
      _$IosResponseFromJson(json);

  Map<String, dynamic> toJson() => _$IosResponseToJson(this);

  @override
  String toString() => jsonEncode(this);
}
