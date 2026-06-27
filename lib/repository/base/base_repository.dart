import '../../model/api/api_response.dart';
import '../../model/repository/error_result.dart';
import '../../model/repository/repository_result.dart';

abstract class BaseRepository {
  Future<RepositoryResult<T>> apiResponseToRepositoryResult<T>(
      Future<ApiResponse<T>> response) async {
    final res = await response;
    RepositoryResult<T> repositoryResult;
    if (res is ApiSuccessResponse) {
      final r = res as ApiSuccessResponse;
      repositoryResult = RepositoryResult.success(
          r.data,
          RepositoryResultMisc(r.misc.requiredAppVersion,
              r.misc.loadedPageIndex, r.misc.totalCount, r.misc.badgeCount));
    } else {
      final errorRes = res as ApiErrorResponse;
      final error = errorRes.error;
      repositoryResult = RepositoryResult.error(
          ErrorResult(error?.errorCode, error?.message ?? ''),
          RepositoryResultMisc(
              errorRes.misc.requiredAppVersion, null, null, null));
    }
    return Future.value(repositoryResult);
  }
}
