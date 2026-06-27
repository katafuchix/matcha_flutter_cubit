import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';

import '../../../../core/app_info.dart';
import '../../../../core/colors.dart';
import '../../../../model/search_condition/search_condition.dart';
import '../../../../model/user/profile_response.dart';
import '../../../base/base_stateful_widget.dart';
import '../../../components/layouts.dart';
import '../../../components/profile_util.dart';
import '../../../components/texts.dart';
import '../../../components/widget_circular_progress.dart';
import '../../../helper/ad_helper.dart';
import '../../../helper/ad_unit.dart';
import '../../../my_navigator.dart';
import '../../profile/profile_screen.dart';
import '../../search_condition/search_condition_screen.dart';
import '../app_bars.dart';
import '../home_change_notifier.dart';

class SearchScreen extends BaseStatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SearchScreenState();
  }
}

class SearchScreenViewData {
  final List<ProfileResponse> members;

  SearchScreenViewData(this.members);
}

enum LayoutType { GRID, LIST }

class _SearchScreenState extends BaseState<SearchScreen> {
  _SearchScreenState() : super(null);

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final AppColors _colors = getAppColors();

  //BannerAdWidget _ad = BannerAdWidget(AdUnits.searchScreenBannerAdUnitId);

  LayoutType _layoutType = LayoutType.GRID;
  // この値が変更されると、リストビューのスクロール位置がリセットされる
  // 再検索時にインクリメントする方針
  int _pageStorageKeyForGrid = 0;
  int _pageStorageKeyForList = 1000;

  @override
  void dispose() {
    super.dispose();
    //_ad.onDispose();
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
      appBar: buildHomeAppBar(context, 'さがす'),
      body: _buildMainList(),
      floatingActionButton: Container(
          margin: EdgeInsets.only(bottom: 0/*_ad.adHeight()*/), child: _speedDial()),
    );
  }

  SpeedDial _speedDial() {
    return SpeedDial(
      /// both default to 16
      icon: Icons.add,
      activeIcon: Icons.remove,
      buttonSize: const Size(56.0, 56.0),
      visible: true,
      closeManually: false,
      renderOverlay: false,
      curve: Curves.bounceIn,
      overlayColor: Colors.black,
      overlayOpacity: 0.5,
      onOpen: () {},
      onClose: () {},
      tooltip: 'Speed Dial',
      heroTag: 'speed-dial-hero-tag',
      backgroundColor: _colors.accent,
      foregroundColor: Colors.white,
      elevation: 8.0,
      shape: CircleBorder(),
      // orientation: SpeedDialOrientation.Up,
      // childMarginBottom: 2,
      // childMarginTop: 2,
      children: [
        SpeedDialChild(
          child: Icon(Icons.menu),
          backgroundColor: _colors.accent,
          foregroundColor: Colors.white,
          label: 'リスト表示',
          labelStyle: createAppTextStyle(),
          labelBackgroundColor: Colors.white,
          onTap: () {
            setState(() {
              _layoutType = LayoutType.LIST;
            });
          },
        ),
        SpeedDialChild(
          child: Icon(Icons.face_outlined),
          backgroundColor: _colors.accent,
          foregroundColor: Colors.white,
          label: '写真表示',
          labelStyle: createAppTextStyle(),
          labelBackgroundColor: Colors.white,
          onTap: () {
            setState(() {
              _layoutType = LayoutType.GRID;
            });
          },
        ),
        SpeedDialChild(
          child: Icon(Icons.search),
          backgroundColor: _colors.accent,
          foregroundColor: Colors.white,
          label: '絞り込み',
          labelStyle: createAppTextStyle(),
          labelBackgroundColor: Colors.white,
          onTap: () async {
            SearchingNotifier notifier =
                SearchingNotifier.getNoListenerNotifier(context);
            final result = await context.appPush(AppRoutes.searchCondition,
                extra: SearchConditionScreenArgs(
                    false, notifier.searchCondition));
            if (result is SearchCondition) {
              notifier.updateSearchCondition(result);
              await notifier.updateList(context);
              _pageStorageKeyForGrid++;
              _pageStorageKeyForList++;
              setState(() {});
            }
          },
        ),
      ],
    );
  }

  Widget _buildMainList() {
    return Consumer<SearchingNotifier>(
      builder: (_, SearchingNotifier notifier, __) {
        if (notifier.isLoading && notifier.profileResponseList.isEmpty)
          return Center(
            child: WidgetCircularProgress(),
          );

        if (notifier.doneInitialLoad && notifier.profileResponseList.isEmpty) {
          return Center(
            child: buildNormalText('検索結果はありません'),
          );
        }

        Widget w;
        if (_layoutType == LayoutType.GRID) {
          w = _buildGridMembers(notifier.profileResponseList);
        } else {
          w = _buildListMembers(notifier.profileResponseList);
        }
        return Container(
          color: _colors.primaryBg,
          child: Column(
            children: [Expanded(child: w), /*_ad.buildBannerAdOrEmptyContainer()*/],
          ),
        );
      },
    );
  }

  Widget _buildListMembers(List<ProfileResponse> profileResponseList) {
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) {
        if (scrollNotification.metrics.pixels >
            scrollNotification.metrics.maxScrollExtent * 0.5) {
          SearchingNotifier.getNoListenerNotifier(context).getListMore(context);
        }
        return false;
      },
      child: ListView.builder(
        key: PageStorageKey(_pageStorageKeyForList),
        itemCount: profileResponseList.length,
        itemBuilder: (context, index) {
          return _buildListOneItem(profileResponseList[index]);
        },
      ),
    );
  }

  Widget _buildGridMembers(List<ProfileResponse> profileResponseList) {
    final num = 3;
    final double w = AppInfo.getAppWidth(context) / num - 4 * num;
    final h = w + 12 * 2 * 2.0; // text 1つ 12 2.0はバッファ

    return NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) {
        if (scrollNotification.metrics.pixels >
            scrollNotification.metrics.maxScrollExtent * 0.5) {
          SearchingNotifier.getNoListenerNotifier(context).getListMore(context);
        }
        return false;
      },
      child: GridView.builder(
        key: PageStorageKey(_pageStorageKeyForGrid),
        itemCount: profileResponseList.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: num, childAspectRatio: w / h),
        itemBuilder: (context, index) {
          return _buildGridOneItem(profileResponseList[index]);
        },
      ),
    );
  }

  Widget _buildGridOneItem(ProfileResponse profile) {
    final num = 3;
    final double w = AppInfo.getAppWidth(context) / num - 4 * num;

    String age = '${profile.profile.age}歳';
    return Card(
      child: InkWell(
        onTap: () async {
          _scaffoldKey.currentContext!.appPush(AppRoutes.profile,
              extra: ProfileScreenArgs(profile));
        },
        child: Padding(
          padding: EdgeInsets.all(4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: buildProfileImage(
                    width: w,
                    height: w,
                    sex: profile.profile.sexEnum,
                    images: profile.profileImages),
              ),
              buildNormalText(profile.profile.nickname, maxLines: 1),
              buildSmallerText(age),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListOneItem(ProfileResponse profile) {
    final w = 64.0;
    String age = '';
    if (profile.profile.age != null) {
      age = '${profile.profile.age}歳';
    }
    return buildMemberCard(
        onTap: () async {
          _scaffoldKey.currentContext!.appPush(AppRoutes.profile,
              extra: ProfileScreenArgs(profile));
        },
        image: buildProfileImage(
            width: w,
            height: w,
            sex: profile.profile.sexEnum,
            images: profile.profileImages),
        textTop: profile.profile.nickname,
        textBottom: age);
  }
}
