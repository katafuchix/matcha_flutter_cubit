// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sign_up_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SignUpRequest _$SignUpRequestFromJson(Map<String, dynamic> json) =>
    SignUpRequest(
      json['nickname'] as String,
      json['prof_address_id'] as int,
      _$enumDecode(_$SexEnumMap, json['sex']),
      json['birthday'] as String,
      json['client_identifier'] as String?,
    );

Map<String, dynamic> _$SignUpRequestToJson(SignUpRequest instance) =>
    <String, dynamic>{
      'nickname': instance.nickname,
      'prof_address_id': instance.profAddressId,
      'sex': _$SexEnumMap[instance.sex],
      'birthday': instance.birthday,
      'client_identifier': instance.clientIdentifier,
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

const _$SexEnumMap = {
  Sex.Male: 'male',
  Sex.Female: 'female',
};
