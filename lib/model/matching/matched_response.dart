import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import '../IModel.dart';
import '../user/profile.dart';
import '../user/profile_image.dart';
import 'match_info.dart';

part 'matched_response.g.dart';

@JsonSerializable()
class MatchedResponse extends IModel {
  // user id
  @JsonKey(name: 'match')
  MatchInfo match;
  @JsonKey(name: 'profile')
  Profile profile;
  @JsonKey(name: 'profile_images')
  List<ProfileImage> profileImages;

  MatchedResponse(this.match, this.profile, this.profileImages);

  factory MatchedResponse.fromJson(Map<String, dynamic> json) =>
      _$MatchedResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MatchedResponseToJson(this);

  @override
  String toString() => jsonEncode(this);
}
