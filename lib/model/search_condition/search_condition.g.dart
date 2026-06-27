// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_condition.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchCondition _$SearchConditionFromJson(Map<String, dynamic> json) =>
    SearchCondition(
      page: json['page'] as int?,
      sex: _$enumDecodeNullable(_$SexAsConditionEnumMap, json['sex']),
      ageRange: json['age_range'] as String?,
      userProfileBloodIn: json['user_profile_blood_in'] as String?,
      userProfileHeightIn: json['user_profile_height_in'] as String?,
      userProfileProfHolidayIdIn:
          json['user_profile_prof_holiday_id_in'] as String?,
      userProfileProfJobIdIn: json['user_profile_prof_job_id_in'] as String?,
      userProfileProfAnimalIdIn:
          json['user_profile_prof_animal_id_in'] as String?,
      userProfileProfHobbyIdIn:
          json['user_profile_prof_hobby_id_in'] as String?,
      sorts: json['sorts'] as String?,
    );

Map<String, dynamic> _$SearchConditionToJson(SearchCondition instance) =>
    <String, dynamic>{
      'page': instance.page,
      'sex': _$SexAsConditionEnumMap[instance.sex],
      'age_range': instance.ageRange,
      'user_profile_blood_in': instance.userProfileBloodIn,
      'user_profile_height_in': instance.userProfileHeightIn,
      'user_profile_prof_holiday_id_in': instance.userProfileProfHolidayIdIn,
      'user_profile_prof_job_id_in': instance.userProfileProfJobIdIn,
      'user_profile_prof_animal_id_in': instance.userProfileProfAnimalIdIn,
      'user_profile_prof_hobby_id_in': instance.userProfileProfHobbyIdIn,
      'sorts': instance.sorts,
    };

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}

K? _$enumDecodeNullable<K, V>(
  Map<K, V> enumValues,
  dynamic source, {
  K? unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<K, V>(enumValues, source, unknownValue: unknownValue);
}

const _$SexAsConditionEnumMap = {
  SexAsCondition.Male: 0,
  SexAsCondition.Female: 1,
};
