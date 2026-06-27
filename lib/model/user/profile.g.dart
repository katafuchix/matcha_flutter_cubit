// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Profile _$ProfileFromJson(Map<String, dynamic> json) => Profile(
      json['user_id'] as int,
      json['user_profile_id'] as int?,
      json['nickname'] as String,
      _$enumDecode(_$SexAsResponseEnumMap, json['sex']),
      _$enumDecode(_$SexEnumMap, json['sex_enum']),
      json['birthday'] as String,
      json['age'] as int,
      json['height'] as int?,
      json['prof_holiday'] as String?,
      json['blood'] as String?,
      json['prof_animal'] as String?,
      json['prof_hobby'] as String?,
      json['prof_job'] as String?,
      json['comment'] as String?,
      json['point'] as int?,
      (json['free_talk_user_ids'] as List<dynamic>?)
          ?.map((e) => e as int)
          .toList(),
      json['client_identifier_exist_exclude_me'] as bool?,
      json['android_purchase_count'] as int?,
    );

Map<String, dynamic> _$ProfileToJson(Profile instance) => <String, dynamic>{
      'user_id': instance.userId,
      'user_profile_id': instance.userProfileId,
      'nickname': instance.nickname,
      'sex': _$SexAsResponseEnumMap[instance.sex],
      'sex_enum': _$SexEnumMap[instance.sexEnum],
      'birthday': instance.birthday,
      'age': instance.age,
      'height': instance.height,
      'prof_holiday': instance.profHoliday,
      'blood': instance.blood,
      'prof_animal': instance.profAnimal,
      'prof_hobby': instance.profHobby,
      'prof_job': instance.profJob,
      'comment': instance.comment,
      'point': instance.point,
      'free_talk_user_ids': instance.freeTalkUserIds,
      'client_identifier_exist_exclude_me':
          instance.clientIdentifierExistExcludeMe,
      'android_purchase_count': instance.androidPurchaseCount,
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

const _$SexAsResponseEnumMap = {
  SexAsResponse.Male: '男性',
  SexAsResponse.Female: '女性',
};

const _$SexEnumMap = {
  Sex.Male: 'male',
  Sex.Female: 'female',
};
