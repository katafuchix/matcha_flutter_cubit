import 'package:dio/dio.dart';

import '../../core/configure.dart';
import '../../model/api/api_response.dart';
import '../../model/bbs/bbs.dart';
import '../../model/device_info/device_info.dart';
import '../../model/device_info/device_token.dart';
import '../../model/inquiry/inquiry.dart';
import '../../model/login_bonus/login_bonus.dart';
import '../../model/matching/matched_response.dart';
import '../../model/matching/matching_request.dart';
import '../../model/matching/matching_response.dart';
import '../../model/message/get_message_request.dart';
import '../../model/message/message_image.dart';
import '../../model/message/room_message.dart';
import '../../model/message/send_message.dart';
import '../../model/notification/notification_contents.dart';
import '../../model/notification/notifications.dart';
import '../../model/point/point_model.dart';
import '../../model/purchase/android_purchase.dart';
import '../../model/purchase/ios_purchase.dart';
import '../../model/search_condition/search_condition.dart';
import '../../model/user/handover.dart';
import '../../model/user/profile_response.dart';
import '../../model/user/target_user_action.dart';
import '../../model/user/target_user_id.dart';
import '../../model/user/update_profile.dart';
import '../../model/user/upload_image.dart';
import '../../model/visitor/visitor.dart';
import 'dio_wrapper.dart';

// access tokenが必用なAPI
class AuthApiProvider {
  static const int paginationLimitDefault = 25;

  static DioWrapper? _dio;

  AuthApiProvider() {
    if (_dio == null) {
      _dio = DioWrapper(Dio(), true, Config.environment.apiBaseUrl);
    }
  }

  // path指定でAPIコール
  Future<ApiResponse<T>> get<T>(
      String path, Function(Map<String, dynamic>) fromJson) async {
    return _dio!.getRequest(path, null, (json) => fromJson(json));
  }

  Future<ApiResponse<ProfileResponse>> getMe() async {
    return _dio!.getRequest(
        '/api/v1/me/profile', null, (json) => ProfileResponse.fromJson(json));
  }

  Future<ApiResponse<ProfileResponse>> getTargetProfile(
      int targetUserId) async {
    return _dio!.getRequest('/api/v1/$targetUserId/profile', null,
        (json) => ProfileResponse.fromJson(json));
  }

  Future<ApiResponse<ProfileResponse>> getTargetProfileImage(
      int targetUserId) async {
    return _dio!.getRequest('/api/v1/$targetUserId/profile_image', null,
        (json) => ProfileResponse.fromJson(json));
  }

  // プロフィール更新
  Future<ApiResponse<void>> postUpdateProfile(
      UpdateProfile updateProfile) async {
    return _dio!
        .postRequest('/api/v1/me/profile/update', updateProfile.toJson(), null);
  }

  Future<ApiResponse<void>> postProfileImage(UploadImage uploadImage) async {
    return _dio!.postRequest(
        '/api/v1/users/me/profile/images/create', uploadImage.toJson(), null);
  }

  Future<ApiResponse<void>> postUpdateProfileImage(
      UploadImage uploadImage) async {
    return _dio!.postRequest(
        '/api/v1/users/me/profile/images/update', uploadImage.toJson(), null);
  }

  Future<ApiResponse<void>> postLoginSetting(HandOver request) async {
    return _dio!
        .postRequest('/api/v1/user/login_setting', request.toJson(), null);
  }

  Future<ApiResponse<void>> postWithdraw() async {
    return _dio!.postRequest('/api/v1/user/withdrawal', null, null);
  }

  Future<ApiResponse<List<ProfileResponse>>> getFavorites(int page) async {
    return _dio!.getRequest(
        '/api/v1/users/outcomming/favorites', {'page': page}, (json) {
      return (json as List).map((e) => ProfileResponse.fromJson(e)).toList();
    });
  }

  Future<ApiResponse<List<ProfileResponse>>> getIncommingFavorites(
      int page) async {
    return _dio!.getRequest('/api/v1/users/incomming/favorites', {'page': page},
        (json) {
      return (json as List).map((e) => ProfileResponse.fromJson(e)).toList();
    });
  }

