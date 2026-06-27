// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ios_purchase.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IosPurchaseRequest _$IosPurchaseRequestFromJson(Map<String, dynamic> json) =>
    IosPurchaseRequest(
      productId: json['product_id'] as String?,
      base64ReceiptData: json['base64_receipt_data'] as String,
    );

Map<String, dynamic> _$IosPurchaseRequestToJson(IosPurchaseRequest instance) =>
    <String, dynamic>{
      'product_id': instance.productId,
      'base64_receipt_data': instance.base64ReceiptData,
    };

IosResponse _$IosResponseFromJson(Map<String, dynamic> json) => IosResponse();

Map<String, dynamic> _$IosResponseToJson(IosResponse instance) =>
    <String, dynamic>{};
