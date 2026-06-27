import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/colors.dart';
import '../../../model/user/profile_response.dart';
import '../../../repository/user_repository.dart';
import '../../base/base_stateful_widget.dart';
import '../../components/layouts.dart';
import '../../components/profile_util.dart';
import '../../components/texts.dart';
import '../../components/widget_circular_progress.dart';
import '../../my_navigator.dart';
import '../home/app_bars.dart';
import '../home/home_change_notifier.dart';
import '../profile/profile_screen.dart';

class BlockListScreen extends BaseStatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _BlockListState();
  }
}

class _BlockListState extends BaseState<BlockListScreen> {
  _BlockListState() : super(null);

  final UserRepository _userRepository = UserRepository();
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
          'ブロックリスト',
        ),
        body: Container(
          color: getAppColors().primaryBg,
          child: _buildList(),
        ));
  }

  Widget _buildList() {
    return Consumer<BlockNotifier>(
      builder: (_, BlockNotifier notifier, __) {
        if (notifier.isLoading && notifier.blockResponseList.isEmpty)
          return Center(
            child: WidgetCircularProgress(),
          );

        if (notifier.doneInitialLoad && notifier.blockResponseList.isEmpty) {
          return _buildEmpty();
        }

        Widget w = RefreshIndicator(
          onRefresh: () async {
            await BlockNotifier.getNoListenerNotifier(context)
                .updateList(context);
          },
          child: NotificationListener<ScrollNotification>(
            onNotification: (scrollNotification) {
              if (scrollNotification.metrics.pixels >
                  scrollNotification.metrics.maxScrollExtent * 0.7) {
                BlockNotifier.getNoListenerNotifier(context)
                    .getListMore(context);
              }
              return false;
            },
            child: ListView.builder(
              key: PageStorageKey(1),
              itemCount: notifier.blockResponseList.length,
              itemBuilder: (context, index) {
                return _buildItem(notifier.blockResponseList[index]);
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
            child: buildNormalText('ブロックしたユーザーはいません'),
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
