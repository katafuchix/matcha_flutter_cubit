import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart' as dt_picker;
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import '../../../core/colors.dart';
import '../../../model/basic/sex.dart';
import '../../../model/master/master_data.dart';
import '../../../model/user/profile_response.dart';
import '../../../model/user/update_profile.dart';
import '../../../repository/master_repository.dart';
import '../../../repository/storage/shared_preferences/shared_preferences_keys.dart';
import '../../../repository/storage/shared_preferences/shared_preferences_manager.dart';
import '../../../repository/user_repository.dart';
import '../../base/base_stateful_widget.dart';
import '../../components/buttons.dart';
import '../../components/containers.dart';
import '../../components/datetime_util.dart';
import '../../components/dialogs.dart';
import '../../components/image_loader.dart';
import '../../components/profile_util.dart';
import '../../components/setting_screen_util.dart';
import '../../components/texts.dart';
import '../../components/widget_circular_progress.dart';
import '../../helper/repository_handler.dart';
import '../../my_navigator.dart';
import '../home/app_bars.dart';
import '../profile/profile_screen.dart';
import '../register_image/register_image_screen.dart';

class MyPageScreen extends BaseStatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyPageScreen();
  }
}

class MyPageScreenViewData {
  final List<MasterData>? blood;
  final List<MasterData>? prefectures;
  final List<MasterData>? holiday;
  final List<MasterData>? job;
  final List<MasterData>? animal;
  final List<MasterData>? hobby;
  ProfileResponse? profile;

  MyPageScreenViewData(this.blood, this.prefectures, this.holiday, this.job,
      this.animal, this.hobby, this.profile);
}

class _MyPageScreen extends BaseState<MyPageScreen> {
  _MyPageScreen() : super(null);

  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _profileCommentController =
      TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final UserRepository _userRepository = UserRepository();
  final MasterRepository _masterRepository = MasterRepository();
  final AppColors _colors = getAppColors();
  DateTime? _selectedBirthday;

  MyPageScreenViewData? viewData;

  @override
  void initState() {
    super.initState();
    _initialLoad();
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _profileCommentController.dispose();
    super.dispose();
  }

  Future _initialLoad() async {
    // TODO エラーハンドリング
    viewData = MyPageScreenViewData(
        RepositoryHandler.getSuccessOrNull(
            await _masterRepository.getBloodMaster()),
        RepositoryHandler.getSuccessOrNull(
            await _masterRepository.getPrefectureMaster()),
        RepositoryHandler.getSuccessOrNull(
            await _masterRepository.getHolidayMaster()),
        RepositoryHandler.getSuccessOrNull(
            await _masterRepository.getJobMaster()),
        RepositoryHandler.getSuccessOrNull(
            await _masterRepository.getAnimalMaster()),
        RepositoryHandler.getSuccessOrNull(
            await _masterRepository.getHobbyMaster()),
        RepositoryHandler.getSuccessOrNull(
            await _userRepository.getLatestMe()));
    setState(() {});
  }

