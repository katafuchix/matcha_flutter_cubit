// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateProfile _$UpdateProfileFromJson(Map<String, dynamic> json) =>
    UpdateProfile(
      nickname: json['nickname'] as String?,
      profAddressId: json['prof_address_id'] as int?,
      birthday: json['birthday'] as String?,
      height: json['height'] as int?,
      bloodId: json['blood_id'] as int?,
      profHolidayId: json['prof_holiday_id'] as int?,
      profJobId: json['prof_job_id'] as int?,
      profAnimalId: json['prof_animal_id'] as int?,
      profHobbyId: json['prof_hobby_id'] as int?,
      comment: json['comment'] as String?,
      lat: (json['lat'] as num?)?.toDouble(),
      lon: (json['lon'] as num?)?.toDouble(),
      isLocationPublic: json['is_location_public'] as bool?,
      isLocationFixed: json['is_location_fixed'] as bool?,
    );

Map<String, dynamic> _$UpdateProfileToJson(UpdateProfile instance) =>
    <String, dynamic>{
      'nickname': instance.nickname,
      'prof_address_id': instance.profAddressId,
      'birthday': instance.birthday,
      'height': instance.height,
      'blood_id': instance.bloodId,
      'prof_holiday_id': instance.profHolidayId,
      'prof_job_id': instance.profJobId,
      'prof_animal_id': instance.profAnimalId,
      'prof_hobby_id': instance.profHobbyId,
      'comment': instance.comment,
      'lat': instance.lat,
      'lon': instance.lon,
      'is_location_public': instance.isLocationPublic,
      'is_location_fixed': instance.isLocationFixed,
    };
