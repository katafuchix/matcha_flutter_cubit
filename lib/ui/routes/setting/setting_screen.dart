import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/colors.dart';
import '../../../core/words.dart';
import '../../base/base_stateful_widget.dart';
import '../../components/containers.dart';
import '../../components/setting_screen_util.dart';
import '../../components/snack_bar.dart';
import '../../components/widget_circular_progress.dart';
import '../../helper/ad_helper.dart';
import '../../helper/ad_unit.dart';
import '../../my_navigator.dart';
import '../home/app_bars.dart';
import '../inquiry/inquiry_screen.dart';
import '../simple_text/simple_text_screen.dart';
import 'setting_cubit.dart';

class SettingScreen extends BaseStatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SettingScreen(SettingScreenCubit());
  }
}

// TODO 適宜修正 / 削除
class SettingScreenResult {
  final String result;

  SettingScreenResult(this.result);
}

// TODO 適宜修正
class SettingScreenViewData {
  final String name;
  final String? gender;

  SettingScreenViewData(this.name, {this.gender});
}

class _SettingScreen extends BaseState<SettingScreen> {
  final SettingScreenCubit _settingScreenCubit;

  _SettingScreen(this._settingScreenCubit) : super(_settingScreenCubit);

  //BannerAdWidget _ad = BannerAdWidget(AdUnits.menuScreenBannerAdUnitId);

  @override
  void initState() {
    super.initState();
    _settingScreenCubit.init();
  }

  @override
  void dispose() {
    super.dispose();
    //_ad.onDispose();
  }

  @override
  void onBuildWidget() {
    super.onBuildWidget();
    /*_ad.onInitState(context, () {
      setState(() {});
    });
     */
  }

  @override
  Widget build(BuildContext context) {
    return Containers.createScreenContainer(context, _buildMainWidget());
  }

  Widget _buildMainWidget() {
    return Scaffold(
      appBar: buildNormalAppBar(context, 'メニュー'),
      body: BlocProvider<SettingScreenCubit>(
        create: (context) => _settingScreenCubit,
        child: BlocConsumer<SettingScreenCubit, SettingScreenState>(
          listener: (context, state) {
            if (state is SettingScreenFailureState) {
              // progress閉じる
              closeProgressIfNeed(context);
              // エラー表示
              showErrorSnackBar(context, text: state.errorMessage);
            } else if (state is SettingScreenFinishState) {
              // progress閉じる
              closeProgressIfNeed(context);

              // 前の画面に結果を返す場合
              Navigator.pop(context, state.result);

              // そのまま終了する場合
              //Navigator.pop(context);
            } else if (state is SettingScreenLoadingState) {
              // progress表示
              showProgress(context);
            }
          },
          buildWhen: (context, state) {
            return state is SettingScreenWidgetState;
          },
          builder: (context, state) {
            if (state is SettingScreenInitialState) {
              return _buildInitializingWidget();
            } else if (state is SettingScreenLoadedViewDataState) {
              return _buildViewData(state.viewData);
            } else {
              throw StateError('unexpected');
            }
          },
        ),
      ),
    );
  }

  Widget _buildInitializingWidget() {
    return Center(
      child: WidgetCircularProgress(),
    );
  }

  Widget _buildViewData(SettingScreenViewData viewData) {
    // TODO
    Widget w = ListView(
      children: [
        // buildSeparator(),
        // borderLine(),
        // settingButton(text: 'すれちがい通信(未実装)', onChanged: (bool value) {}),
        // borderLine(),
        // settingButton(
        //     text: 'すれちがい通信設定(未実装)', action: () {}, visibleForward: true),
        // borderLine(),
        // settingButton(text: '現在地公開(未実装)', onChanged: (bool value) {}),
        // borderLine(),
        // settingButton(text: '座標を固定(未実装)', onChanged: (bool value) {}),
        // borderLine(),
        buildSeparator(),
        borderLine(),
        settingButton(
            text: 'お問い合わせ',
            action: () async {
              final result = await context.appPush(AppRoutes.inquiry);
              if (result is InquiryScreenResult) {
                showInfoSnackBar(context, text: result.message);
              }
            },
            visibleForward: true),
        borderLine(),
        settingButton(
            text: 'よくあるお問い合わせ',
            action: () async {
              context.appPush(AppRoutes.simpleText,
                  extra: SimpleTextScreenArgs('よくあるお問い合わせ', faqWord));
            },
            visibleForward: true),
        borderLine(),
        buildSeparator(),
        borderLine(),
        settingButton(
            text: '利用規約',
            action: () {
              context.appPush(AppRoutes.simpleText,
                  extra: SimpleTextScreenArgs('利用規約', termsOfService));
            },
            visibleForward: true),
        borderLine(),
        settingButton(
            text: '特定商取引に関する表示',
            action: () {
              context.appPush(AppRoutes.simpleText,
                  extra: SimpleTextScreenArgs(
                      '特定商取引法に基づく表示', specifiedCommercialTransactionsLaw));
            },
            visibleForward: true),
        borderLine(),
      ],
    );
    return Container(
        color: getAppColors().primaryBg,
        child: Column(
          children: [Expanded(child: w)//, _ad.buildBannerAdOrEmptyContainer()
       ],
        ));
  }
}
