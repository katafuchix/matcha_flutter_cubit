import '../model/repository/repository_result.dart';
import '../model/search_condition/search_condition.dart';
import '../model/user/profile_response.dart';
import 'api/auth_api_provider.dart';
import 'base/base_repository.dart';

class SearchRepository extends BaseRepository {
  final AuthApiProvider _authApiProvider = AuthApiProvider();

  Future<RepositoryResult<List<ProfileResponse>>> getMembers(
          SearchCondition condition) async =>
      apiResponseToRepositoryResult(_authApiProvider.getMembers(condition));

  Future<RepositoryResult<List<ProfileResponse>>> getMembersForGuest() async =>
      apiResponseToRepositoryResult(_authApiProvider.getMembersForGuest());
}
