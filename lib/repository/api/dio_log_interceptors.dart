import 'package:dio/dio.dart';

// ログなし
class DioLogInterceptors extends Interceptor {}

// ログ出力
// class DioLogInterceptors extends LogInterceptor {
//   DioLogInterceptors() {
//     super.responseHeader = true;
//     super.responseBody = true;
//     super.requestHeader = true;
//     super.requestBody = true;
//     super.request = true;
//   }
// }
