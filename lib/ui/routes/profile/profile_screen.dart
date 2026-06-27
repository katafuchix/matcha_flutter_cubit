import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/colors.dart';
import '../../../core/event_tracking.dart';
import '../../../core/my_logger.dart';
import '../../../model/bbs/bbs.dart';
import '../../../model/inquiry/inquiry.dart';
import '../../../model/matching/matching_request.dart';
import '../../../model/matching/matching_response.dart';
import '../../../model/message/send_message.dart';
import '../../../model/repository/repository_result.dart';
import '../../../model/user/profile_response.dart';
import '../../../model/user/target_user_action.dart';
import '../../../model/user/target_user_id.dart';
import '../../../repository/bbs_repository.dart';
import '../../../repository/matching_repository.dart';
import '../../../repository/message_repository.dart';
import '../../../repository/user_repository.dart';
import '../../../ui/components/image_loader.dart';
import '../../../ui/routes/home/home_change_notifier.dart';
import '../../../ui/routes/simple_text/simple_image_screen.dart';
import '../../app.dart';
import '../../base/base_stateful_widget.dart';
import '../../components/containers.dart';
import '../../components/dialogs.dart';
import '../../components/image_loader.dart';
import '../../components/profile_util.dart';
import '../../components/snack_bar.dart';
import '../../components/text_field.dart';
import '../../components/texts.dart';
import '../../components/widget_circular_progress.dart';
import '../../helper/repository_handler.dart';
import '../../my_navigator.dart';
import '../home/app_bars.dart';
import '../home/home_change_notifier.dart';
import '../simple_text/simple_image_screen.dart';

class _ProfileScreenArgs {
  final ProfileResponse profile;
  final bool isMe;

  _ProfileScreenArgs(this.profile, this.isMe);
}

class ProfileScreen extends BaseStatefulWidget {
  static final _keyArgs = 'key_profile_args';

  ProfileScreen({required ScreenArgs args}) : super(args: args);

  static ScreenArgs createScreenArgs(ProfileResponse profile,
      {bool isMe = false}) {
    ScreenArgs args = ScreenArgs()
      ..put(
        _keyArgs,
        _ProfileScreenArgs(profile, isMe),
      );
    return args;
  }

  @override
  State<StatefulWidget> createState() {
    final _ProfileScreenArgs screenArgs = getArgs();
    return _ProfileScreen(screenArgs.profile, screenArgs.isMe);
  }

  @override
  String getArgsKey() {
    return _keyArgs;
  }
}

class ProfileScreenViewData {
  final ProfileResponse? profile;
  final bool? enableFreeTalk;

  ProfileScreenViewData(this.profile, this.enableFreeTalk);
}

class _ProfileScreen extends BaseState<ProfileScreen> {
  ProfileResponse? _profile;
  bool? _enableFreeTalk;
  bool _showProgress = false;

  final bool _isMe;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final UserRepository _userRepository = UserRepository();
  final BbsRepository _bbsRepository = BbsRepository();
  final MessageRepository _messageRepository = MessageRepository();

  _ProfileScreen(this._profile, this._isMe) : super(null);

  @override
  void initState() {
    super.initState();
    _refreshProfileIfNeed();
  }

