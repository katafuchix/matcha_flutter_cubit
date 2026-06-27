import '../model/notification/notification_contents.dart';
import '../model/notification/notifications.dart';
import '../model/repository/repository_result.dart';
import 'api/auth_api_provider.dart';
import 'base/base_repository.dart';

class NotificationRepository extends BaseRepository {
  final AuthApiProvider _authApiProvider = AuthApiProvider();

  Future<RepositoryResult<List<Notifications>>> getNotifications(
          int page) async =>
      apiResponseToRepositoryResult(_authApiProvider.getNotifications(page));

  Future<RepositoryResult<List<Notifications>>> getUnreadNotifications(
          int page) async =>
      apiResponseToRepositoryResult(
          _authApiProvider.getUnreadNotifications(page));

  Future<RepositoryResult<NotificationContents>> postNotificationContents(
          NotificationContentsRequest request) async =>
      apiResponseToRepositoryResult(
          _authApiProvider.postNotificationContents(request));
}
