import '../model/bbs/bbs.dart';
import '../model/user/profile_response.dart';

import '../model/repository/repository_result.dart';
import 'api/auth_api_provider.dart';
import 'base/base_repository.dart';

class BbsRepository extends BaseRepository {
  final AuthApiProvider _authApiProvider = AuthApiProvider();

  // 自分の掲示板の投稿リストを取得する
  Future<RepositoryResult<List<BbsPostResponse>>> getMyBbsPostList(
          int? postCategoryId, int page) async =>
      apiResponseToRepositoryResult(
          _authApiProvider.getMyBbsPostList(postCategoryId, page));

  // 相手の掲示板の投稿リストを取得する
  Future<RepositoryResult<List<BbsPostResponse>>> getBbsPostUserList(
          int userId, int? postCategoryId, int page) async =>
      apiResponseToRepositoryResult(
          _authApiProvider.getBbsPostUserList(userId, postCategoryId, page));

  // 掲示板の投稿リストを取得する
  Future<RepositoryResult<List<ProfileResponse>>> getBbsPostList(
          int postCategoryId, int page) async =>
      apiResponseToRepositoryResult(
          _authApiProvider.getBbsPostList(postCategoryId, page));

  // 掲示板の投稿を削除する
  Future<RepositoryResult<void>> postDeleteBbsPost(
          DeleteBbsPost request) async =>
      apiResponseToRepositoryResult(
          _authApiProvider.postDeleteBbsPost(request));

  // 掲示板に投稿する
  Future<RepositoryResult<void>> postCreateBbsPost(BbsPost request) async =>
      apiResponseToRepositoryResult(
          _authApiProvider.postCreateBbsPost(request));
}
