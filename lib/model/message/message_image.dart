import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import '../IModel.dart';
import 'message_type.dart';

part 'message_image.g.dart';

@JsonSerializable()
class MessageImage extends IModel {
  @JsonKey(name: 'image')
  String image;

  MessageImage(this.image);

  factory MessageImage.fromJson(Map<String, dynamic> json) =>
      _$MessageImageFromJson(json);

  Map<String, dynamic> toJson() => _$MessageImageToJson(this);

  @override
  String toString() => jsonEncode(this);
}
