import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import '../../core/app_info.dart';
import '../../core/my_logger.dart';
import '../../model/IModel.dart';
import '../../model/api/api_response.dart';
import '../../model/api/error_response.dart';
import '../storage/shared_preferences/shared_preferences_keys.dart';
import '../storage/shared_preferences/shared_preferences_manager.dart';
import 'dio_auth_interceptors.dart';
import 'dio_log_interceptors.dart';

typedef FromJson<T> = T Function(dynamic);

class DioWrapper {
  final Dio _dio;
  final bool _needAuth;
  Future<SharedPreferencesManager> get _sharedPreferencesManager =>
      SharedPreferencesManager.getInstance();
  DioWrapper(this._dio, this._needAuth, String baseUrl) {
    _dio.options.baseUrl = baseUrl;

    if (_needAuth) {
      _dio.interceptors.add(DioAuthInterceptors(_dio));
    } else {
      _dio.interceptors.add(DioLogInterceptors());
    }
  }

  Future<ApiResponse<RES_TYPE>> getRequest<RES_TYPE>(
      String path,
      Map<String, dynamic>? queryParameters,
      FromJson<RES_TYPE> fromJson) async {
    try {
      if (_needAuth) {
        String? accessToken = (await _sharedPreferencesManager)
            .getString(SharedPreferencesKeys.ACCESS_TOKEN);
        if (queryParameters == null) queryParameters = {};
        queryParameters['auth_token'] = accessToken;
      }
      final q = filterNonNullRecursively(queryParameters);
      MyLogger.d(
          'GET REQUEST path = $path , queryParameters = ${jsonEncode(q)}');
      final response = await _dio.get(
        path,
        queryParameters: q,
        options: Options(
          headers: await _createHeader(),
        ),
      );
      return _onSuccess(path, response, fromJson);
    } on DioException catch (e) {
      return _onError(path, e);
    }
  }

  // TODO body -> IModel型へ変更する
  Future<ApiResponse<RES_TYPE>> postRequest<RES_TYPE>(String path,
      Map<String, dynamic>? body, FromJson<RES_TYPE>? fromJson) async {
    try {
      Map<String, String> queryParameters = {};
      if (_needAuth) {
        String? accessToken = (await _sharedPreferencesManager)
            .getString(SharedPreferencesKeys.ACCESS_TOKEN);
        if (accessToken != null) {
          queryParameters['auth_token'] = accessToken;
        }
      }

      final q = filterNonNullRecursively(queryParameters);
      final b = filterNonNullRecursively(body);
      final h = await _createHeader();
      MyLogger.d(
          'POST REQUEST path = $path , header = ${jsonEncode(h)} , queryParameters = ${jsonEncode(q)} , body = ${jsonEncode(b)}');

      final response = await _dio.post(
        path,
        queryParameters: q,
        data: b,
        options: Options(headers: h),
      );
      return _onSuccess(path, response, fromJson);
    } on DioException catch (e) {
      return _onError(path, e);
    }
  }

  // TODO body -> IModel型へ変更する
  Future<ApiResponse<RES_TYPE>> patchRequest<RES_TYPE>(String path,
      Map<String, dynamic> body, FromJson<RES_TYPE> fromJson) async {
    try {
      Map<String, String> queryParameters = {};
      if (_needAuth) {
        String? accessToken = (await _sharedPreferencesManager)
            .getString(SharedPreferencesKeys.ACCESS_TOKEN);
        if (accessToken != null) {
          queryParameters['auth_token'] = accessToken;
        }
      }

      final q = filterNonNullRecursively(queryParameters);
      final b = filterNonNullRecursively(body);
      final h = await _createHeader();
      MyLogger.d(
          'PATCH REQUEST path = $path , header = ${jsonEncode(h)} , queryParameters = ${jsonEncode(q)} , body = ${jsonEncode(b)}');

      final response = await _dio.patch(
        path,
        queryParameters: q,
        data: b,
        options: Options(headers: h),
      );
      return _onSuccess(path, response, fromJson);
    } on DioException catch (e) {
      return _onError(path, e);
    }
  }