  Future _refreshProfileIfNeed() async {
    if (_isMe == false) {
      if (_profile?.profile == null) return;
      {
        final result =
            await _userRepository.getTargetProfile(_profile!.profile.userId);
        ProfileResponse? profile = RepositoryHandler.getSuccessOrNull(result);
        _profile = profile;
      }
      {
        final result = await _bbsRepository.getBbsPostUserList(
            _profile!.profile.userId, /*BbsPost.defaultCategoryId*/ null, 1);
        final List<BbsPostResponse>? bbsPostList = result.getData();
        if (bbsPostList?.isNotEmpty == true) {
          _profile!.recentPost = [bbsPostList!.first.bbsPost];
        }
      }
      {
        final result = await _userRepository.getLatestMe();
        ProfileResponse? myProfile = RepositoryHandler.getSuccessOrNull(result);
        _enableFreeTalk = myProfile?.profile.freeTalkUserIds
            ?.contains(_profile?.profile.userId);
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildMainWidget(context);
  }

  Widget _buildMainWidget(BuildContext context) {
    return SafeArea(
      top: false,
      child: PopScope(
          canPop: true,
          onPopInvokedWithResult: (didPop, result) {
            if (didPop) ScaffoldMessenger.of(context).removeCurrentSnackBar();
          },
          child: Containers.createScreenContainer(
            context,
            _buildViewData(
                context, ProfileScreenViewData(_profile, _enableFreeTalk)),
          )),
    );
  }

  Widget _buildViewData(BuildContext context, ProfileScreenViewData viewData) {
    List<Widget>? actions;
    if (!_isMe) {
      actions = [
        _buildFreeTalkIconButton(viewData),
        _buildReportViolationButton(viewData),
        _buildBlockIconButton(viewData),
        _buildFavoriteIconButton(viewData)
      ];
    }
    final stack = Stack(
      alignment: AlignmentDirectional.center,
      children: [
        ProfileBodyWidget(profile: viewData.profile!, isMe: _isMe),
        _showProgress ? buildWidgetCircularProgress() : Container(),
      ],
    );
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: true,
      appBar: buildNormalAppBar(
          context, viewData.profile?.profile.nickname ?? '',
          actions: actions),
      body: stack,
    );
  }

  Widget _buildFreeTalkIconButton(final ProfileScreenViewData viewData) {
    if (viewData.enableFreeTalk == true) {
      return Container();
    } else {
      return IconButton(
          icon: Icon(
            Icons.lock,
            color: Colors.white,
          ),
          onPressed: () async {
            showAlertDialog(_scaffoldKey.currentContext!,
                title: '確認',
                message: 'チケット2100枚でお相手に送るメッセージが全て無料になります。2100枚を使いますか？',
                cancelable: true, onOk: () async {
              await _setEnableFreeTalk(viewData.profile!.profile.userId);
            });
          });
    }
  }

  Future _setEnableFreeTalk(int targetUserId) async {
    // TODO ポイント不足ならチケット購入画面へ (とりあえずはAPIで担保されているので劣後)

    _showProgressImpl();

    final result =
        await _messageRepository.postFreeTalk(TargetUserRequest(targetUserId));

    closeProgressIfNeed(_scaffoldKey.currentContext!);

    RepositoryHandler.handleRepositoryResult<void>(context, result,
        onSuccess: (res, _) async {
      showAlertDialog(_scaffoldKey.currentContext!,
          title: 'お知らせ',
          message: '${_profile!.profile.nickname}さんにメッセージが送り放題になりました！',
          cancelable: false, onOk: () async {
        await _matchingAndNavigateMessageRoom(context,
            scaffoldKey: _scaffoldKey,
            targetUserId: targetUserId,
            firstMessage: "",
            showProgress: _showProgressImpl,
            closeProgress: _closeProgressImpl);
      });
    }, onError: (int? statusCode, String? errorMessage) {
      showErrorDialog(context, errorMessage!);
    });
  }

  Widget _buildBlockIconButton(ProfileScreenViewData viewData) {
    if (viewData.profile!.relation?.outcommingBlock == true) {
      return IconButton(
          icon: Icon(
            Icons.check_circle_outline,
            color: Colors.white,
          ),
          onPressed: () async {
            showAlertDialog(_scaffoldKey.currentContext!,
                title: 'ブロック解除',
                message: 'ブロック解除しますか？',
                cancelable: true, onOk: () async {
              _showProgressImpl();
              final result = await _userRepository.postDeleteBlock(
                  TargetUserAction(viewData.profile!.profile.userId));
              RepositoryHandler.handleRepositoryResult<void>(
                  _scaffoldKey.currentContext!, result,
                  onSuccess: (_, __) async {
                await _refreshProfileIfNeed();
                _closeProgressImpl();
                showInfoSnackBar(_scaffoldKey.currentContext!,
                    text: 'ブロック解除しました');
                // ブロックリストから削除
                BlockNotifier.getNoListenerNotifier(
                        _scaffoldKey.currentContext!)
                    .removeItem(viewData.profile!.profile.userId);
              }, onError: (_, __) {
                _closeProgressImpl();
              });
            });
          });
    } else {
      return IconButton(
          icon: Icon(
            Icons.block_outlined,
            color: Colors.white,
          ),
          onPressed: () async {
            showAlertDialog(_scaffoldKey.currentContext!,
                title: 'ブロックする',
                message: 'ブロックしますか？',
                cancelable: true, onOk: () async {
              _showProgressImpl();
              final result = await _userRepository.postCreateBlock(
                  TargetUserAction(viewData.profile!.profile.userId));
              RepositoryHandler.handleRepositoryResult<void>(
                  _scaffoldKey.currentContext!, result,
                  onSuccess: (_, __) async {
                await _refreshProfileIfNeed();
                _closeProgressImpl();
                showInfoSnackBar(_scaffoldKey.currentContext!,
                    text: 'ブロックしました');
                _removeProfile(viewData.profile!.profile.userId);
              }, onError: (_, __) {
                _closeProgressImpl();
              });
            });
          });
    }
  }

  Widget _buildReportViolationButton(ProfileScreenViewData viewData) {
    return IconButton(
        icon: Icon(
          Icons.do_not_touch_outlined,
          color: Colors.white,
        ),
        onPressed: () async {
          showAlertDialog(_scaffoldKey.currentContext!,
              title: '通報する',
              message: 'このユーザーを通報しますか？',
              cancelable: true, onOk: () async {
            _showProgressImpl();
            await _userRepository.postCreateInquiries(
                Inquiry(221, '<違反報告> ユーザーID : ${_profile?.profile.userId}'));
            await _userRepository.postCreateBlock(
                TargetUserAction(viewData.profile!.profile.userId));
            await _refreshProfileIfNeed();
            _removeProfile(viewData.profile!.profile.userId);
            _closeProgressImpl();
            showInfoSnackBar(_scaffoldKey.currentContext!, text: '通報しました。');
          });
        });
  }

  _removeProfile(int userId) {
    // 探す画面から削除
    SearchingNotifier.getNoListenerNotifier(_scaffoldKey.currentContext!)
        .removeItem(userId);
    // BBS画面から削除
    BbsNotifier.getNoListenerNotifier(_scaffoldKey.currentContext!)
        .removeItem(userId);
    // ブロックリスト更新
    BlockNotifier.getNoListenerNotifier(_scaffoldKey.currentContext!)
        .updateList(context);
  }

  Widget _buildFavoriteIconButton(ProfileScreenViewData viewData) {
    if (viewData.profile!.relation?.outcommingFavorite == true) {
      return IconButton(
          icon: Icon(
            Icons.favorite,
            color: Colors.white,
          ),
          onPressed: () async {
            showAlertDialog(_scaffoldKey.currentContext!,
                title: 'お気に入り解除',
                message: 'お気に入り解除しますか？',
                cancelable: true, onOk: () async {
              _showProgressImpl();
              final result = await _userRepository.postDeleteFavorites(
                  TargetUserAction(viewData.profile!.profile.userId));
              RepositoryHandler.handleRepositoryResult<void>(
                  _scaffoldKey.currentContext!, result,
                  onSuccess: (_, __) async {
                await _refreshProfileIfNeed();
                _closeProgressImpl();
                showInfoSnackBar(_scaffoldKey.currentContext!,
                    text: 'お気に入り解除しました');
                // お気に入りから削除
                FavoriteNotifier.getNoListenerNotifier(
                        _scaffoldKey.currentContext!)
                    .removeItem(viewData.profile!.profile.userId);
              }, onError: (_, __) {
                _closeProgressImpl();
              });
            });
          });
    } else {
      return IconButton(
          icon: Icon(
            Icons.favorite_outline,
            color: Colors.white,
          ),
          onPressed: () async {
            showAlertDialog(_scaffoldKey.currentContext!,
                title: 'お気に入りする',
                message: 'お気に入り登録しますか？',
                cancelable: true, onOk: () async {
              _showProgressImpl();
              final result = await _userRepository.postCreateFavorites(
                  TargetUserAction(viewData.profile!.profile.userId));
              RepositoryHandler.handleRepositoryResult<void>(
                  _scaffoldKey.currentContext!, result,
                  onSuccess: (_, __) async {
                await _refreshProfileIfNeed();
                _closeProgressImpl();
                showInfoSnackBar(_scaffoldKey.currentContext!,
                    text: 'お気に入り登録しました');
                // お気に入りへ追加
                FavoriteNotifier.getNoListenerNotifier(
                        _scaffoldKey.currentContext!)
                    .addItem(_profile!);
              }, onError: (_, __) {
                _closeProgressImpl();
              });
            });
          });
    }
  }

  _showProgressImpl() {
    setState(() {
      _showProgress = true;
    });
  }

  _closeProgressImpl() {
    setState(() {
      _showProgress = false;
    });
  }
}

class ProfileBodyWidget extends BaseStatefulWidget {
  final ProfileResponse profile;
  final bool isMe;

