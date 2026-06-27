// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileResponse _$ProfileResponseFromJson(Map<String, dynamic> json) =>
    ProfileResponse(
      (json['recent_post'] as List<dynamic>?)
          ?.map((e) => BbsPost.fromJson(e as Map<String, dynamic>))
          .toList(),
      Profile.fromJson(json['profile'] as Map<String, dynamic>),
      json['relation'] == null
          ? null
          : Relation.fromJson(json['relation'] as Map<String, dynamic>),
      (json['profile_images'] as List<dynamic>)
          .map((e) => ProfileImage.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['visited_at'] as String?,
    );

Map<String, dynamic> _$ProfileResponseToJson(ProfileResponse instance) =>
    <String, dynamic>{
      'recent_post': instance.recentPost,
      'profile': instance.profile,
      'relation': instance.relation,
      'profile_images': instance.profileImages,
      'visited_at': instance.visitedAt,
    };
