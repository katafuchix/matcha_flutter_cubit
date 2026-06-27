import '../core/event_tracking.dart';
import '../model/message/get_message_request.dart';
import '../model/message/message_image.dart';
import '../model/message/room_message.dart';
import '../model/message/send_message.dart';
import '../model/repository/repository_result.dart';
import '../model/user/target_user_id.dart';
import 'api/auth_api_provider.dart';
import 'base/base_repository.dart';

class MessageRepository extends BaseRepository {
  final AuthApiProvider _authApiProvider = AuthApiProvider();

  Future<RepositoryResult<void>> postSendMessage(SendMessage request) async {
    final result = await apiResponseToRepositoryResult(
        _authApiProvider.postSendMessage(request));
    if (!result.isError()) {
      AppEvent.sendMessageSendEvent();
    }
    return result;
  }

  Future<RepositoryResult<List<RoomMessage>>> getMessages(
          GetMessageRequest request) async =>
      apiResponseToRepositoryResult(_authApiProvider.getMessages(request));

  // メッセージ送り放題解放
  Future<RepositoryResult<void>> postFreeTalk(
          TargetUserRequest request) async =>
      apiResponseToRepositoryResult(_authApiProvider.postFreeTalk(request));

  Future<RepositoryResult<MessageImage>> postReadMessageImage(
          String roomId, int messageId) async =>
      apiResponseToRepositoryResult(
          _authApiProvider.postReadMessageImage(roomId, messageId));
}