  ProfileBodyWidget({required this.profile, required this.isMe});

  @override
  State<StatefulWidget> createState() {
    return _ProfileBodyWidgetState(profile: profile, isMe: isMe);
  }
}

class _ProfileBodyWidgetState extends BaseState<ProfileBodyWidget> {
  final ProfileResponse profile;
  final bool isMe;
  final AppColors _colors = getAppColors();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final MatchingRepository _matchingRepository = MatchingRepository();
  final MessageRepository _messageRepository = MessageRepository();
  final UserRepository _userRepository = UserRepository();
  final TextEditingController _firstMessageController = TextEditingController();
  bool _showProgress = false;

  _ProfileBodyWidgetState({required this.profile, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: true,
      body: _buildBody(context),
    );
  }

  _showProgressImpl() {
    setState(() {
      _showProgress = true;
    });
  }

  _closeProgressImpl() {
    setState(() {
      _showProgress = false;
    });
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      color: _colors.primaryBg,
      child: Column(
        children: [
          Expanded(
              child: ListView(
            children: [
              SizedBox(
                height: 32,
              ),
              InkWell(
                onTap: () async {
                  // TODO
                  MyLogger.d('aaaaaaaa');
                  final result = await _userRepository
                      .getTargetProfileImage(profile.profile.userId);
                  if (result.isError()) {
                    showErrorSnackBar(context,
                        text: result.getErrorMessage() ?? '');
                    return;
                  }
                  AppEvent.sendTapToProfileImageEvent();
                  MyNavigator.pushNamed(context, Routes.simpleImage,
                      arguments: SimpleImageScreen.createScreenArgs('プロフィール画像',
                          url: ImageLoader.apiUrlToFullPath(
                              result.getData()?.profileImages.first.image)));
                },
                child: buildProfileImage(
                    width: 200,
                    height: 200,
                    sex: profile.profile.sexEnum,
                    images: profile.profileImages),
              ),
              const SizedBox(
                height: 16,
              ),
              _buildBbsPost(profile),
              const SizedBox(
                height: 16,
              ),
              _buildProfileItems(profile),
            ],
          )),
          _buildFooter(context)
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    if (isMe) {
      return Container();
    } else {
      return Column(
        children: [
          SizedBox(
            height: 16,
          ),
          _buildMessageTextField(context)
        ],
      );
    }
  }

  Widget _buildBbsPost(ProfileResponse profile) {
    if (profile.recentPost?.isNotEmpty == true &&
        profile.recentPost!.first.text != null) {
      return Center(
        child: Padding(
          padding: EdgeInsets.only(left: 16, right: 16),
          child: buildNormalText(profile.recentPost!.first.text!, maxLines: 3),
        ),
      );
    } else {
      return Container();
    }
  }

  Widget _buildProfileItems(ProfileResponse profile) {
    String age = '';
    if (profile.profile.age != null) {
      age = '${profile.profile.age}歳';
    }
    return Column(children: [
      _buildSeparator(),
      _buildProfileItem('ニックネーム', profile.profile.nickname),
      _buildSeparator(),
      _buildProfileItem('自己紹介', profile.profile.comment ?? ''),
      _buildSeparator(),
      _buildProfileItem('年齢', age),
      _buildSeparator(),
      _buildProfileItem('身長',
          profile.profile.height == null ? '' : '${profile.profile.height}cm'),
      _buildSeparator(),
      _buildProfileItem('血液型', profile.profile.blood ?? ''),
      _buildSeparator(),
      _buildProfileItem('休日', profile.profile.profHoliday ?? ''),
      _buildSeparator(),
      _buildProfileItem('仕事', profile.profile.profJob ?? ''),
      _buildSeparator(),
      _buildProfileItem('動物に例えると', profile.profile.profAnimal ?? ''),
      _buildSeparator(),
      _buildProfileItem('趣味・マイブーム', profile.profile.profHobby ?? ''),
      _buildSeparator(),
      _buildProfileItem('お仕事', profile.profile.profJob ?? ''),
      _buildSeparator(),
    ]);
  }

  Widget _buildSeparator() {
    return Container(
      color: _colors.primaryDark,
      height: 0.8,
    );
  }

  Widget _buildProfileItem(String itemName, String itemValue) {
    return Container(
      color: _colors.secondaryBg,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
              child: buildNormalText(itemName),
            ),
          ),
          Flexible(
              flex: 2,
              child: Padding(
                padding:
                    EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                child: buildNormalText(itemValue, maxLines: 10),
              ))
        ],
      ),
    );
  }

  Widget _buildMessageTextField(BuildContext context) {
    return Container(
      color: _colors.primaryLight,
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
                child: buildPlainTextField(context, _firstMessageController)),
            IconButton(
                icon: Icon(Icons.send),
                onPressed: () async {
                  // キーボード閉じる
                  final FocusScopeNode currentScope = FocusScope.of(context);
                  if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
                    FocusManager.instance.primaryFocus?.unfocus();
                  }

                  await _matchingAndNavigateMessageRoom(context,
                      scaffoldKey: _scaffoldKey,
                      targetUserId: profile.profile.userId,
                      firstMessage: _firstMessageController.text,
                      showProgress: _showProgressImpl,
                      closeProgress: _closeProgressImpl);
                }),
          ],
        ),
      ),
    );
  }
}

