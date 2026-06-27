import '../model/repository/repository_result.dart';
import '../model/sign_in/sign_in_request.dart';
import '../model/sign_in/sign_in_response.dart';
import '../model/sign_up/sign_up_request.dart';
import '../model/sign_up/sign_up_response.dart';
import 'api/open_api_provider.dart';
import 'base/base_repository.dart';

class AuthRepository extends BaseRepository {
  final OpenApiProvider _openApiProvider = OpenApiProvider();

  Future<RepositoryResult<SignInResponse>> postSignIn(
          SignInRequest request) async =>
      apiResponseToRepositoryResult(_openApiProvider.postSignIn(request));

  Future<RepositoryResult<SignUpResponse>> postCreateUser(
          SignUpRequest request) async =>
      apiResponseToRepositoryResult(_openApiProvider.postCreateUser(request));

  // Future<RepositoryResult<User>>
  //     postTokenRefresh(User request) async =>
  //         apiResponseToRepositoryResult(
  //             _openApiProvider.postTokenRefresh(request));
}