  Future<ApiResponse<void>> postCreateFavorites(
      TargetUserAction request) async {
    return _dio!.postRequest(
        '/api/v1/users/outcomming/favorites/create', request.toJson(), null);
  }

  Future<ApiResponse<void>> postDeleteFavorites(
      TargetUserAction request) async {
    return _dio!.postRequest(
        '/api/v1/users/outcomming/favorites/delete', request.toJson(), null);
  }

  Future<ApiResponse<List<ProfileResponse>>> getBlocks(int page) async {
    return _dio!.getRequest('/api/v1/users/outcomming/blocks', {'page': page},
        (json) {
      return (json as List).map((e) => ProfileResponse.fromJson(e)).toList();
    });
  }

  Future<ApiResponse<void>> postCreateBlock(TargetUserAction request) async {
    return _dio!.postRequest(
        '/api/v1/users/outcomming/blocks/create', request.toJson(), null);
  }

  Future<ApiResponse<void>> postDeleteBlock(TargetUserAction request) async {
    return _dio!.postRequest(
        '/api/v1/users/outcomming/blocks/delete', request.toJson(), null);
  }

  Future<ApiResponse<void>> postVersionInfo(DeviceInfo request) async {
    return _dio!
        .postRequest('/api/v1/users/post_version_info', request.toJson(), null);
  }

  Future<ApiResponse<LogInBonus>> postVersionToken(DeviceToken request) async {
    return _dio!.postRequest('/api/v1/users/foreground_validate_handler',
        request.toJson(), (json) => LogInBonus.fromJson(json));
  }

  // あしあと
  Future<ApiResponse<List<Visitor>>> getVisitors(int page) async {
    return _dio!.getRequest('/api/v1/users/visitors', {'page': page}, (json) {
      return (json as List).map((e) => Visitor.fromJson(e)).toList();
    });
  }

  // 問い合わせする
  Future<ApiResponse<void>> postCreateInquiries(Inquiry request) async {
    return _dio!
        .postRequest('/api/v1/user/inquiries/create', request.toJson(), null);
  }

  // ユーザープロフィール一覧を取得する
  Future<ApiResponse<List<ProfileResponse>>> getMembers(
      SearchCondition condition) async {
    return _dio!.getRequest('/api/v1/users/search/profiles', condition.toJson(),
        (json) {
      return (json as List).map((e) => ProfileResponse.fromJson(e)).toList();
    });
  }

  // ユーザープロフィール一覧を取得する (未ログイン時の一覧)
  Future<ApiResponse<List<ProfileResponse>>> getMembersForGuest() async {
    return _dio!.getRequest('/api/v1/users/search/list', null, (json) {
      return (json as List).map((e) => ProfileResponse.fromJson(e)).toList();
    });
  }

  Future<ApiResponse<MatchingResponse>> postCreateRoom(
      MatchingRequest request) async {
    return _dio!.postRequest('/api/v1/users/outcomming/relations/create',
        request.toJson(), (json) => MatchingResponse.fromJson(json));
  }

  Future<ApiResponse<List<MatchedResponse>>> getMatches(int page) async {
    return _dio!.getRequest('/api/v1/users/matchs', {'page': page}, (json) {
      return (json as List).map((e) => MatchedResponse.fromJson(e)).toList();
    });
  }

  Future<ApiResponse<void>> postSendMessage(SendMessage request) async {
    return _dio!
        .postRequest('/api/v1/users/message_post', request.toJson(), null);
  }

  Future<ApiResponse<List<RoomMessage>>> getMessages(
      GetMessageRequest request) async {
    return _dio!.getRequest('/api/v1/users/messages', request.toJson(), (json) {
      return (json as List).map((e) => RoomMessage.fromJson(e)).toList();
    });
  }

  // メッセージの画像を閲覧する（ポイント消費）
  Future<ApiResponse<MessageImage>> postReadMessageImage(
      String roomId, int messageId) async {
    return _dio!.postRequest('/api/v1/users/read_message_image',
        {'room_id': roomId, 'message_id': messageId}, (json) {
      return MessageImage.fromJson(json);
    });
  }