Future _matchingAndNavigateMessageRoom(BuildContext context,
    {required final GlobalKey<ScaffoldState> scaffoldKey,
    required int targetUserId,
    required String firstMessage,
    required Function showProgress,
    required Function closeProgress}) async {
  final MatchingRepository matchingRepository = MatchingRepository();
  final MessageRepository messageRepository = MessageRepository();

  showProgress.call();

  final RepositoryResult<MatchingResponse> matchingResult =
      await matchingRepository.postCreateRoom(MatchingRequest(targetUserId));

  closeProgress.call();

  if (firstMessage.isEmpty) {
    // マッチングのみ
    String roomId;
    RepositoryHandler.handleRepositoryResult(
        scaffoldKey.currentContext!, matchingResult,
        onSuccess: (MatchingResponse? successResult, _) {
      // マッチングリストを更新しておく
      MatchingProfileNotifier.getNoListenerNotifier(context)
          .updateList(context);

      roomId = successResult!.roomId;
      // マッチング成功を返す
      String deepLink = _createMessageRoomDeepLink(targetUserId, roomId);
      MyNavigator.pushMain(scaffoldKey.currentContext!, deepLink: deepLink);
    });
  } else {
    // マッチング後、メッセージ送信
    String roomId;
    RepositoryHandler.handleRepositoryResult(
        scaffoldKey.currentContext!, matchingResult,
        onSuccess: (MatchingResponse? successResult, _) async {
      // マッチングリストを更新しておく
      await MatchingProfileNotifier.getNoListenerNotifier(context)
          .updateList(context);

      roomId = successResult!.roomId;
      showProgress.call();
      final messageResult = await messageRepository.postSendMessage(
          SendMessage.asMessage(
              roomId: successResult.roomId, message: firstMessage));
      closeProgress.call();

      RepositoryHandler.handleRepositoryResult<void>(
          scaffoldKey.currentContext!, messageResult,
          onSuccess: (successResult, _) {
        String deepLink = _createMessageRoomDeepLink(targetUserId, roomId);
        MyNavigator.pushMain(scaffoldKey.currentContext!, deepLink: deepLink);
      });
    });
  }
}

String _createMessageRoomDeepLink(int targetUserId, String roomId) {
  String targetUserQueryValue = Uri.encodeComponent(targetUserId.toString());
  String roomIdQueryValue = Uri.encodeComponent(roomId);
  String deepLink =
      '${Routes.messageRoom}?target_user_id=$targetUserQueryValue&room_id=$roomIdQueryValue';
  MyLogger.d('deepLink = $deepLink');
  return deepLink;
}
