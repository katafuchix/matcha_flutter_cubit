import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import '../IModel.dart';

part 'update_profile.g.dart';

@JsonSerializable()
class UpdateProfile extends IModel {
  @JsonKey(name: 'nickname')
  String? nickname;
  @JsonKey(name: 'prof_address_id')
  int? profAddressId;
  @JsonKey(name: 'birthday')
  String? birthday;
  @JsonKey(name: 'height')
  int? height;
  @JsonKey(name: 'blood_id')
  int? bloodId;
  @JsonKey(name: 'prof_holiday_id')
  int? profHolidayId;
  @JsonKey(name: 'prof_job_id')
  int? profJobId;
  @JsonKey(name: 'prof_animal_id')
  int? profAnimalId;
  @JsonKey(name: 'prof_hobby_id')
  int? profHobbyId;
  @JsonKey(name: 'comment')
  String? comment;
  @JsonKey(name: 'lat')
  double? lat;
  @JsonKey(name: 'lon')
  double? lon;
  @JsonKey(name: 'is_location_public')
  bool? isLocationPublic;
  @JsonKey(name: 'is_location_fixed')
  bool? isLocationFixed;

  UpdateProfile(
      {this.nickname,
      this.profAddressId,
      this.birthday,
      this.height,
      this.bloodId,
      this.profHolidayId,
      this.profJobId,
      this.profAnimalId,
      this.profHobbyId,
      this.comment,
      this.lat,
      this.lon,
      this.isLocationPublic,
      this.isLocationFixed});

  factory UpdateProfile.fromJson(Map<String, dynamic> json) =>
      _$UpdateProfileFromJson(json);

  factory UpdateProfile.fromDateTimeBirthday(DateTime birthday) {
    initializeDateFormatting("ja_JP");
    var formatter = new DateFormat('yyyy-MM-dd', "ja_JP");
    var formatted = formatter.format(birthday);
    return UpdateProfile(birthday: formatted);
  }

  @override
  Map<String, dynamic> toJson() => _$UpdateProfileToJson(this);

  @override
  String toString() => jsonEncode(this);
}
