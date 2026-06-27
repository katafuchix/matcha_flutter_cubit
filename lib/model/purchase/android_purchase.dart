import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import '../IModel.dart';

part 'android_purchase.g.dart';

@JsonSerializable()
class AndroidPurchaseRequest extends IModel {
  @JsonKey(name: 'product_id')
  String? productId;
  @JsonKey(name: 'purchase_data')
  String purchaseData;
  @JsonKey(name: 'signature')
  String signature;

  AndroidPurchaseRequest(
      {this.productId, required this.purchaseData, required this.signature});

  factory AndroidPurchaseRequest.fromJson(Map<String, dynamic> json) =>
      _$AndroidPurchaseRequestFromJson(json);

  factory AndroidPurchaseRequest.forPurchase(
          {required String productId,
          required String purchaseData,
          required String signature}) =>
      AndroidPurchaseRequest(
          productId: productId,
          purchaseData: purchaseData,
          signature: signature);

  factory AndroidPurchaseRequest.forRestore(
          {required String purchaseData, required String signature}) =>
      AndroidPurchaseRequest(purchaseData: purchaseData, signature: signature);

  Map<String, dynamic> toJson() => _$AndroidPurchaseRequestToJson(this);

  @override
  String toString() => jsonEncode(this);
}

@JsonSerializable()
class AndroidPurchaseResponse extends IModel {
  AndroidPurchaseResponse();

  factory AndroidPurchaseResponse.fromJson(Map<String, dynamic> json) =>
      _$AndroidPurchaseResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AndroidPurchaseResponseToJson(this);

  @override
  String toString() => jsonEncode(this);
}
