import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import '../IModel.dart';

part 'inquiry.g.dart';

@JsonSerializable()
class Inquiry extends IModel {
  @JsonKey(name: 'inquiry_category_id')
  int inquiryCategoryId;
  @JsonKey(name: 'detail')
  String detail;
  @JsonKey(name: 'image')
  String? base64Image;

  Inquiry(this.inquiryCategoryId, this.detail, {this.base64Image});

  factory Inquiry.fromJson(Map<String, dynamic> json) =>
      _$InquiryFromJson(json);

  Map<String, dynamic> toJson() => _$InquiryToJson(this);

  @override
  String toString() => jsonEncode(this);
}
