import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/colors.dart';
import '../../../model/user/profile_response.dart';
import '../../base/base_stateful_widget.dart';
import '../../components/layouts.dart';
import '../../components/profile_util.dart';
import '../../components/texts.dart';
import '../../components/widget_circular_progress.dart';
import '../../my_navigator.dart';
import '../home/app_bars.dart';
import '../home/home_change_notifier.dart';
import '../profile/profile_screen.dart';

class FavoriteListScreen extends BaseStatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FavoriteListState();
  }
}

class _FavoriteListState extends BaseState<FavoriteListScreen> {
  _FavoriteListState() : super();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: buildNormalAppBar(
          context,
          'お気に入り',
        ),
        body: Container(
          color: getAppColors().primaryBg,
          child: _buildList(),
        ));
  }

  Widget _buildList() {
    return Consumer<FavoriteNotifier>(
      builder: (_, FavoriteNotifier notifier, __) {
        if (notifier.isLoading && notifier.favoriteResponseList.isEmpty)
          return Center(
            child: WidgetCircularProgress(),
          );

        if (notifier.doneInitialLoad && notifier.favoriteResponseList.isEmpty) {
          return _buildEmpty();
        }

        Widget w = RefreshIndicator(
          onRefresh: () async {
            await FavoriteNotifier.getNoListenerNotifier(context)
                .updateList(context);
          },
          child: NotificationListener<ScrollNotification>(
            onNotification: (scrollNotification) {
              if (scrollNotification.metrics.pixels >
                  scrollNotification.metrics.maxScrollExtent * 0.7) {
                FavoriteNotifier.getNoListenerNotifier(context)
                    .getListMore(context);
              }
              return false;
            },
            child: ListView.builder(
              key: PageStorageKey(1),
              itemCount: notifier.favoriteResponseList.length,
              itemBuilder: (context, index) {
                return _buildItem(notifier.favoriteResponseList[index]);
              },
            ),
          ),
        );
        return Container(
          color: getAppColors().primaryBg,
          child: w,
        );
      },
    );
  }

  Widget _buildItem(ProfileResponse profile) {
    String ageText = '';
    if (profile.profile.age != null) {
      ageText += '${profile.profile.age}歳';
    }
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
        textTop: profile.profile.nickname,
        textBottom: ageText);
  }

  Widget _buildLoading() {
    return Center(
      child: WidgetCircularProgress(),
    );
  }

  Widget _buildEmpty() {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: buildNormalText('お気に入りしているユーザーはいません'),
          ),
          IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () async {
                await BlockNotifier.getNoListenerNotifier(context)
                    .updateList(context);
              })
        ],
      ),
    );
  }
}
