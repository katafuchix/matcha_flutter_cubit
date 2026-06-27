import '../model/purchase/android_purchase.dart';
import '../model/purchase/ios_purchase.dart';
import '../model/repository/repository_result.dart';
import 'api/auth_api_provider.dart';
import 'base/base_repository.dart';

class PurchaseRepository extends BaseRepository {
  final AuthApiProvider _authApiProvider = AuthApiProvider();

  // Android課金
  Future<RepositoryResult<AndroidPurchaseResponse>> postPurchaseForAndroid(
          AndroidPurchaseRequest request) async =>
      apiResponseToRepositoryResult(
          _authApiProvider.postPurchaseForAndroid(request));

  // Android課金復元用
  Future<RepositoryResult<AndroidPurchaseResponse>>
      postRestorePurchaseForAndroid(AndroidPurchaseRequest request) async =>
          apiResponseToRepositoryResult(
              _authApiProvider.postPurchaseForAndroid(request));

  // iOS課金
  Future<RepositoryResult<void>> postPurchaseForIos(
          IosPurchaseRequest request) async =>
      apiResponseToRepositoryResult(
          _authApiProvider.postPurchaseForIos(request));

  // iOS課金復元用
  Future<RepositoryResult<void>> postRestorePurchaseForIos(
          IosPurchaseRequest request) async =>
      apiResponseToRepositoryResult(
          _authApiProvider.postPurchaseForIos(request));
}