  // TODO body -> IModel型へ変更する
  Future<ApiResponse<RES_TYPE>> deleteRequest<RES_TYPE>(String path,
      Map<String, dynamic> body, FromJson<RES_TYPE> fromJson) async {
    try {
      Map<String, String> queryParameters = {};
      if (_needAuth) {
        String? accessToken = (await _sharedPreferencesManager)
            .getString(SharedPreferencesKeys.ACCESS_TOKEN);
        if (accessToken != null) {
          queryParameters['auth_token'] = accessToken;
        }
      }

      final q = filterNonNullRecursively(queryParameters);
      final b = filterNonNullRecursively(body);
      final h = await _createHeader();
      MyLogger.d(
          'DELETE REQUEST path = $path , header = ${jsonEncode(h)} , queryParameters = ${jsonEncode(q)} , body = ${jsonEncode(b)}');

      final response = await _dio.delete(
        path,
        queryParameters: q,
        data: b,
        options: Options(headers: h),
      );
      return _onSuccess(path, response, fromJson);
    } on DioException catch (e) {
      return _onError(path, e);
    }
  }

  Future<ApiResponse<T>> _onSuccess<T>(
      String path, Response response, FromJson<T>? fromJson) async {
    if (response.data == null) {
      return ApiResponse<T>.successWithoutData(
          ApiResponseMisc.from(response.headers.map, null, null, null));
    } else {
      ApiResponseData res = ApiResponseData.fromJson(response.data);
      // TODO metaをmiscに入れる

      T? data = fromJson?.call(res.data);
      MyLogger.d('path = $path RESPONSE = $data');

      if (data == null) {
        return ApiResponse<T>.successWithoutData(
            ApiResponseMisc.from(response.headers.map, null, null, null));
      }

      return ApiResponse<T>.success(
          ApiResponseMisc.from(response.headers.map, res.loadedPageIndex,
              res.totalCount, res.badgeCount),
          data);
    }
  }

  Future<ApiResponse<DUMMY>> _onError<DUMMY>(
      String path, DioException? error) async {
    ErrorResponse? errorResponse;
    try {
      errorResponse = ErrorResponse.fromJson(error?.response?.data);
      MyLogger.w(errorResponse);
    } catch (e) {
      // TODO 想定外のサーバーエラーでここにくるので、適切にハンドリングする
      MyLogger.e('path : { $path } , exception : { $e }  error : { $error }');
    }
    return ApiResponse<DUMMY>.error(errorResponse,
        ApiResponseMisc.from(error?.response?.headers?.map, null, null, null));
  }

  Future<Map<String, dynamic>> _createHeader() async {
    if (_needAuth) {
      return _createHeaderFroAuthApi();
    } else {
      return _createHeaderFroOpenApi();
    }
  }

  Map<String, dynamic> _createHeaderFroOpenApi() {
    String platform = AppInfo.platformString;
    String osVersion = AppInfo.osVersion;
    String deviceName = AppInfo.deviceName;
    String appVersion = AppInfo.appVersion;
    String packageName = AppInfo.packageName;
    return {
      'Accept-Language': 'ja', // TODO
      'User-Agent': '$packageName/$appVersion/$platform/$osVersion/$deviceName'
    };
  }

  Future<Map<String, dynamic>> _createHeaderFroAuthApi() async {
    String? accessToken = (await _sharedPreferencesManager)
        .getString(SharedPreferencesKeys.ACCESS_TOKEN);
    String platform = AppInfo.platformString;
    String osVersion = AppInfo.osVersion;
    String deviceName = AppInfo.deviceName;
    String appVersion = AppInfo.appVersion;
    String packageName = AppInfo.packageName;
    return {
      'Accept-Language': 'ja', // TODO
      'User-Agent': '$packageName/$appVersion/$platform/$osVersion/$deviceName',
      'Authorization': '$accessToken'
    };
  }

  // valueがnullである場合、keyごと削除する
  // 再帰的に全mapフィールドに対して処理する
  // TODO source -> IModel型へ変更する
  @visibleForTesting
  static Map<String, dynamic>? filterNonNullRecursively(
      Map<String, dynamic>? source) {
    if (source == null) return null;
    // sourceが直接持っているnull valueを削除し
    final nonNullMap = _filterNonNull(source);
    if (nonNullMap == null) return null;
    final result = Map<String, dynamic>.from(nonNullMap)
      ..updateAll((key, value) {
        if (value is IModel) {
          // valueがmodelクラスならjsonへ変換しつつ再帰的にnull除去
          return filterNonNullRecursively(value.toJson());
        } else {
          // 変換不要なvalueはそのまま採用
          return value;
        }
      });
    // MyLogger.d(result);
    return result;
  }

  static Map<String, dynamic>? _filterNonNull(Map<String, dynamic>? source) {
    if (source == null) return null;
    return Map.from(source)
      ..removeWhere((key, value) {
        return value == null;
      });
  }
}
