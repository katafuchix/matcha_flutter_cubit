// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_receipt.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocalReceipt _$LocalReceiptFromJson(Map<String, dynamic> json) => LocalReceipt(
      productId: json['product_id'] as String,
      receiptData: json['base64_receipt_data'] as String,
    );

Map<String, dynamic> _$LocalReceiptToJson(LocalReceipt instance) =>
    <String, dynamic>{
      'product_id': instance.productId,
      'base64_receipt_data': instance.receiptData,
    };
