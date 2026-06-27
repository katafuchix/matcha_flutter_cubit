import 'package:dio/dio.dart';

// import '../../core/constants.dart';
import '../../core/my_logger.dart';
import '../../model/repository/repository_result.dart';
// import '../auth_repository.dart';
import '../storage/shared_preferences/shared_preferences_keys.dart';
import '../storage/shared_preferences/shared_preferences_manager.dart';
import 'dio_log_interceptors.dart';

class DioAuthInterceptors extends DioLogInterceptors {
  final Dio _dio;
  Future<SharedPreferencesManager> get _sharedPreferencesManager =>
      SharedPreferencesManager.getInstance();

  DioAuthInterceptors(this._dio);

  @override
  Future onError(DioException dioError, ErrorInterceptorHandler handler) async {
    int? responseCode = dioError.response?.statusCode;
    String? oldAccessToken = (await _sharedPreferencesManager)
        .getString(SharedPreferencesKeys.ACCESS_TOKEN);

    if (oldAccessToken != null && responseCode == 401) {
      // MyLogger.i("トークン無効 ; ${dioError.response.request.uri.toString()}");
      // MyLogger.i("トークンをリフレッシュする");

      // String refreshToken = _sharedPreferencesManager
      //     .getString(SharedPreferencesKeys.REFRESH_TOKEN);

      // AuthRepository authRepository = AuthRepository();
      // TODO
      // RepositoryResult<ResourceOwnerPasswordCredentialsResponse> result =
      //     await authRepository.postTokenRefresh(TokenRefreshRequest(
      //         Constants.authGrantTypeAsRefresh,
      //         Constants.authClientId,
      //         refreshToken));

      // TODO
      // if (result is RepositorySuccessResult) {
      //   _saveToken((result as RepositorySuccessResult).data);
      // } else {
      //   // TODO エラーハンドリング ストアしているaccess tokenを消す、など
      //   return super.onError(dioError);
      // }

      (await _sharedPreferencesManager)
          .clearKey(SharedPreferencesKeys.ACCESS_TOKEN);

      MyLogger.i("トークン破棄した");

      // RequestOptions options = dioError.response.request;
      // options.headers.addAll(_createHeader());
      // MyLogger.i("新しいトークンでリクエストする");
      // return _dio.request(options.path, options: options);
    }
    handler.reject(dioError);
  }

  // TODO
  // void _saveToken(ResourceOwnerPasswordCredentialsResponse res) async {
  //   await _sharedPreferencesManager.putString(
  //       SharedPreferencesKeys.ACCESS_TOKEN, res?.accessToken);
  //   await _sharedPreferencesManager.putString(
  //       SharedPreferencesKeys.REFRESH_TOKEN, res?.refreshToken);
  //   await _sharedPreferencesManager.putInt(
  //       SharedPreferencesKeys.TOKEN_CREATED_AT, res?.createdAt);
  //   await _sharedPreferencesManager.putInt(
  //       SharedPreferencesKeys.TOKEN_EXPIRES_IN, res?.expiresIn);
  //   await _sharedPreferencesManager.putString(
  //       SharedPreferencesKeys.TOKEN_TYPE, res?.tokenType);
  // }

  Future<Map<String, dynamic>> _createHeader() async {
    // String tokenType =
    //     _sharedPreferencesManager.getString(SharedPreferencesKeys.TOKEN_TYPE);
    String? accessToken = (await _sharedPreferencesManager)
        .getString(SharedPreferencesKeys.ACCESS_TOKEN);
    return {
      'Content-Type': 'application/json',
      'Authorization': '$accessToken'
    };
  }
}
