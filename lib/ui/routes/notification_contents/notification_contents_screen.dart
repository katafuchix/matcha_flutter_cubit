import 'package:flutter/material.dart';

import '../../../model/notification/notification_contents.dart';
import '../../../model/notification/notifications.dart';
import '../../../repository/notification_repository.dart';
import '../../base/base_stateful_widget.dart';
import '../../components/texts.dart';
import '../../components/widget_circular_progress.dart';
import '../../helper/repository_handler.dart';
import '../../my_navigator.dart';
import '../home/app_bars.dart';

class _NotificationContentsScreenArgs {
  final int notificationId;
  final NotificationType notificationType;
  final String title;
  _NotificationContentsScreenArgs(
      this.notificationId, this.notificationType, this.title);
}

class NotificationContentsScreen extends BaseStatefulWidget {
  static final _keyArgs = 'key_profile_args';

  NotificationContentsScreen({required ScreenArgs args}) : super(args: args);

  static ScreenArgs createScreenArgs(
      int notificationId, NotificationType notificationType, String title) {
    ScreenArgs args = ScreenArgs()
      ..put(
        _keyArgs,
        _NotificationContentsScreenArgs(
            notificationId, notificationType, title),
      );
    return args;
  }

  @override
  State<StatefulWidget> createState() {
    final _NotificationContentsScreenArgs screenArgs = getArgs();
    return _NotificationContentsState(screenArgs.notificationId,
        screenArgs.notificationType, screenArgs.title);
  }

  @override
  String getArgsKey() {
    return _keyArgs;
  }
}

class _NotificationContentsState extends BaseState<NotificationContentsScreen> {
  final int notificationId;
  final NotificationType notificationType;
  final String title;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final NotificationRepository _notificationRepository =
      NotificationRepository();
  String? _body;

  _NotificationContentsState(
      this.notificationId, this.notificationType, this.title)
      : super(null);

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future _load() async {
    final result = await _notificationRepository.postNotificationContents(
        NotificationContentsRequest(notificationId, notificationType));
    RepositoryHandler.handleRepositoryResult(context, result,
        onSuccess: (NotificationContents? notification, _) {
      _body = notification?.body;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return _buildMainWidget();
  }

  Widget _buildMainWidget() {
    return Scaffold(
        key: _scaffoldKey,
        appBar: buildNormalAppBar(context, 'お知らせ'),
        body: _buildMainBody());
  }

  Widget _buildMainBody() {
    if (_body == null) {
      return Center(
        child: WidgetCircularProgress(),
      );
    }

    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 16,
          ),
          buildNormalText(title),
          SizedBox(
            height: 16,
          ),
          Expanded(
              child: SingleChildScrollView(
            child: buildSmallerText(_body ?? ''),
          )),
          SizedBox(
            height: 16,
          ),
        ],
      ),
    );
  }
}
