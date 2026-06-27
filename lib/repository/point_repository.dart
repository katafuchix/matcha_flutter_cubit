import '../model/point/point_model.dart';
import '../model/repository/repository_result.dart';
import 'api/auth_api_provider.dart';
import 'base/base_repository.dart';

class PointRepository extends BaseRepository {
  final AuthApiProvider _authApiProvider = AuthApiProvider();

  // チケット履歴取得
  Future<RepositoryResult<List<PointModel>>> getPointHistory(int page) async =>
      apiResponseToRepositoryResult(_authApiProvider.getPointHistory(page));
}
