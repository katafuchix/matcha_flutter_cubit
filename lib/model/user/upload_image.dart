import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import '../IModel.dart';

part 'upload_image.g.dart';

@JsonSerializable()
class UploadImage extends IModel {
  @JsonKey(name: 'image')
  String image;

  UploadImage(this.image);

  factory UploadImage.fromJson(Map<String, dynamic> json) {
    return _$UploadImageFromJson(json);
  }

  factory UploadImage.forApi(String base64Image) =>
      UploadImage('data:image/jpeg;base64,$base64Image');

  Map<String, dynamic> toJson() => _$UploadImageToJson(this);

  @override
  String toString() => jsonEncode(this);
}
