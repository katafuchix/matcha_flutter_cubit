import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import '../IModel.dart';

part 'profile_image.g.dart';

@JsonSerializable()
class ProfileImage extends IModel {
  @JsonKey(name: 'image')
  String image;

  ProfileImage(this.image);

  factory ProfileImage.fromJson(Map<String, dynamic> json) {
    return _$ProfileImageFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ProfileImageToJson(this);

  @override
  String toString() => jsonEncode(this);
}
