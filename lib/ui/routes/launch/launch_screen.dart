import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/app_info.dart';
import '../../../core/words.dart';
import '../../../model/app_config/app_config.dart';
import '../../../repository/config_repository.dart';
import '../../../repository/master_repository.dart';
import '../../../repository/storage/shared_preferences/shared_preferences_keys.dart';
import '../../../repository/storage/shared_preferences/shared_preferences_manager.dart';
import '../../base/base_stateful_widget.dart';
import '../../components/dialogs.dart';
import '../../components/texts.dart';
import '../../components/widget_circular_progress.dart';
import '../../my_navigator.dart';
import 'package:go_router/go_router.dart';

class LaunchScreen extends BaseStatefulWidget {
  @override
  _LaunchScreenState createState() {
    return _LaunchScreenState();
  }
}

class _LaunchScreenState extends BaseState<LaunchScreen>
    with SingleTickerProviderStateMixin {
  _LaunchScreenState() : super(null);

  final MasterRepository _masterRepository = MasterRepository();
  final ConfigRepository _configRepository = ConfigRepository();
  bool _showProgress = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
  }

  navigate() async {
    SharedPreferencesManager manager =
        await SharedPreferencesManager.getInstance();
    if (manager.getString(SharedPreferencesKeys.ACCESS_TOKEN)?.isNotEmpty ==
        true) {
      context.go(AppRoutes.home);
    } else {
      context.go(AppRoutes.signIn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/appicon.png',
            width: 100,
            height: 100,
          ),
          SizedBox(
            height: 8,
          ),
          Container(
            width: 24,
            height: 24,
            child: _showProgress ? WidgetCircularProgress() : Container(),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: _errorMessage.isNotEmpty
                ? buildNormalText(_errorMessage)
                : Container(),
          )
        ],
      ),
    ));
  }

  @override
  void onBuildWidget() {
    super.onBuildWidget();
    _load();
  }

  Future _load() async {
    final appConfigResult = await _configRepository.getAppConfig();
    if (appConfigResult.isError()) {
      showErrorDialog(context, unexpectedErrorMessage);
      setState(() {
        _errorMessage = unexpectedErrorMessage;
        _showProgress = false;
      });
      return;
    }
    if (_forceUpdateOrMaintenanceIfNeed(appConfigResult.getData())) {
      return;
    }

    final futureList = [
      _masterRepository.getInquiryMaster(),
      _masterRepository.getPrefectureMaster(),
      _masterRepository.getHeightMaster(),
      _masterRepository.getAnimalMaster(),
      _masterRepository.getJobMaster(),
      _masterRepository.getHolidayMaster(),
      _masterRepository.getHobbyMaster(),
      _masterRepository.getBloodMaster(),
      _masterRepository.getPointMaster(),
      Future.delayed(Duration(seconds: 2)) // 最低2秒表示
    ];
    await Future.wait(futureList);
    navigate();
  }

  bool _forceUpdateOrMaintenanceIfNeed(AppConfig? config) {
    if (config?.isMaintenance() == true) {
      showErrorDialog(context, config!.getMaintenanceMessage());
      setState(() {
        _errorMessage = config.getMaintenanceMessage();
        _showProgress = false;
      });
      return true;
    }

    if (config?.needForceUpdate() == true) {
      _errorMessage =
          'アプリのアップデートをお願いします。\nv${config!.getRequiredVersion()}以上である必要があります。\n\n現在のバージョン : ${AppInfo.appVersion}';
      showErrorDialog(context, _errorMessage);
      setState(() {
        _showProgress = false;
      });
      return true;
    }

    return false;
  }
}
