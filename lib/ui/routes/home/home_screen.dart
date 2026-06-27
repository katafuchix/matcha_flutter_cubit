import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../../../core/app_info.dart';
import '../../../core/colors.dart';
import '../../../core/event_tracking.dart';
import '../../../core/my_logger.dart';
import '../../../core/my_platform.dart';
import '../../../core/tap_joy.dart';
import '../../../core/words.dart';
import '../../../model/app_config/app_config.dart';
import '../../../model/device_info/device_info.dart';
import '../../../model/device_info/device_token.dart';
import '../../../model/login_bonus/login_bonus.dart';
import '../../../model/notification/notifications.dart';
import '../../../model/repository/repository_result.dart';
import '../../../model/user/profile_response.dart';
import '../../../repository/config_repository.dart';
import '../../../repository/notification_repository.dart';
import '../../../repository/user_repository.dart';
import '../../../ui/components/widget_circular_progress.dart';
import '../../app.dart';
import '../../base/base_stateful_widget.dart';
import '../../components/containers.dart';
import '../../components/dialogs.dart';
import '../../components/texts.dart';
import '../../helper/repository_handler.dart';
import '../../my_navigator.dart';
import '../message_room/message_room_screen.dart';
import 'history/history_screen.dart';
import 'home_change_notifier.dart';
import 'message_list/message_list_screen.dart';
import 'search/search_screen.dart';
import 'ticket/ticket_screen.dart';

class HomeScreen extends BaseStatefulWidget {
  final String? deepLink;

  HomeScreen({this.deepLink}) : super();

  @override
  _HomeScreenState createState() {
    return _HomeScreenState(deepLink);
  }
}

class _HomeScreenState extends BaseState<HomeScreen> {
  final String? _deepLink;
  int _selectedIndex = 1;
  DateTime? _lastTimeSendDeviceInfo;

  final UserRepository _userRepository = UserRepository();
  final NotificationRepository _notificationRepository =
      NotificationRepository();
  final ConfigRepository _configRepository = ConfigRepository();

  final List<Notifications> _unreadImportantNotifications = [];

  bool _doneInitialLoad = false;

  List<Widget> _widgetOptions = <Widget>[
    MessageListScreen(),
    SearchScreen(),
    HistoryScreen(),
    MyPlatform.isMobileApp ? TicketScreen() : /* TODO */ Container(),
  ];

  _HomeScreenState(this._deepLink);

  Future _initialLoad() async {
    await MyProfileNotifier.getNoListenerNotifier(context).update(context);

    final String? userIdStr = MyProfileNotifier.getNoListenerNotifier(context)
        .myProfile
        ?.profile
        .userId
        .toString();
    // Tapjoy
    if (userIdStr != null) {
      await TapJoys.setUserId(userIdStr);
    }
    // プリロード
    await TapJoys.requestContents();

    await SearchingNotifier.getNoListenerNotifier(context).updateList(context);
    await BbsNotifier.getNoListenerNotifier(context).updateList(context);
    await MatchingProfileNotifier.getNoListenerNotifier(context)
        .updateList(context);
    await NotificationNotifier.getNoListenerNotifier(context)
        .updateList(context);
    await FavoriteNotifier.getNoListenerNotifier(context).updateList(context);
    await IncommingFavoriteNotifier.getNoListenerNotifier(context)
        .updateList(context);
    await VisitorNotifier.getNoListenerNotifier(context).updateList(context);
    await BlockNotifier.getNoListenerNotifier(context).updateList(context);

    // 未読のお知らせ
    _unreadImportantNotifications.clear();
    final unreadNotifications =
        (await _notificationRepository.getUnreadNotifications(1)).getData();
    if (unreadNotifications?.isNotEmpty == true) {
      _unreadImportantNotifications.addAll(unreadNotifications!
          .where((element) => element.noticeType == NoticeType.EMERGENCY)
          .toList());
    }

    setState(() {
      _doneInitialLoad = true;
    });
  }

  @override
  onBuildWidget() {
    super.onBuildWidget();
    MyLogger.d('onBuildWidget()');
    MyLogger.d(
        'MediaQuery.of(context).size.width} : ${MediaQuery.of(context).size.width}');
    _proceedMiscIfNeed();
    _handleDeepLink(_deepLink);
  }

  @override
  void onResume() {
    super.onResume();
    _proceedMiscIfNeed();
  }

