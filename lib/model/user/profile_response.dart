import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import '../../model/bbs/bbs.dart';
import '../IModel.dart';
import 'profile.dart';
import 'profile_image.dart';
import 'relation.dart';

part 'profile_response.g.dart';

@JsonSerializable()
class ProfileResponse extends IModel {
  @JsonKey(name: 'recent_post')
  List<BbsPost>? recentPost;
  @JsonKey(name: 'profile')
  Profile profile;
  @JsonKey(name: 'relation')
  Relation? relation;
  @JsonKey(name: 'profile_images')
  List<ProfileImage> profileImages;
  @JsonKey(name: 'visited_at')
  String? visitedAt;

  ProfileResponse(this.recentPost, this.profile, this.relation,
      this.profileImages, this.visitedAt);

  factory ProfileResponse.fromJson(Map<String, dynamic> json) =>
      _$ProfileResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ProfileResponseToJson(this);

  @override
  String toString() => jsonEncode(this);
}
