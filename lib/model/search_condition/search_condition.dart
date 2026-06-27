import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import '../basic/sex.dart';

part 'search_condition.g.dart';

@JsonSerializable()
class SearchCondition {
  static const int intRangeMin = 0;
  static const int intRangeMax = 200;

  @JsonKey(name: 'page')
  int? page;
  @JsonKey(name: 'sex')
  SexAsCondition? sex;
  @JsonKey(name: 'age_range')
  final String? ageRange;
  @JsonKey(name: 'user_profile_blood_in')
  final String? userProfileBloodIn;
  @JsonKey(name: 'user_profile_height_in')
  final String? userProfileHeightIn;
  @JsonKey(name: 'user_profile_prof_holiday_id_in')
  final String? userProfileProfHolidayIdIn;
  @JsonKey(name: 'user_profile_prof_job_id_in')
  final String? userProfileProfJobIdIn;
  @JsonKey(name: 'user_profile_prof_animal_id_in')
  final String? userProfileProfAnimalIdIn;
  @JsonKey(name: 'user_profile_prof_hobby_id_in')
  final String? userProfileProfHobbyIdIn;
  @JsonKey(name: 'sorts')
  final String? sorts;

  SearchCondition(
      {this.page,
      this.sex,
      this.ageRange,
      this.userProfileBloodIn,
      this.userProfileHeightIn,
      this.userProfileProfHolidayIdIn,
      this.userProfileProfJobIdIn,
      this.userProfileProfAnimalIdIn,
      this.userProfileProfHobbyIdIn,
      this.sorts});

  factory SearchCondition.fromJson(Map<String, dynamic> json) =>
      _$SearchConditionFromJson(json);

  factory SearchCondition.fromParam(
      {int? page,
      SexAsCondition? sex,
      int? ageMin,
      int? ageMax,
      int? heightMin,
      int? heightMax,
      List<int>? userProfileBloodIn,
      List<int>? userProfileProfHolidayIdIn,
      List<int>? userProfileProfJobIdIn,
      List<int>? userProfileProfAnimalIdIn,
      List<int>? userProfileProfHobbyIdIn}) {
    String? ageRange;
    if (ageMin != null || ageMax != null) {
      int adjustMinAge = ageMin == null ? intRangeMin : ageMin;
      int adjustMaxAge = ageMax == null ? intRangeMax : ageMax;
      ageRange = '$adjustMinAge..$adjustMaxAge';
    }

    String? heightRange;
    if (heightMin != null || heightMax != null) {
      int adjustMinHeight = heightMin == null ? intRangeMin : heightMin;
      int adjustMaxHeight = heightMax == null ? intRangeMax : heightMax;
      heightRange = '$adjustMinHeight..$adjustMaxHeight';
    }

    return SearchCondition(
        page: page,
        sex: sex,
        ageRange: ageRange,
        userProfileHeightIn: heightRange,
        userProfileBloodIn:
            userProfileBloodIn == null || userProfileBloodIn.isEmpty
                ? null
                : userProfileBloodIn.join(','),
        userProfileProfHolidayIdIn: userProfileProfHolidayIdIn == null ||
                userProfileProfHolidayIdIn.isEmpty
            ? null
            : userProfileProfHolidayIdIn.join(','),
        userProfileProfJobIdIn:
            userProfileProfJobIdIn == null || userProfileProfJobIdIn.isEmpty
                ? null
                : userProfileProfJobIdIn.join(','),
        userProfileProfAnimalIdIn: userProfileProfAnimalIdIn == null ||
                userProfileProfAnimalIdIn.isEmpty
            ? null
            : userProfileProfAnimalIdIn.join(','),
        userProfileProfHobbyIdIn:
            userProfileProfHobbyIdIn == null || userProfileProfHobbyIdIn.isEmpty
                ? null
                : userProfileProfHobbyIdIn.join(','));
  }

  Map<String, dynamic> toJson() => _$SearchConditionToJson(this);

  @override
  String toString() => jsonEncode(this);
}
