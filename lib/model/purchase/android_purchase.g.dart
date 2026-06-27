// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'android_purchase.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AndroidPurchaseRequest _$AndroidPurchaseRequestFromJson(
        Map<String, dynamic> json) =>
    AndroidPurchaseRequest(
      productId: json['product_id'] as String?,
      purchaseData: json['purchase_data'] as String,
      signature: json['signature'] as String,
    );

Map<String, dynamic> _$AndroidPurchaseRequestToJson(
        AndroidPurchaseRequest instance) =>
    <String, dynamic>{
      'product_id': instance.productId,
      'purchase_data': instance.purchaseData,
      'signature': instance.signature,
    };

AndroidPurchaseResponse _$AndroidPurchaseResponseFromJson(
        Map<String, dynamic> json) =>
    AndroidPurchaseResponse();

Map<String, dynamic> _$AndroidPurchaseResponseToJson(
        AndroidPurchaseResponse instance) =>
    <String, dynamic>{};
