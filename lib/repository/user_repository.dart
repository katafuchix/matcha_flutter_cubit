import '../core/event_tracking.dart';
import '../model/basic/sex.dart';
import '../model/device_info/device_info.dart';
import '../model/device_info/device_token.dart';
import '../model/inquiry/inquiry.dart';
import '../model/login_bonus/login_bonus.dart';
import '../model/repository/repository_result.dart';
import '../model/user/handover.dart';
import '../model/user/profile_response.dart';
import '../model/user/target_user_action.dart';
import '../model/user/update_profile.dart';
import '../model/user/upload_image.dart';
import '../model/visitor/visitor.dart';
import 'api/auth_api_provider.dart';
import 'base/base_repository.dart';
import 'memory_cache/memory_cache.dart';

class UserRepository extends BaseRepository {
  final AuthApiProvider _authApiProvider = AuthApiProvider();

  static final MemoryCache<ProfileResponse> _meCache = MemoryCache();
  // 一度受信したら不変なもの
  static late int _myUserId;
  static int get myUserId => _myUserId;
  static late Sex _mySex;
  static Sex get mySex => _mySex;

  Future<RepositoryResult<ProfileResponse>> getLatestMe() async {
    final result =
        await apiResponseToRepositoryResult(_authApiProvider.getMe());

    ProfileResponse? data = result.getData();
    if (data != null) {
      _meCache.saveSingleData(data);

      _myUserId = data.profile.userId;
      _mySex = data.profile.sexEnum;

      EventTracking.onRefreshUser(_myUserId);
    }

    return result;
  }

  // キャッシュがあればキャッシュを返す
  Future<RepositoryResult<ProfileResponse>> getMe() async {
    final ProfileResponse? cache = _meCache.getSingleData();

    if (cache != null) {
      return RepositorySuccessResult(cache, null);
    }

    // APIコール
    return getLatestMe();
  }

  // 相手のプロフィール取得
  Future<RepositoryResult<ProfileResponse>> getTargetProfile(
          int targetUserId) async =>
      apiResponseToRepositoryResult(
          _authApiProvider.getTargetProfile(targetUserId));

  // 相手のプロフィール画像取得
  Future<RepositoryResult<ProfileResponse>> getTargetProfileImage(
          int targetUserId) async =>
      apiResponseToRepositoryResult(
          _authApiProvider.getTargetProfileImage(targetUserId));

  Future<RepositoryResult<void>> postUpdateProfile(
          UpdateProfile updateProfile) async =>
      apiResponseToRepositoryResult(
          _authApiProvider.postUpdateProfile(updateProfile));

  Future<RepositoryResult<void>> postProfileImage(
          UploadImage uploadImage) async =>
      apiResponseToRepositoryResult(
          _authApiProvider.postProfileImage(uploadImage));

  Future<RepositoryResult<void>> postUpdateProfileImage(
          UploadImage uploadImage) async =>
      apiResponseToRepositoryResult(
          _authApiProvider.postUpdateProfileImage(uploadImage));

  Future<RepositoryResult<void>> postLoginSetting(HandOver request) async =>
      apiResponseToRepositoryResult(_authApiProvider.postLoginSetting(request));

  // 退会
  Future<RepositoryResult<void>> postWithdraw() async =>
      apiResponseToRepositoryResult(_authApiProvider.postWithdraw());

  // お気に入り一覧
  Future<RepositoryResult<List<ProfileResponse>>> getFavorites(
          int page) async =>
      apiResponseToRepositoryResult(_authApiProvider.getFavorites(page));

  // お気に入りされた一覧
  Future<RepositoryResult<List<ProfileResponse>>> getIncommingFavorites(
          int page) async =>
      apiResponseToRepositoryResult(
          _authApiProvider.getIncommingFavorites(page));

  // お気に入りする
  Future<RepositoryResult<void>> postCreateFavorites(
          TargetUserAction request) async =>
      apiResponseToRepositoryResult(
          _authApiProvider.postCreateFavorites(request));

  // お気に入り解除
  Future<RepositoryResult<void>> postDeleteFavorites(
          TargetUserAction request) async =>
      apiResponseToRepositoryResult(
          _authApiProvider.postDeleteFavorites(request));

  // ブロック一覧
  Future<RepositoryResult<List<ProfileResponse>>> getBlocks(int page) async =>
      apiResponseToRepositoryResult(_authApiProvider.getBlocks(page));

  // ブロックする
  Future<RepositoryResult<void>> postCreateBlock(
          TargetUserAction request) async =>
      apiResponseToRepositoryResult(_authApiProvider.postCreateBlock(request));

  // ブロック解除
  Future<RepositoryResult<void>> postDeleteBlock(
          TargetUserAction request) async =>
      apiResponseToRepositoryResult(_authApiProvider.postDeleteBlock(request));

  // ユーザーのOSや端末情報、アプリのバージョン情報を記録する
  Future<RepositoryResult<void>> postVersionInfo(DeviceInfo request) async =>
      apiResponseToRepositoryResult(_authApiProvider.postVersionInfo(request));

  // ログインボーナス処理
  Future<RepositoryResult<LogInBonus>> postVersionToken(
          DeviceToken request) async =>
      apiResponseToRepositoryResult(_authApiProvider.postVersionToken(request));

  // あしあと一覧
  Future<RepositoryResult<List<Visitor>>> getVisitors(int page) async =>
      apiResponseToRepositoryResult(_authApiProvider.getVisitors(page));

  // 問い合わせする
  Future<RepositoryResult<void>> postCreateInquiries(Inquiry request) async =>
      apiResponseToRepositoryResult(
          _authApiProvider.postCreateInquiries(request));
}
