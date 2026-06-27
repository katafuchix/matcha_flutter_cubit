import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'bbs.g.dart';

@JsonSerializable()
class BbsPost {
  static const defaultCategoryId = 265;

  @JsonKey(name: 'id')
  int? id;
  @JsonKey(name: 'post_category_id')
  int? postCategoryId;
  @JsonKey(name: 'text')
  String? text;
  @JsonKey(name: 'created_at')
  String? createdAt;

  BbsPost(
      {this.id,
      required this.postCategoryId,
      required this.text,
      this.createdAt});

  factory BbsPost.fromJson(Map<String, dynamic> json) =>
      _$BbsPostFromJson(json);

  factory BbsPost.forPosting(String text) => BbsPost(
      postCategoryId: defaultCategoryId /* カテゴリ前提の仕様の使い回しのため、カテゴリは固定で265を使う */,
      text: text);

  Map<String, dynamic> toJson() => _$BbsPostToJson(this);

  @override
  String toString() => toJson().toString();
}

@JsonSerializable()
class BbsPostResponse {
  @JsonKey(name: 'post')
  BbsPost bbsPost;

  BbsPostResponse(this.bbsPost);

  factory BbsPostResponse.fromJson(Map<String, dynamic> json) =>
      _$BbsPostResponseFromJson(json);

  Map<String, dynamic> toJson() => _$BbsPostResponseToJson(this);

  @override
  String toString() => toJson().toString();
}

@JsonSerializable()
class DeleteBbsPost {
  @JsonKey(name: 'id')
  int id;

  DeleteBbsPost(this.id);

  factory DeleteBbsPost.fromJson(Map<String, dynamic> json) =>
      _$DeleteBbsPostFromJson(json);

  Map<String, dynamic> toJson() => _$DeleteBbsPostToJson(this);

  @override
  String toString() => toJson().toString();
}
