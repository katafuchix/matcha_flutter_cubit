// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bbs.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BbsPost _$BbsPostFromJson(Map<String, dynamic> json) => BbsPost(
      id: json['id'] as int?,
      postCategoryId: json['post_category_id'] as int?,
      text: json['text'] as String?,
      createdAt: json['created_at'] as String?,
    );

Map<String, dynamic> _$BbsPostToJson(BbsPost instance) => <String, dynamic>{
      'id': instance.id,
      'post_category_id': instance.postCategoryId,
      'text': instance.text,
      'created_at': instance.createdAt,
    };

BbsPostResponse _$BbsPostResponseFromJson(Map<String, dynamic> json) =>
    BbsPostResponse(
      BbsPost.fromJson(json['post'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BbsPostResponseToJson(BbsPostResponse instance) =>
    <String, dynamic>{
      'post': instance.bbsPost,
    };

DeleteBbsPost _$DeleteBbsPostFromJson(Map<String, dynamic> json) =>
    DeleteBbsPost(
      json['id'] as int,
    );

Map<String, dynamic> _$DeleteBbsPostToJson(DeleteBbsPost instance) =>
    <String, dynamic>{
      'id': instance.id,
    };
