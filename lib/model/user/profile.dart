import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import '../IModel.dart';
import '../basic/sex.dart';
import 'profile_image.dart';

part 'profile.g.dart';

@JsonSerializable()
class Profile extends IModel {
  @JsonKey(name: 'user_id')
  int userId;
  @JsonKey(name: 'user_profile_id')
  int? userProfileId;
  @JsonKey(name: 'nickname')
  String nickname;
  @JsonKey(name: 'sex')
  SexAsResponse sex;
  @JsonKey(name: 'sex_enum')
  Sex sexEnum;
  @JsonKey(name: 'birthday')
  String birthday;
  @JsonKey(name: 'age')
  int age;
  @JsonKey(name: 'height')
  int? height;
  @JsonKey(name: 'prof_holiday')
  String? profHoliday;
  @JsonKey(name: 'blood')
  String? blood;
  @JsonKey(name: 'prof_animal')
  String? profAnimal;
  @JsonKey(name: 'prof_hobby')
  String? profHobby;
  @JsonKey(name: 'prof_job')
  String? profJob;
  @JsonKey(name: 'comment')
  String? comment;
  @JsonKey(name: 'point')
  int? point;
  @JsonKey(name: 'free_talk_user_ids')
  List<int>? freeTalkUserIds;
  @JsonKey(name: 'client_identifier_exist_exclude_me')
  bool? clientIdentifierExistExcludeMe;
  @JsonKey(name: 'android_purchase_count')
  int? androidPurchaseCount;

  Profile(
      this.userId,
      this.userProfileId,
      this.nickname,
      this.sex,
      this.sexEnum,
      this.birthday,
      this.age,
      this.height,
      this.profHoliday,
      this.blood,
      this.profAnimal,
      this.profHobby,
      this.profJob,
      this.comment,
      this.point,
      this.freeTalkUserIds,
      this.clientIdentifierExistExcludeMe,
      this.androidPurchaseCount);

  factory Profile.fromJson(Map<String, dynamic> json) {
    return _$ProfileFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ProfileToJson(this);

  @override
  String toString() => jsonEncode(this);
}