  // メッセージ送り放題解放
  Future<ApiResponse<void>> postFreeTalk(TargetUserRequest request) async {
    return _dio!.postRequest('/api/v1/users/freetalk', request.toJson(), null);
  }

  Future<ApiResponse<List<Notifications>>> getNotifications(int page) async {
    return _dio!.getRequest('/api/v1/users/notifications', {'page': page},
        (json) {
      return (json as List).map((e) => Notifications.fromJson(e)).toList();
    });
  }

  Future<ApiResponse<List<Notifications>>> getUnreadNotifications(
      int page) async {
    return _dio!.getRequest(
        '/api/v1/users/notifications/unreads', {'page': page}, (json) {
      return (json as List).map((e) => Notifications.fromJson(e)).toList();
    });
  }

  Future<ApiResponse<NotificationContents>> postNotificationContents(
      NotificationContentsRequest request) async {
    return _dio!.postRequest('/api/v1/users/notifications/contents',
        request.toJson(), (json) => NotificationContents.fromJson(json));
  }

  // Android課金
  Future<ApiResponse<AndroidPurchaseResponse>> postPurchaseForAndroid(
      AndroidPurchaseRequest request) async {
    return _dio!
        .postRequest('/api/v1/users/android_purchase', request.toJson(), null);
  }

  // Android課金復元用
  Future<ApiResponse<AndroidPurchaseResponse>> postRestorePurchaseForAndroid(
      AndroidPurchaseRequest request) async {
    return _dio!.postRequest(
        '/api/v1/users/restore_android_purchase', request.toJson(), null);
  }

  // iOS課金
  Future<ApiResponse<void>> postPurchaseForIos(
      IosPurchaseRequest request) async {
    return _dio!
        .postRequest('/api/v1/users/ios_purchase', request.toJson(), null);
  }

  // iOS課金復元用
  Future<ApiResponse<void>> postRestorePurchaseForIos(
      IosPurchaseRequest request) async {
    return _dio!.postRequest(
        '/api/v1/users/restore_ios_purchase', request.toJson(), null);
  }

  // チケット履歴取得
  Future<ApiResponse<List<PointModel>>> getPointHistory(int page) async {
    return _dio!.getRequest(
        '/api/v1/users/purchase_point_histories', {'page': page}, (json) {
      return (json as List).map((e) => PointModel.fromJson(e)).toList();
    });
  }

  // 自分の掲示板の投稿リストを取得する
  Future<ApiResponse<List<BbsPostResponse>>> getMyBbsPostList(
      int? postCategoryId, int page) async {
    return _dio!.getRequest('/api/v1/user/bbs_post/my_list',
        {'post_category_id': postCategoryId, 'page': page}, (json) {
      return (json as List).map((e) => BbsPostResponse.fromJson(e)).toList();
    });
  }

  // 相手の掲示板の投稿リストを取得する
  Future<ApiResponse<List<BbsPostResponse>>> getBbsPostUserList(
      int userId, int? postCategoryId, int page) async {
    return _dio!.getRequest('/api/v1/user/bbs_post/user_list', {
      'user_id': userId,
      'post_category_id': postCategoryId,
      'page': page
    }, (json) {
      return (json as List).map((e) => BbsPostResponse.fromJson(e)).toList();
    });
  }

  // 掲示板の投稿リストを取得する
  Future<ApiResponse<List<ProfileResponse>>> getBbsPostList(
      int postCategoryId, int page) async {
    return _dio!.getRequest('/api/v1/user/bbs_post/list',
        {'post_category_id': postCategoryId, 'page': page}, (json) {
      return (json as List).map((e) => ProfileResponse.fromJson(e)).toList();
    });
  }

  // 掲示板の投稿を削除する
  Future<ApiResponse<void>> postDeleteBbsPost(DeleteBbsPost request) async {
    return _dio!
        .postRequest('/api/v1/user/bbs_post/delete', request.toJson(), null);
  }

  // 掲示板に投稿する
  Future<ApiResponse<void>> postCreateBbsPost(BbsPost request) async {
    return _dio!
        .postRequest('/api/v1/user/bbs_post/create', request.toJson(), null);
  }
}
