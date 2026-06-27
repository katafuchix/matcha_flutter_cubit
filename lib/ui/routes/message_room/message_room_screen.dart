import 'dart:convert';
import 'dart:typed_data';

import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/app_info.dart';
import '../../../core/colors.dart';
import '../../../core/my_logger.dart';
import '../../../model/message/get_message_request.dart';
import '../../../model/message/message_image.dart';
import '../../../model/message/message_type.dart';
import '../../../model/message/room_message.dart';
import '../../../model/message/send_message.dart';
import '../../../model/repository/repository_result.dart';
import '../../../model/user/profile_response.dart';
import '../../../repository/message_repository.dart';
import '../../app.dart';
import '../../base/base_stateful_widget.dart';
import '../../components/containers.dart';
import '../../components/datetime_util.dart';
import '../../components/dialogs.dart';
import '../../components/image_loader.dart';
import '../../components/snack_bar.dart';
import '../../components/texts.dart';
import '../../helper/image_util.dart';
import '../../helper/repository_handler.dart';
import '../../my_navigator.dart';
import '../home/app_bars.dart';
import '../profile/profile_screen.dart';
import '../simple_text/simple_image_screen.dart';

class _MessageRoomScreenArgs {
  final String roomId;
  final ProfileResponse myProfile;
  final ProfileResponse targetProfile;

  _MessageRoomScreenArgs(
      {required this.roomId,
      required this.myProfile,
      required this.targetProfile});
}

class MessageRoomScreen extends BaseStatefulWidget {
  static final _keyArgs = 'key_message_room_args';

  MessageRoomScreen({required ScreenArgs args}) : super(args: args);

  static ScreenArgs createScreenArgs(
      {required String roomId,
      required ProfileResponse myProfile,
      required ProfileResponse targetProfile}) {
    ScreenArgs args = ScreenArgs()
      ..put(
        _keyArgs,
        _MessageRoomScreenArgs(
            roomId: roomId, myProfile: myProfile, targetProfile: targetProfile),
      );
    return args;
  }

  @override
  State<StatefulWidget> createState() {
    final _MessageRoomScreenArgs screenArgs = getArgs();
    return _MessageRoomScreenState(
        screenArgs.roomId, screenArgs.myProfile, screenArgs.targetProfile);
  }

  @override
  String getArgsKey() {
    return _keyArgs;
  }
}

class _MessageRoomScreenState extends BaseState<MessageRoomScreen> {
  _MessageRoomScreenState(this._roomId, this._myProfile, this._targetProfile)
      : _myChatUser = ChatUser(
          id: _myProfile.profile.userId.toString(),
          firstName: _myProfile.profile.nickname,
          profileImage: ImageLoader.profileResponseToFullPath(_myProfile),
        ),
        _targetChatUser = ChatUser(
          id: _targetProfile.profile.userId.toString(),
          firstName: _targetProfile.profile.nickname,
          profileImage: ImageLoader.profileResponseToFullPath(_targetProfile),
        ),
        super(null);

  static const String _customPropertiesPaid = 'is_paid';
  static const String _customPropertiesMessageId = 'message_id';
  static const String customPropertiesBase64ImageKey = 'local_base64_image';

  final String _roomId;
  final ProfileResponse _myProfile;
  final ProfileResponse _targetProfile;
  final ChatUser _myChatUser;
  final ChatUser _targetChatUser;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final MessageRepository _messageRepository = MessageRepository();
  final AppColors _colors = getAppColors();

