import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../model/basic/sex.dart';
import '../../../../model/user/profile_response.dart';
import '../../../../model/visitor/visitor.dart';
import '../../../base/base_stateful_widget.dart';
import '../../../components/datetime_util.dart';
import '../../../components/layouts.dart';
import '../../../components/profile_util.dart';
import '../../../components/texts.dart';
import '../../../helper/ad_helper.dart';
import '../../../helper/ad_unit.dart';
import '../../../my_navigator.dart';
import '../../profile/profile_screen.dart';
import '../app_bars.dart';
import '../home_change_notifier.dart';

class HistoryScreen extends BaseStatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HistoryScreenState();
  }
}

class _HistoryScreenState extends BaseState<HistoryScreen>
    with SingleTickerProviderStateMixin {
  _HistoryScreenState() : super(null);

  late TabController _tabController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  //BannerAdWidget _ad = BannerAdWidget(AdUnits.historyScreenBannerAdUnitId);

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

  Widget _buildMainWidget() {
    return Scaffold(
      key: _scaffoldKey,
      appBar: buildHomeAppBar(
        context,
        '履歴',
        tabBar: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          tabs: [
            Tab(text: 'もらったいいね'),
            Tab(text: 'あしあと'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Consumer<IncommingFavoriteNotifier>(
            builder: (_, IncommingFavoriteNotifier notifier, __) {
              return _buildGridOrEmpty(
                  notifier.favoriteResponseList, 2, 'もらったいいねはありません', () async {
                await IncommingFavoriteNotifier.getNoListenerNotifier(context)
                    .updateList(context);
              });
            },
          ),
          Consumer<VisitorNotifier>(
            builder: (_, VisitorNotifier notifier, __) {
              return _buildGridOrEmptyVisitor(
                  notifier.visitorResponseList, 3, 'あしあとはありません', () async {
                await VisitorNotifier.getNoListenerNotifier(context)
                    .updateList(context);
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildGridOrEmpty(List<ProfileResponse> profiles, int stateKey,
      String emptyMessage, Function onRefresh) {
    Widget w;
    if (profiles.isEmpty) {
      w = Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: buildNormalText(emptyMessage),
            ),
            IconButton(
                icon: Icon(Icons.refresh),
                onPressed: () {
                  onRefresh();
                })
          ],
        ),
      );
    } else {
      w = _buildGridMembers(profiles, stateKey);
    }

    return RefreshIndicator(
      onRefresh: () async {
        onRefresh();
      },
      child: w,
    );
  }

  Widget _buildGridOrEmptyVisitor(List<Visitor> visitors, int stateKey,
      String emptyMessage, Function onRefresh) {
    if (visitors.isEmpty) {
      return Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: buildNormalText(emptyMessage),
            ),
            IconButton(
                icon: Icon(Icons.refresh),
                onPressed: () {
                  onRefresh();
                })
          ],
        ),
      );
    } else {
      return _buildVisitors(visitors, stateKey, onRefresh);
    }
  }

  Widget _buildGridMembers(List<ProfileResponse> profiles, int stateKey) {
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) {
        if (scrollNotification.metrics.pixels >
            scrollNotification.metrics.maxScrollExtent * 0.7) {
          FavoriteNotifier.getNoListenerNotifier(context).getListMore(context);
        }
        return false;
      },
      child: Column(
        children: [
          Expanded(
              child: ListView.builder(
            key: PageStorageKey(stateKey),
            itemCount: profiles.length,
            itemBuilder: (context, index) {
              return _buildListOneItem(profiles[index]);
            },
          )),
          //_ad.buildBannerAdOrEmptyContainer()
        ],
      ),
    );
  }

  Widget _buildVisitors(
      List<Visitor> visitors, int stateKey, Function onRefresh) {
    List<Widget> listView = [];
    visitors.forEach((v) {
      listView.add(Padding(
        padding: EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 4),
        child: Text(v.visitDate),
      ));
      v.profiles.forEach((p) {
        listView.add(_buildListOneItem(p));
      });
    });
    return RefreshIndicator(
      onRefresh: () async {
        onRefresh();
      },
      child: NotificationListener<ScrollNotification>(
        onNotification: (scrollNotification) {
          if (scrollNotification.metrics.pixels >
              scrollNotification.metrics.maxScrollExtent * 0.7) {
            VisitorNotifier.getNoListenerNotifier(context).getListMore(context);
          }
          return false;
        },
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: listView,
              ),
            ),
            //_ad.buildBannerAdOrEmptyContainer()
          ],
        ),
      ),
    );
  }

  Widget _buildListOneItem(ProfileResponse profile) {
    String namePrefix = '';
    if (profile.profile.sexEnum == Sex.Male) namePrefix = '♂';
    if (profile.profile.sexEnum == Sex.Female) namePrefix = '♀';

    String ageText = '';
    if (profile.profile.age != null) {
      ageText += '${profile.profile.age}歳';
    }

    DateTime? visitedDateTime = DateTimeConverter.parse(profile.visitedAt);
    return buildMemberCard(
        onTap: () async {
          context.appPush(AppRoutes.profile,
              extra: ProfileScreenArgs(profile));
        },
        image: buildProfileImage(
            width: 64,
            height: 64,
            sex: profile.profile.sexEnum,
            images: profile.profileImages),
        textTop: '$namePrefix ${profile.profile.nickname}',
        textBottom: ageText,
        datetime: visitedDateTime == null
            ? ''
            : DateTimeConverter.dateTimeToHHmm(visitedDateTime));
  }
}
