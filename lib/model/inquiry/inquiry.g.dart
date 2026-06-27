// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inquiry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Inquiry _$InquiryFromJson(Map<String, dynamic> json) => Inquiry(
      json['inquiry_category_id'] as int,
      json['detail'] as String,
      base64Image: json['image'] as String?,
    );

Map<String, dynamic> _$InquiryToJson(Inquiry instance) => <String, dynamic>{
      'inquiry_category_id': instance.inquiryCategoryId,
      'detail': instance.detail,
      'image': instance.base64Image,
    };
