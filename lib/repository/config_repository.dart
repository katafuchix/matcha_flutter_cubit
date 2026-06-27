import '../model/app_config/app_config.dart';
import '../model/repository/repository_result.dart';
import 'api/open_api_provider.dart';
import 'base/base_repository.dart';

class ConfigRepository extends BaseRepository {
  final OpenApiProvider _openApiProvider = OpenApiProvider();

  Future<RepositoryResult<AppConfig>> getAppConfig() async =>
      apiResponseToRepositoryResult(_openApiProvider.getAppConfig());
}