  // 重要なお知らモーダル・ログインボーナスなど、ホーム画面でモーダルを表示する処理をここに集約する
  // デバイス情報をサーバーに送信するなどもここでやる
  Future _proceedMiscIfNeed() async {
    // メンテナンス中 / 強制アップデートモードならUIロックする
    if (await _forceUpdateOrMaintenanceIfNeed()) return;

    final now = DateTime.now();
    // 初回、及び最後に送信してから1時間経過していたらデバイス情報を送信
    if ((_lastTimeSendDeviceInfo?.difference(now)?.inHours ?? 1) > 0) {
      MyLogger.d('1時間経過していたのでリフレッシュ $_lastTimeSendDeviceInfo $now');
      // 全体のリフレッシュ
      await _initialLoad();
      await _sendDeviceInfoAndShowLoginBonus();
    }

    // 日付が変わっていたら
    else if (_lastTimeSendDeviceInfo != null) {
      if (_lastTimeSendDeviceInfo?.year != now.year ||
          _lastTimeSendDeviceInfo?.month != now.month ||
          _lastTimeSendDeviceInfo?.day != now.day) {
        MyLogger.d('日付が変わっていたのでリフレッシュ');
        // 全体のリフレッシュ
        await _initialLoad();
        await _sendDeviceInfoAndShowLoginBonus();
      }
    } else
      return;

    // 重要なお知らせモーダル
    if (_unreadImportantNotifications.isNotEmpty) {
      await showAlertDialog(context,
          title: 'お知らせ', message: '重要なお知らせがあります。', cancelable: false, onOk: () {
        (_widgetOptions[0] as MessageListScreen).updateTabIndex(1);
        setState(() {
          _selectedIndex = 0;
        });
      }, okLabel: '確認する');
    }
  }

  Future _sendDeviceInfoAndShowLoginBonus() async {
    if (MyPlatform.isWeb) return;

    _lastTimeSendDeviceInfo = DateTime.now();

    // エラーハンドングしない
    await _userRepository.postVersionInfo(DeviceInfo(
        AppInfo.platformString, AppInfo.deviceName, AppInfo.appVersion));

    String? token = await FirebaseMessaging.instance.getToken();
    MyLogger.d('device_token = $token');

    if (token == null) return;

    final RepositoryResult<LogInBonus> result = await _userRepository
        .postVersionToken(DeviceToken.forMyPlatform(token));
    final successResult = RepositoryHandler.getSuccessOrNull(result);
    if (successResult != null && successResult.dailyLogin.giveBonus == true) {
      return showAlertDialog(context,
          title: 'ログインボーナス',
          message: '${successResult.dailyLogin.point}ゲット！',
          cancelable: false);
    }
  }

  Future _handleDeepLink(String? deepLink) async {
    if (deepLink == null) return;

    final Uri uri = Uri.parse(deepLink);

    if (uri.path == Routes.messageRoom) {
      try {
        if (uri.queryParameters['target_user_id'] == null ||
            uri.queryParameters['room_id'] == null) return;

        int targetUserId = int.parse(uri.queryParameters['target_user_id']!);
        String roomId = uri.queryParameters['room_id']!;

        ProfileResponse? myProfile;
        ProfileResponse? targetProfile;
        final meResult = await _userRepository.getMe();
        final targetResult =
            await _userRepository.getTargetProfile(targetUserId);
        List<OnResultHandler> resultList = [
          OnResultHandler(meResult, onSuccess: (profile) {
            myProfile = profile;
          }),
          OnResultHandler(targetResult, onSuccess: (profile) {
            targetProfile = profile;
          }),
        ];
        RepositoryHandler.handleMultipleRepositoryResult(context, resultList);

        // タブ移動
        setState(() {
          _selectedIndex = 0;
        });

        if (myProfile != null && targetProfile != null) {
          MyNavigator.pushNamed(context, Routes.messageRoom,
              arguments: MessageRoomScreen.createScreenArgs(
                  roomId: roomId,
                  myProfile: myProfile!,
                  targetProfile: targetProfile!));
        }
      } catch (e) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_doneInitialLoad)
      return Container(
        color: getAppColors().secondaryBg,
        child: Center(
          child: WidgetCircularProgress(),
        ),
      );

    return Containers.createScreenContainer(context, _buildMain());
  }

  Widget _buildMain() {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_rounded),
            label: 'メッセージ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'さがす',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: '履歴',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.credit_card),
            label: 'チケット',
          ),
        ],
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        {
          AppEvent.sendHomeTabEvent('message_list');
          break;
        }
      case 1:
        {
          AppEvent.sendHomeTabEvent('history');
          AppEvent.sendViewHistoryEvent();
          break;
        }
      case 2:
        {
          AppEvent.sendHomeTabEvent('search');
          break;
        }
      case 3:
        {
          AppEvent.sendHomeTabEvent('bbs');
          break;
        }
      case 4:
        {
          AppEvent.sendHomeTabEvent('ticket');
          break;
        }
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<bool> _forceUpdateOrMaintenanceIfNeed() async {
    final appConfigResult = await _configRepository.getAppConfig();
    if (appConfigResult.isError()) {
      _showCannotCloseDialog(unexpectedErrorMessage);
      return true;
    }

    final AppConfig? config = appConfigResult.getData();

    if (config?.isMaintenance() == true) {
      _showCannotCloseDialog(config!.getMaintenanceMessage());
      return true;
    }

    if (config?.needForceUpdate() == true) {
      String errorMessage =
          'アプリのアップデートをお願いします。\nv${config!.getRequiredVersion()}以上である必要があります。\n\n現在のバージョン : ${AppInfo.appVersion}';
      _showCannotCloseDialog(errorMessage);
      return true;
    }

    return false;
  }

  Future _showCannotCloseDialog(String message) async {
    return showCustomDialog(
        context: context,
        builder: (BuildContext context, StateSetter setStateForDialog) {
          return Padding(
            padding: EdgeInsets.all(16),
            child: buildNormalText(message),
          );
        },
        barrierDismissible: false);
  }
}