  List<ChatMessage> messages = [];
  int? _page = 1;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _init();
    MyLogger.d(_roomId);
  }

  Future _init() async {
    _page = 1;
    _isLoading = false;
    messages.clear();
    _loadMessages();
  }

  bool isMe(int userId) => userId == _myProfile.profile.userId;

  bool isMeFromId(String? id) => id == _myProfile.profile.userId.toString();

  Future _loadMessages() async {
    if (_page == null || _isLoading) return;

    _isLoading = true;
    final result =
        await _messageRepository.getMessages(GetMessageRequest(_roomId, _page));
    RepositoryHandler.handleRepositoryResult(context, result,
        onSuccess: (List<RoomMessage>? result, RepositoryResultMisc? misc) {
      List<ChatMessage>? chatMessages = result?.map((e) {
        final DateTime createdAt =
            DateTimeConverter.dateTimeFromLocalDateTime(e.createdAt) ??
                DateTime.now();

        String text = '';
        List<ChatMedia>? medias;
        if (e.type == MessageType.TEXT) {
          text = e.content;
        } else {
          final imageUrl = ImageLoader.apiUrlToFullPath(e.content);
          if (imageUrl != null) {
            medias = [
              ChatMedia(url: imageUrl, fileName: '', type: MediaType.image)
            ];
          }
        }

        if (isMe(e.senderUserId)) {
          return ChatMessage(
            text: text,
            medias: medias,
            user: _myChatUser,
            createdAt: createdAt,
            customProperties: {_customPropertiesPaid: true},
          );
        } else {
          return ChatMessage(
            text: text,
            medias: medias,
            user: _targetChatUser,
            createdAt: createdAt,
            customProperties: {
              _customPropertiesPaid: e.isPaid,
              _customPropertiesMessageId: e.id,
            },
          );
        }
      }).toList();

      if (misc?.loadedPageIndex == null || misc?.totalCount == 0) {
        _page = null;
      } else {
        _page = (misc?.loadedPageIndex ?? 0) + 1;
      }

      if (chatMessages != null) {
        setState(() {
          messages.addAll(chatMessages.reversed);
        });
      }
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Containers.createScreenContainer(context, _buildMainWidget());
  }

  Widget _buildMainWidget() {
    return Scaffold(
      key: _scaffoldKey,
      appBar: buildNormalAppBar(context, _targetProfile.profile.nickname),
      body: SafeArea(
        child: _buildMainList(),
      ),
    );
  }

  Future _sendText(String message) async {
    showProgress(_scaffoldKey.currentContext!);
    final result = await _messageRepository.postSendMessage(
        SendMessage.asMessage(roomId: _roomId, message: message));
    RepositoryHandler.handleRepositoryResult<void>(context, result,
        onSuccess: (_, __) {}, showErrorMessage: true);
    _init();
    closeProgressIfNeed(_scaffoldKey.currentContext!);
  }

  Future _sendImage(String base64Image) async {
    showProgress(_scaffoldKey.currentContext!);
    final result = await _messageRepository.postSendMessage(
        SendMessage.asImage(roomId: _roomId, base64Image: base64Image));
    RepositoryHandler.handleRepositoryResult<void>(context, result,
        onSuccess: (_, __) {}, showErrorMessage: true);
    _init();
    closeProgressIfNeed(_scaffoldKey.currentContext!);
  }

  Widget _messageTextWidget(ChatMessage message) {
    // ローカルbase64画像(送信前プレビュー)
    if (message.customProperties
                ?.containsKey(customPropertiesBase64ImageKey) ==
            true &&
        message.text?.isEmpty == true) {
      final Uint8List u =
          base64Decode(message.customProperties![customPropertiesBase64ImageKey]);
      return InkWell(
        onTap: () {
          MyNavigator.pushNamed(context, Routes.simpleImage,
              arguments:
                  SimpleImageScreen.createScreenArgs('画像', image: u));
        },
        child: Image.memory(
          u,
          height: AppInfo.getAppWidth(context) / 4,
          width: AppInfo.getAppWidth(context) / 4,
        ),
      );
    }
    return buildNormalText(
      message.text ?? '',
      colors: isMeFromId(message.user.id)
          ? TextColors.TEXT_OR_ICON
          : TextColors.PRIMARY_TEXT,
    );
  }

  Widget _messageMediaWidget(ChatMessage message) {
    final media = message.medias?.firstOrNull;
    if (media == null) return const SizedBox.shrink();

    return InkWell(
      onTap: () {
        final bool isPaid =
            message.customProperties?[_customPropertiesPaid] ?? false;
        final int? messageId =
            message.customProperties?[_customPropertiesMessageId];

        if (isPaid) {
          MyNavigator.pushNamed(context, Routes.simpleImage,
              arguments:
                  SimpleImageScreen.createScreenArgs('画像', url: media.url));
        } else {
          showAlertDialog(
            context,
            message: 'フィルターを解除して画像を表示しますか？',
            okLabel: 'はい',
            cancelLabel: 'いいえ',
            onOk: () async {
              final result = await _messageRepository.postReadMessageImage(
                  _roomId, messageId!);
              RepositoryHandler.handleRepositoryResult(context, result,
                  onSuccess: (MessageImage? result, _) {
                _init();
                final String? imageUrl =
                    ImageLoader.apiUrlToFullPath(result?.image);
                MyNavigator.pushNamed(context, Routes.simpleImage,
                    arguments:
                        SimpleImageScreen.createScreenArgs('画像', url: imageUrl));
              }, onError: (statusCode, errorMessage) {
                showErrorSnackBar(context,
                    text: errorMessage ?? '画像の読み込みに失敗しました。時間をあけておためしください。');
              });
            },
          );
        }
      },
      child: Image.network(
        media.url,
        width: AppInfo.getAppWidth(context) / 4,
        height: AppInfo.getAppWidth(context) / 4,
      ),
    );
  }

  BoxDecoration _messageDecorationBuilder(ChatMessage message,
      ChatMessage? previousMessage, ChatMessage? nextMessage) {
    final bool isMe = isMeFromId(message.user.id);
    return BoxDecoration(
      color: isMe ? _colors.primary : _colors.primaryLight,
      borderRadius: BorderRadius.circular(5.0),
    );
  }

  Widget _buildMainList() {
    return DashChat(
      currentUser: _myChatUser,
      onSend: _onSend,
      messages: messages,
      inputOptions: InputOptions(
        inputDecoration:
            const InputDecoration.collapsed(hintText: "テキストを入力..."),
        inputTextStyle: const TextStyle(fontSize: 16.0),
        inputToolbarStyle: BoxDecoration(
          border: Border.all(width: 0.0),
          color: _colors.primaryLight,
        ),
        sendOnEnter: false,
        alwaysShowSend: false,
        textInputAction: TextInputAction.send,
        trailing: [
          IconButton(
            icon: const Icon(Icons.photo),
            onPressed: () async {
              final String? base64Image =
                  await ImageUtil.base64ImagePicker(context: context);
              if (base64Image != null) {
                _sendImage(base64Image);
              }
            },
          ),
        ],
      ),
      messageOptions: MessageOptions(
        showTime: true,
        timeFormat: DateFormat('HH:mm'),
        showCurrentUserAvatar: true,
        onPressAvatar: (ChatUser user) {
          if (!isMeFromId(user.id)) {
            MyNavigator.pushNamed(context, Routes.profile,
                arguments: ProfileScreen.createScreenArgs(_targetProfile));
          }
        },
        onLongPressAvatar: (ChatUser user) {},
        messageDecorationBuilder: _messageDecorationBuilder,
        messageTextBuilder: (message, previousMessage, nextMessage) =>
            _messageTextWidget(message),
        messageMediaBuilder: (message, previousMessage, nextMessage) =>
            _messageMediaWidget(message),
      ),
      messageListOptions: MessageListOptions(
        dateSeparatorFormat: DateFormat('yyyy/MM/dd'),
        onLoadEarlier: () async {
          _loadMessages();
        },
      ),
    );
  }

  void _onSend(ChatMessage message) {
    setState(() {
      _sendText(message.text ?? '');
    });
  }
}
