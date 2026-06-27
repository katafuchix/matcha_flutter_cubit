import '../model/matching/matched_response.dart';
import '../model/matching/matching_request.dart';
import '../model/matching/matching_response.dart';
import '../model/repository/repository_result.dart';
import 'api/auth_api_provider.dart';
import 'base/base_repository.dart';

class MatchingRepository extends BaseRepository {
  final AuthApiProvider _authApiProvider = AuthApiProvider();

  Future<RepositoryResult<MatchingResponse>> postCreateRoom(
          MatchingRequest request) async =>
      apiResponseToRepositoryResult(_authApiProvider.postCreateRoom(request));

  Future<RepositoryResult<List<MatchedResponse>>> getMatches(int page) async =>
      apiResponseToRepositoryResult(_authApiProvider.getMatches(page));
}
