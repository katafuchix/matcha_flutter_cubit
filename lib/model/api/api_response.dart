import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import 'error_response.dart';

part 'api_response.g.dart';

class ApiResponseMisc {
  String? requiredAppVersion;
  // ApiMeta apiMeta;
  int? loadedPageIndex;
  int? totalCount;
  int? badgeCount;

  ApiResponseMisc(this.requiredAppVersion, this.loadedPageIndex,
      this.totalCount, this.badgeCount);

  factory ApiResponseMisc.from(Map<String, dynamic>? headers,
      int? loadedPageIndex, int? totalCount, int? badgeCount) {
    String? requiredAppVersion = _getRequiredAppVersion(headers);
    return ApiResponseMisc(
        requiredAppVersion, loadedPageIndex, totalCount, badgeCount);
  }

  // アプリ要求バージョンをパース
  static String? _getRequiredAppVersion(Map<String, dynamic>? headers) {
    if (headers == null) return null;

    String? requiredVersion =
        headers['x-app-client-required-version']?.first?.toUpperCase();
    if (requiredVersion == null) {
      requiredVersion =
          headers['X-APP-CLIENT-REQUIRED-VERSION']?.first?.toUpperCase();
    }
    // MyLogger.i('requiredVersion = $requiredVersion');
    return requiredVersion;
  }

  @override
  String toString() => jsonEncode(this);
}

@JsonSerializable()
class ApiMeta {
  @JsonKey(name: 'limit_value')
  int limitValue;
  @JsonKey(name: 'current_page')
  int currentPage;
  @JsonKey(name: 'total_pages')
  int totalPages;
  @JsonKey(name: 'next_page')
  int nextPage;
  @JsonKey(name: 'prev_page')
  int prevPage;
  @JsonKey(name: 'badge_count')
  int badgeCount;

  ApiMeta(this.limitValue, this.currentPage, this.totalPages, this.nextPage,
      this.prevPage, this.badgeCount);

  factory ApiMeta.fromJson(Map<String, dynamic> json) =>
      _$ApiMetaFromJson(json);

  Map<String, dynamic> toJson() => _$ApiMetaToJson(this);

  @override
  String toString() => jsonEncode(this);
}

@JsonSerializable()
class ApiResponseData {
  bool result;
  // ApiMeta meta;
  dynamic data;
  @JsonKey(name: 'loaded_page_index')
  int? loadedPageIndex;
  @JsonKey(name: 'total_count')
  int? totalCount;
  @JsonKey(name: 'badge_count')
  int? badgeCount;

  ApiResponseData(this.result, this.data, this.loadedPageIndex, this.totalCount,
      this.badgeCount);

  factory ApiResponseData.fromJson(Map<String, dynamic> json) =>
      _$ApiResponseDataFromJson(json);

  Map<String, dynamic> toJson() => _$ApiResponseDataToJson(this);

  @override
  String toString() => jsonEncode(this);
}

class ApiResponse<T> {
  ApiResponse._();

  factory ApiResponse.success(ApiResponseMisc misc, T t) {
    return ApiSuccessResponse(misc, data: t);
  }
  factory ApiResponse.successWithoutData(ApiResponseMisc misc) {
    return ApiSuccessResponse(misc);
  }
  factory ApiResponse.error(ErrorResponse? error, ApiResponseMisc misc) =
      ApiErrorResponse;
}

class ApiSuccessResponse<T> extends ApiResponse<T> {
  final T? data;
  ApiResponseMisc misc;
  ApiSuccessResponse(this.misc, {this.data}) : super._();
}

class ApiErrorResponse<DUMMY> extends ApiResponse<DUMMY> {
  final ErrorResponse? error;
  ApiResponseMisc misc;
  ApiErrorResponse(this.error, this.misc) : super._();
}
