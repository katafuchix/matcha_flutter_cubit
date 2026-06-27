import 'package:dio/dio.dart';

import '../../core/configure.dart';
import '../../model/api/api_response.dart';
import '../../model/app_config/app_config.dart';
import '../../model/master/master_data.dart';
import '../../model/master/point_master.dart';
import '../../model/sign_in/sign_in_request.dart';
import '../../model/sign_in/sign_in_response.dart';
import '../../model/sign_up/sign_up_request.dart';
import '../../model/sign_up/sign_up_response.dart';
import 'dio_wrapper.dart';

// access token不要のAPI
class OpenApiProvider {
  static DioWrapper? _dio;

  OpenApiProvider() {
    if (_dio == null) {
      _dio = DioWrapper(Dio(), false, Config.environment.apiBaseUrl);
    }
  }

  Future<ApiResponse<SignInResponse>> postSignIn(SignInRequest request) async {
    return _dio!.postRequest('/api/v1/user/login', request.toJson(),
        (json) => SignInResponse.fromJson(json));
  }

  Future<ApiResponse<SignUpResponse>> postCreateUser(
      SignUpRequest request) async {
    return _dio!.postRequest('/api/v1/user/create', request.toJson(),
        (json) => SignUpResponse.fromJson(json));
  }

  Future<ApiResponse<List<MasterData>>> getInquiryMaster() async {
    return _dio!.getRequest('/api/v1/profile_masters/inquiry_category', null,
        (json) => (json as List).map((e) => MasterData.fromJson(e)).toList());
  }

  Future<ApiResponse<List<MasterData>>> getPrefectureMaster() async {
    return _dio!.getRequest('/api/v1/profile_masters/prefecture', null,
        (json) => (json as List).map((e) => MasterData.fromJson(e)).toList());
  }

  Future<ApiResponse<List<MasterData>>> getHeightMaster() async {
    return _dio!.getRequest('/api/v1/profile_masters/height', null,
        (json) => (json as List).map((e) => MasterData.fromJson(e)).toList());
  }

  Future<ApiResponse<List<MasterData>>> getAnimalMaster() async {
    return _dio!.getRequest('/api/v1/profile_masters/animal', null,
        (json) => (json as List).map((e) => MasterData.fromJson(e)).toList());
  }

  Future<ApiResponse<List<MasterData>>> getJobMaster() async {
    return _dio!.getRequest('/api/v1/profile_masters/job', null,
        (json) => (json as List).map((e) => MasterData.fromJson(e)).toList());
  }

  Future<ApiResponse<List<MasterData>>> getHolidayMaster() async {
    return _dio!.getRequest('/api/v1/profile_masters/holiday', null,
        (json) => (json as List).map((e) => MasterData.fromJson(e)).toList());
  }

  Future<ApiResponse<List<MasterData>>> getHobbyMaster() async {
    return _dio!.getRequest('/api/v1/profile_masters/hobby', null,
        (json) => (json as List).map((e) => MasterData.fromJson(e)).toList());
  }

  Future<ApiResponse<List<MasterData>>> getBloodMaster() async {
    return _dio!.getRequest('/api/v1/profile_masters/blood', null,
        (json) => (json as List).map((e) => MasterData.fromJson(e)).toList());
  }

  Future<ApiResponse<List<PointMaster>>> getPointMaster() async {
    return _dio!.getRequest('/api/v1/point_masters', null,
        (json) => (json as List).map((e) => PointMaster.fromJson(e)).toList());
  }

  Future<ApiResponse<AppConfig>> getAppConfig() async {
    return _dio!.getRequest(
        '/api/v1/app/config', null, (json) => AppConfig.fromJson(json));
  }
}
