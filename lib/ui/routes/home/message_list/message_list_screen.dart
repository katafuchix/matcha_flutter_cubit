import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/colors.dart';
import '../../../../core/my_logger.dart';
import '../../../../model/matching/matched_response.dart';
import '../../../../model/notification/notifications.dart';
import '../../../../model/user/profile_response.dart';
import '../../../../repository/user_repository.dart';
import '../../../base/base_stateful_widget.dart';
import '../../../components/datetime_util.dart';
import '../../../components/layouts.dart';
import '../../../components/profile_util.dart';
import '../../../components/texts.dart';
import '../../../helper/ad_helper.dart';
import '../../../helper/ad_unit.dart';
import '../../../helper/repository_handler.dart';
import '../../../my_navigator.dart';
import '../../message_room/message_room_screen.dart';
import '../../notification_contents/notification_contents_screen.dart';
import '../../profile/profile_screen.dart';
import '../app_bars.dart';
import '../home_change_notifier.dart';

class MessageListScreen extends BaseStatefulWidget {
  final state = _MessageListScreenState();

  @override
  State<StatefulWidget> createState() {
    return state;
  }

  updateTabIndex(int index) {
    state.updateTabIndex(index);
  }
}

class _MessageListScreenState extends BaseState<MessageListScreen>
    with SingleTickerProviderStateMixin {
  _MessageListScreenState() : super(null);

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final UserRepository _userRepository = UserRepository();
  late TabController _tabController;
  //BannerAdWidget _ad = BannerAdWidget(AdUnits.messageScreenBannerAdUnitId);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    //_ad.onDispose();
    super.dispose();
  }

  @mustCallSuper
  void onBuildWidget() {
    super.onBuildWidget();
    /*_ad.onInitState(context, () {
      setState(() {});
    });*/
  }

  @override
  Widget build(BuildContext context) {
    return _buildMainWidget();
  }

  updateTabIndex(int index) {
    setState(() {
      _tabController.index = index;
    });
  }

  Widget _buildMainWidget() {
    return Scaffold(
      key: _scaffoldKey,
      appBar: buildHomeAppBar(
        context,
        'メッセージ',
        tabBar: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          tabs: [
            Tab(text: 'チャット'),
            Tab(text: 'お知らせ'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Consumer<MatchingProfileNotifier>(
            builder: (_, MatchingProfileNotifier notifier, __) {
              return _buildListMembers(notifier.matchedResponseList, 2,
                  () async {
                await MatchingProfileNotifier.getNoListenerNotifier(context)
                    .updateList(context);
              });
            },
          ),
          Consumer<NotificationNotifier>(
            builder: (_, NotificationNotifier notifier, __) {
              MyLogger.d('Consumer<MatchingProfileNotifier>()');
              return _buildListNotifications(notifier.notificationList, 1,
                  () async {
                await NotificationNotifier.getNoListenerNotifier(context)
                    .updateList(context);
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildListNotifications(final List<Notifications> notificationList,
      int stateKey, Function() onRefresh) {
    if (notificationList.isEmpty) {
      return Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: buildNormalText('お知らせはありません'),
            ),
            IconButton(icon: Icon(Icons.refresh), onPressed: onRefresh)
          ],
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: () async {
        onRefresh();
      },
      child: NotificationListener<ScrollNotification>(
        onNotification: (scrollNotification) {
          if (scrollNotification.metrics.pixels >
              scrollNotification.metrics.maxScrollExtent * 0.7) {
            NotificationNotifier.getNoListenerNotifier(context)
                .getListMore(context);
          }
          return false;
        },
        child: ListView.builder(
          key: PageStorageKey(stateKey),
          itemCount: notificationList.length,
          itemBuilder: (context, index) {
            return _buildNotificationOneItem(notificationList[index]);
          },
        ),
      ),
    );
  }

  Widget _buildNotificationOneItem(final Notifications notifications) {
    DateTime? createdAtDateTime =
        DateTimeConverter.parse(notifications.createdAt);
    AppColors colors = getAppColors();
    Color bgColor;
    if (notifications.read == true) {
      bgColor = colors.secondaryBg;
    } else {
      bgColor = colors.primaryLight;
    }
    return Card(
      color: bgColor,
      elevation: 8,
      margin: EdgeInsets.only(left: 8, top: 8, bottom: 8, right: 8),
      child: InkWell(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(createdAtDateTime == null
                  ? ''
                  : DateTimeConverter.dateTimeToYYYYMMddHHmm(
                      createdAtDateTime)),
              SizedBox(
                height: 8,
              ),
              Text(notifications.title),
            ],
          ),
        ),
        onTap: () async {
          await context.appPush(AppRoutes.notificationContents,
              extra: NotificationContentsScreenArgs(
                  notifications.notificationId,
                  notifications.notificationType,
                  notifications.title));
          // 通知を開いた時点で既読にしてしまう
          notifications.read = true;
        },
      ),
    );
  }

  Widget _buildListMembers(
      List<MatchedResponse> matchedList, int stateKey, Function onRefresh) {
    if (matchedList.isEmpty) {
      return Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: buildNormalText('メッセージをやり取りしている方はいません'),
            ),
            IconButton(
                icon: Icon(Icons.refresh),
                onPressed: () {
                  onRefresh();
                })
          ],
        ),
      );
      return Center(
        child: buildNormalText('メッセージをやり取りしている方はいません'),
      );
    }
    return RefreshIndicator(
      onRefresh: () async {
        onRefresh();
      },
      child: NotificationListener<ScrollNotification>(
          onNotification: (scrollNotification) {
            if (scrollNotification.metrics.pixels >
                scrollNotification.metrics.maxScrollExtent * 0.7) {
              MatchingProfileNotifier.getNoListenerNotifier(context)
                  .getListMore(context);
            }
            return false;
          },
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  key: PageStorageKey(stateKey),
                  itemCount: matchedList.length,
                  itemBuilder: (context, index) {
                    return _buildListOneItem(matchedList[index]);
                  },
                ),
              ),
              //_ad.buildBannerAdOrEmptyContainer()
            ],
          )),
    );
  }

  Widget _buildListOneItem(MatchedResponse member) {
    String age = '';
    if (member.profile.age != null) {
      age = '${member.profile.age}歳';
    }
    return buildMemberCard(
        onTap: () async {
          final meResult = await _userRepository.getMe();
          final ProfileResponse targetProfile = ProfileResponse(
              null, member.profile, /*TODO*/ null, member.profileImages, null);
          RepositoryHandler.handleRepositoryResult(context, meResult,
              onSuccess: (ProfileResponse? me, __) {
            context.appPush(AppRoutes.messageRoom,
                extra: MessageRoomScreenArgs(
                    roomId: member.match.roomId,
                    myProfile: me!,
                    targetProfile: targetProfile));
          });
        },
        image: InkWell(
          onTap: () {
            _scaffoldKey.currentContext!.appPush(AppRoutes.profile,
                extra: ProfileScreenArgs(ProfileResponse(
                    null, member.profile, null, member.profileImages, null)));
          },
          child: buildProfileImage(
              width: 64,
              height: 64,
              sex: member.profile.sexEnum,
              images: member.profileImages),
        ),
        textTop: '${member.profile.nickname} $age',
        textBottom: member.match.message ?? '');
  }
}