  Future _refreshProfile() async {
    // TODO エラーハンドリング
    final profile =
        RepositoryHandler.getSuccessOrNull(await _userRepository.getLatestMe());
    if (profile != null) {
      viewData?.profile = profile;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Containers.createScreenContainer(context, _buildMainWidget());
  }

  Widget _buildMainWidget() {
    return Scaffold(
      key: _scaffoldKey,
      appBar: buildNormalAppBar(context, 'マイページ'),
      body: viewData == null
          ? _buildInitializingWidget()
          : _buildViewData(viewData!),
    );
  }

  Widget _buildInitializingWidget() {
    return Center(
      child: WidgetCircularProgress(),
    );
  }

  Widget _buildViewData(MyPageScreenViewData viewData) {
    _userNameController.text = viewData.profile?.profile?.nickname ?? '';
    _profileCommentController.text = viewData.profile?.profile?.comment ?? '';

    return Container(
        color: _colors.primaryBg,
        child: ListView(
          children: [
            buildSeparator(),
            settingLabel('チケット'),
            borderLine(),
            settingButton(
                text: '保有チケット',
                currentValue:
                    viewData.profile?.profile?.point?.toString() ?? ' -- ',
                action: null),
            borderLine(),
            settingButton(
                text: 'チケット履歴',
                action: () {
                  context.appPush(AppRoutes.pointHistory);
                },
                visibleForward: true),
            borderLine(),
            buildSeparator(),
            settingLabel('基本プロフィール'),
            borderLine(),
            settingButton(
                text: 'ニックネーム',
                currentValue: _userNameController.text,
                action: () {
                  _showNickNameSettingDialog();
                }),
            borderLine(),
            settingButton(
                text: '自己紹介',
                currentValue: _profileCommentController.text,
                action: () {
                  _showProfileCommentSettingDialog();
                }),
            borderLine(),
            settingButton(
                text: '性別',
                currentValue: viewData.profile?.profile?.sex?.displayText ?? '',
                action: null),
            borderLine(),
            settingButton(
                text: '誕生日',
                currentValue: viewData.profile?.profile?.birthday ?? '',
                action: () {
                  _showDatePicker(context);
                }),
            borderLine(),
            settingButton(
                text: 'プロフィール画像',
                action: () async {
                  String? imageUrl;
                  if (viewData.profile?.profileImages.isNotEmpty == true) {
                    imageUrl = ImageLoader.apiUrlToFullPath(
                        viewData.profile?.profileImages.first.image);
                  }
                  final result = await context.appPush(AppRoutes.registerImage,
                      extra: imageUrl);
                  if (result is bool && result == true) {
                    await _refreshProfile();
                  }
                },
                visibleForward: true),
            borderLine(),
            settingButton(
                text: 'プロフィール確認',
                action: () async {
                  context.appPush(AppRoutes.profile,
                      extra: ProfileScreenArgs(viewData.profile!, isMe: true));
                }),
            borderLine(),
            buildSeparator(),
            settingLabel('詳細プロフィール'),
            borderLine(),
            settingButton(
                text: '身長',
                currentValue: viewData.profile?.profile.height == null
                    ? null
                    : '${viewData.profile!.profile.height}cm',
                action: () {
                  _showHeightPicker(context);
                }),
            borderLine(),
            settingButton(
                text: '血液型',
                currentValue: viewData.profile?.profile.blood ?? '',
                action: () {
                  if (viewData.blood != null) {
                    _showBloodPicker(context, viewData.blood!);
                  }
                }),
            borderLine(),
            settingButton(
                text: '休日',
                currentValue: viewData.profile?.profile.profHoliday ?? '',
                action: () {
                  if (viewData.holiday != null) {
                    _showHolidayPicker(context, viewData.holiday!);
                  }
                }),
            borderLine(),
            settingButton(
                text: '仕事',
                currentValue: viewData.profile?.profile.profJob ?? '',
                action: () {
                  if (viewData.job != null) {
                    _showJobPicker(context, viewData.job!);
                  }
                }),
            borderLine(),
            settingButton(
                text: '動物に例えると',
                currentValue: viewData.profile?.profile.profAnimal ?? '',
                action: () {
                  if (viewData.animal != null) {
                    _showAnimalPicker(context, viewData.animal!);
                  }
                }),
            borderLine(),
            settingButton(
                text: '趣味・マイブーム',
                currentValue: viewData.profile?.profile.profHobby ?? '',
                action: () {
                  if (viewData.hobby != null) {
                    _showHobbyPicker(context, viewData.hobby!);
                  }
                }),
            borderLine(),
            buildSeparator(),
            settingLabel('その他'),
            borderLine(),
            settingButton(
                text: '機種変更時のデータ移行',
                action: () {
                  context.appPush(AppRoutes.registerEmail);
                },
                visibleForward: true),
            borderLine(),
            settingButton(
                text: 'お気に入りリスト',
                action: () {
                  context.appPush(AppRoutes.favoriteList);
                }),
            borderLine(),
            settingButton(
                text: 'ブロックリスト',
                action: () {
                  // TODO 変動があったら更新する？
                  context.appPush(AppRoutes.blockList);
                }),
            borderLine(),
            settingButton(
                text: 'ログアウト',
                action: () {
                  showAlertDialog(context,
                      title: 'ログアウトします',
                      message: '引き継ぎデータがない場合、同じアカウントにログインできません。よろしいですか？',
                      cancelable: true, onOk: () async {
                    (await SharedPreferencesManager.getInstance())
                        .clearKey(SharedPreferencesKeys.ACCESS_TOKEN);
                    context.appGo(AppRoutes.signIn);
                  });
                }),
            borderLine(),
            settingButton(
                text: '退会',
                action: () {
                  showAlertDialog(context,
                      title: '退会します',
                      message: 'よろしいですか？',
                      cancelable: true, onOk: () async {
                    showProgress(_scaffoldKey.currentContext!);
                    final result = await _userRepository.postWithdraw();
                    closeProgressIfNeed(_scaffoldKey.currentContext!);
                    RepositoryHandler.handleRepositoryResult<void>(
                        _scaffoldKey.currentContext!, result,
                        onSuccess: (_, __) async {
                      (await SharedPreferencesManager.getInstance())
                          .putString(SharedPreferencesKeys.ACCESS_TOKEN, '');
                      _scaffoldKey.currentContext!.appGo(AppRoutes.signIn);
                    });
                  });
                }),
            borderLine(),
            buildSeparator(),
          ],
        ));
  }

  void _showNickNameSettingDialog() {
    _showInputSettingDialog('ニックネーム', _userNameController, () async {
      // TODO エラーハンドリング
      await _userRepository
          .postUpdateProfile(UpdateProfile(nickname: _userNameController.text));
      await _refreshProfile();
    }, false);
  }

  void _showProfileCommentSettingDialog() {
    _showInputSettingDialog('自己紹介', _profileCommentController, () async {
      // TODO エラーハンドリング
      await _userRepository.postUpdateProfile(
          UpdateProfile(comment: _profileCommentController.text));
      await _refreshProfile();
    }, true);
  }

  void _showInputSettingDialog(String label, TextEditingController controller,
      Function onPressed, bool multiline) {
    showCustomDialog(
        context: context,
        builder: (BuildContext context, StateSetter setStateForDialog) {
          return Padding(
            padding: EdgeInsets.all(16),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  maxHeight:
                      MediaQuery.of(context).size.height / (multiline ? 2 : 3)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  buildNormalText(label),
                  const SizedBox(
                    height: 16,
                  ),
                  Expanded(
                      child: Align(
                    alignment: Alignment.topCenter,
                    child: multiline
                        ? TextField(
                            controller: controller,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                          )
                        : TextField(
                            controller: controller,
                          ),
                  )),
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: buildSettingHorizontalFullSizeButton(
                      onPressed: () {
                        // ダイアログを閉じる
                        Navigator.pop(context);
                        onPressed.call();
                      },
                      label: '保存',
                    ),
                  )
                ],
              ),
            ),
          );
        },
        barrierDismissible: true);
  }

  void _showDatePicker(BuildContext context) {
    if (viewData?.profile?.profile.birthday != null) {
      _selectedBirthday =
          DateTimeConverter.parse(viewData!.profile!.profile.birthday);
    }
    final nowYear = DateTime.now().year;
    dt_picker.DatePicker.showDatePicker(context,
        showTitleActions: true,
        minTime: DateTime(1900, 1, 1),
        maxTime: DateTime(nowYear, 12, 31),
        locale: dt_picker.LocaleType.jp,
        theme: dt_picker.DatePickerTheme(
            headerColor: _colors.primary,
            backgroundColor: Colors.white,
            itemStyle: TextStyle(
                color: _colors.textOrIcons,
                fontWeight: FontWeight.bold,
                fontSize: 18),
            cancelStyle: TextStyle(color: _colors.textOrIcons, fontSize: 16),
            doneStyle: TextStyle(color: _colors.textOrIcons, fontSize: 16)),
        onChanged: (date) {
      print('change $date in time zone ' +
          date.timeZoneOffset.inHours.toString());
    }, onConfirm: (date) async {
      print('confirm $date');
      _selectedBirthday = date;

      initializeDateFormatting("ja_JP");
      var formatter = new DateFormat('yyyy年M月d日', "ja_JP");
      var formatted = formatter.format(date); // DateからString

      // APIコール TODO エラーハンドリング
      await _userRepository.postUpdateProfile(
          UpdateProfile.fromDateTimeBirthday(_selectedBirthday!));
      await _refreshProfile();
    }, currentTime: _selectedBirthday ?? DateTime(nowYear - 30, 1, 1));
  }

  void _showBloodPicker(BuildContext context, List<MasterData> bloodList) {
    showMasterDataPicker(
        context, _scaffoldKey, bloodList, viewData?.profile?.profile.blood,
        (int newIndex) async {
      int id = bloodList.map((e) => e.id).toList()[newIndex];
      // TODO エラーハンドリング
      await _userRepository.postUpdateProfile(UpdateProfile(bloodId: id));
      await _refreshProfile();
    });
  }

  void _showHolidayPicker(BuildContext context, List<MasterData> holidayList) {
    showMasterDataPicker(context, _scaffoldKey, holidayList,
        viewData?.profile?.profile.profHoliday, (int newIndex) async {
      int id = holidayList.map((e) => e.id).toList()[newIndex];
      // TODO エラーハンドリング
      await _userRepository.postUpdateProfile(UpdateProfile(profHolidayId: id));
      await _refreshProfile();
    });
  }

  void _showJobPicker(BuildContext context, List<MasterData> jobList) {
    showMasterDataPicker(
        context, _scaffoldKey, jobList, viewData?.profile?.profile.profJob,
        (int newIndex) async {
      int id = jobList.map((e) => e.id).toList()[newIndex];
      // TODO エラーハンドリング
      await _userRepository.postUpdateProfile(UpdateProfile(profJobId: id));
      await _refreshProfile();
    });
  }

  void _showAnimalPicker(BuildContext context, List<MasterData> animalList) {
    showMasterDataPicker(context, _scaffoldKey, animalList,
        viewData?.profile?.profile.profAnimal, (int newIndex) async {
      int id = animalList.map((e) => e.id).toList()[newIndex];
      // TODO エラーハンドリング
      await _userRepository.postUpdateProfile(UpdateProfile(profAnimalId: id));
      await _refreshProfile();
    });
  }

  void _showHobbyPicker(BuildContext context, List<MasterData> hobbyList) {
    showMasterDataPicker(
        context, _scaffoldKey, hobbyList, viewData?.profile?.profile.profHobby,
        (int newIndex) async {
      int id = hobbyList.map((e) => e.id).toList()[newIndex];
      // TODO エラーハンドリング
      await _userRepository.postUpdateProfile(UpdateProfile(profHobbyId: id));
      await _refreshProfile();
    });
  }

  void _showHeightPicker(BuildContext context) {
    int currentHeight = viewData?.profile?.profile.height ?? 170;

    List<int> heightList = List<int>.generate(71, (i) => i + 130);
    String currentValue = '${currentHeight}cm';
    showStringListPicker(
        context,
        _scaffoldKey,
        heightList.map((e) => '${e}cm').toList(),
        currentValue, (int newIndex) async {
      int height = heightList[newIndex];
      // TODO エラーハンドリング
      await _userRepository.postUpdateProfile(UpdateProfile(height: height));
      await _refreshProfile();
    });
  }
}
