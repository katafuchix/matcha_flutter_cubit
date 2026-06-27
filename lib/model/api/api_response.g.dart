// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiMeta _$ApiMetaFromJson(Map<String, dynamic> json) => ApiMeta(
      json['limit_value'] as int,
      json['current_page'] as int,
      json['total_pages'] as int,
      json['next_page'] as int,
      json['prev_page'] as int,
      json['badge_count'] as int,
    );

Map<String, dynamic> _$ApiMetaToJson(ApiMeta instance) => <String, dynamic>{
      'limit_value': instance.limitValue,
      'current_page': instance.currentPage,
      'total_pages': instance.totalPages,
      'next_page': instance.nextPage,
      'prev_page': instance.prevPage,
      'badge_count': instance.badgeCount,
    };

ApiResponseData _$ApiResponseDataFromJson(Map<String, dynamic> json) =>
    ApiResponseData(
      json['result'] as bool,
      json['data'],
      json['loaded_page_index'] as int?,
      json['total_count'] as int?,
      json['badge_count'] as int?,
    );

Map<String, dynamic> _$ApiResponseDataToJson(ApiResponseData instance) =>
    <String, dynamic>{
      'result': instance.result,
      'data': instance.data,
      'loaded_page_index': instance.loadedPageIndex,
      'total_count': instance.totalCount,
      'badge_count': instance.badgeCount,
    };
