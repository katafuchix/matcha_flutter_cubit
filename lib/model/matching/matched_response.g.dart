// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'matched_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MatchedResponse _$MatchedResponseFromJson(Map<String, dynamic> json) =>
    MatchedResponse(
      MatchInfo.fromJson(json['match'] as Map<String, dynamic>),
      Profile.fromJson(json['profile'] as Map<String, dynamic>),
      (json['profile_images'] as List<dynamic>)
          .map((e) => ProfileImage.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MatchedResponseToJson(MatchedResponse instance) =>
    <String, dynamic>{
      'match': instance.match,
      'profile': instance.profile,
      'profile_images': instance.profileImages,
    };
