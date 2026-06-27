import 'package:flutter/cupertino.dart' as cuper;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as flutter_datetime_picker;
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:matcha_flutter_cubit/core/my_logger.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/colors.dart';
import '../../../core/my_notification_manager.dart';
import '../../../core/my_platform.dart';
import '../../../model/basic/sex.dart';
import '../../../model/master/master_data.dart';
import '../../base/base_stateful_widget.dart';
import '../../components/buttons.dart';
import '../../components/containers.dart';
import '../../components/dialogs.dart';
import '../../components/profile_util.dart';
import '../../components/text_field.dart';
import '../../components/text_labels.dart';
import '../../components/texts.dart';
import '../../components/widget_circular_progress.dart';
import '../../my_navigator.dart';
import '../../components/texts.dart';
import 'sign_in_cubit.dart';

class SignInScreenViewData {
  final List<MasterData> prefectures;

  SignInScreenViewData(this.prefectures);
}

class SignInScreen extends BaseStatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SignInScreenState();
  }
}

class _SignInScreenState extends BaseState<SignInScreen> {
  final SignInScreenCubit _signInScreenCubit = SignInScreenCubit();

  final TextEditingController _controllerNickName = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final AppColors _colors = getAppColors();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late BorderSide _borderSide;

  String? _displayBirthday;
  DateTime? _selectedBirthday;
  String? _prefecture;
  bool? _isSignUp = true;
  bool? _showSignInPassword = false;
  bool? _enableSignInButton = false;
  bool? _enableSignUpButton = false;
  String? deviceToken;
  Sex? _sex;

  _SignInScreenState() : super(null) {
    _borderSide = BorderSide(color: _colors.primaryDark, width: 2);
  }

  Future onSignInDone() async {
    if (MyPlatform.isMobileApp) {
      await MyNotificationManager.requestPermission();
    }
    context.appGo(AppRoutes.home);
  }

  @override
  void initState() {
    super.initState();
    _signInScreenCubit.init();
  }

  @override
  Widget build(BuildContext context) {
    return Containers.createScreenContainer(
        context,
        Scaffold(
          key: _scaffoldKey,
          resizeToAvoidBottomInset: false,
          body: GestureDetector(
            onTap: () {
              final FocusScopeNode currentScope = FocusScope.of(context);
              if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
                FocusManager.instance.primaryFocus?.unfocus();
              }
            },
            child: BlocProvider<SignInScreenCubit>(
              create: (context) => _signInScreenCubit,
              child: BlocConsumer<SignInScreenCubit, SignInScreenState>(
                listener: (context, state) {
                  if (state is SignInScreenFailureState) {
                    showErrorDialog(context, state.errorMessage);
                  }

                  if (state is SignInScreenSignInDoneState) {
                    onSignInDone();
                  }

                  if (state is SignInScreenShowAgreeDialogState) {
                    _showAgreeDialog();
                    return;
                  }
                },
                buildWhen: (context, state) {
                  return state is SignInScreenWidgetState;
                },
                builder: (context, state) {
                  if (state is SignInScreenInitialState) {
                    return _buildInitializingWidget();
                  }
                  if (state is SignInScreenLoadedViewDataState) {
                    return _buildMain(context, state.viewData);
                  }
                  throw StateError('unexpected');
                },
              ),
            ),
          ),
        ));
  }

  Future _showAgreeDialog() {
    return showCustomDialog(
        context: context,
        builder: (BuildContext context, StateSetter setState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 16,
              ),
              RichText(
                text: TextSpan(children: [
                  TextSpan(
                      text: '登録すると同時に私はmatchaの\n', style: createAppTextStyle()),
                  TextSpan(
                    text: '利用規約',
                    style: createAppTextStyle(colors: TextColors.PRIMARY),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        launch('https://matchchat.net/rule.html');
                      },
                  ),
                  TextSpan(text: 'と', style: createAppTextStyle()),
                  TextSpan(
                    text: 'プライバシーポリシー',
                    style: createAppTextStyle(colors: TextColors.PRIMARY),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        launch('https://matchchat.net/privacy.html');
                      },
                  ),
                  TextSpan(text: 'に同意します', style: createAppTextStyle()),
                ]),
              ),
              const SizedBox(
                height: 16,
              ),
              buildNormalButton(
                  onPressed: () => onPressedAgree(context), label: '同意する'),
              if (MyPlatform.isAndroid)
                buildTextButton(
                    onPressed: () => onPressedDisAgree(context),
                    label: '同意しない'),
              if (MyPlatform.isWeb)
                const SizedBox(
                  height: 16,
                )
            ],
          );
        },
        barrierDismissible: false);
  }

  onPressedAgree(BuildContext context) {
    Navigator.pop(context);
  }

  onPressedDisAgree(BuildContext context) {
    Navigator.pop(context);
    SystemNavigator.pop();
  }

  Widget _buildInitializingWidget() {
    return Center(
      child: WidgetCircularProgress(),
    );
  }

  Widget _buildMain(BuildContext context, SignInScreenViewData viewData) {
    if (_isSignUp == false) {
      return _buildSignInMain(context);
    } else {
      return _buildSignUpMain(context, viewData.prefectures);
    }
  }

  Widget _buildSignInMain(BuildContext context) {
    return Container(
        height: double.infinity,
        child: Padding(
          padding: EdgeInsets.only(
            left: 16.0,
            right: 16.0,
          ),
          child: ListView(
            children: <Widget>[
              _buildWidgetSizedBox(64.0),
              _buildWidgetLabel(context, 'メールアドレス'),
              _buildWidgetTextFieldEmail(),
              _buildWidgetSizedBox(32.0),
              _buildWidgetLabel(context, 'パスワード'),
              _buildWidgetTextFieldPassword(),
              _buildWidgetSizedBox(32.0),
              _buildWidgetButtonSignIn(context),
              buildTextButton(
                  onPressed: () {
                    setState(() {
                      _isSignUp = true;
                    });
                  },
                  label: '新規に始める')
            ],
          ),
        ));
  }

  Widget _buildSignUpMain(BuildContext context, List<MasterData> prefectures) {
    return Container(
        height: double.infinity,
        child: Padding(
          padding: EdgeInsets.only(
            left: 16.0,
            right: 16.0,
          ),
          child: ListView(
            children: <Widget>[
              _buildWidgetSizedBox(64.0),
              _buildWidgetLabel(context, 'ニックネーム'),
              _buildWidgetTextFieldNickName(context),
              _buildWidgetSizedBox(32.0),
              _buildWidgetLabel(context, 'エリア'),
              _buildWidgetPrefecture(prefectures),
              _buildWidgetSizedBox(32.0),
              _buildWidgetLabel(context, '性別'),
              _buildWidgetSex(),
              _buildWidgetSizedBox(16.0),
              _buildWidgetLabel(context, '生年月日'),
              _buildWidgetBirthday(context),
              _buildWidgetSizedBox(32.0),
              _buildWidgetButtonSignUp(context, prefectures),
              buildTextButton(
                  onPressed: () {
                    setState(() {
                      _isSignUp = false;
                    });
                  },
                  label: 'アカウントをお持ちの方はこちら'),
              _buildWidgetSizedBox(16.0),
            ],
          ),
        ));
  }

  Widget _buildWidgetSizedBox(double height) => SizedBox(height: height);

  Widget _buildWidgetLabel(BuildContext context, String label) {
    return buildWidgetLabel(context, label);
  }

  Widget _buildWidgetTextFieldNickName(BuildContext context) {
    return buildPlainTextField(context, _controllerNickName,
        onChanged: (newValue) {
      _handleEnableSignUpButton();
    }, inputType: TextInputType.name, action: KeyboardNextAction.DONE);
  }

  Widget _buildWidgetPrefecture(List<MasterData> prefectures) {
    final List<DropdownMenuItem<String>> list = prefectures
        .map((e) => DropdownMenuItem(
            value: e.name,
            child: Container(
              child: Padding(
                padding: EdgeInsets.all(0),
                child: buildNormalText(e.name),
              ),
            )))
        .toList();
    if (MyPlatform.isWeb) {
      return Column(
        children: [
          DropdownButton(
              value: _prefecture,
              items: list,
              onChanged: (String? value) {
                setState(() {
                  _prefecture = value;
                });
              },
              isExpanded: true,
              underline: Container(
                height: 2,
                color: getAppColors().primary,
              ),
              menuMaxHeight: 300),
        ],
      );
    }
    return Container(
      width: double.infinity,
      height: 64,
      decoration: BoxDecoration(
        border: Border(bottom: _borderSide),
      ),
      child: InkWell(
        onTap: () {
          // キーボードを閉じる
          final FocusScopeNode currentScope = FocusScope.of(context);
          if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
            FocusManager.instance.primaryFocus?.unfocus();
          }

          _showPicker(context, prefectures);
        },
        child: Center(
          child: buildNormalText(_prefecture ?? ''),
        ),
      ),
    );
  }

  Widget _buildWidgetSex() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Radio(
            value: Sex.Male,
            groupValue: _sex,
            onChanged: (value) {
              setState(() {
                _sex = Sex.Male;
              });
              _handleEnableSignUpButton();
            },
          ),
          buildNormalText('男性'),
          const SizedBox(
            width: 16,
          ),
          Radio(
            value: Sex.Female,
            groupValue: _sex,
            onChanged: (value) {
              setState(() {
                _sex = Sex.Female;
              });
              _handleEnableSignUpButton();
            },
          ),
          buildNormalText('女性'),
        ],
      ),
    );
  }

  Widget _buildWidgetBirthday(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 48,
      decoration: BoxDecoration(
        border: Border(bottom: _borderSide),
      ),
      child: InkWell(
        onTap: () async {
          // キーボードを閉じる
          FocusScope.of(context).unfocus();

          if (MyPlatform.isWeb) {
            final now = DateTime.now();
            // final result = await showDatePicker(
            //     context: context,
            //     // locale: const Locale("ja_JP"),
            //     initialDate: DateTime(now.year - 30, now.month, now.day),
            //     firstDate: new DateTime(1900),
            //     lastDate: new DateTime.now());
            await cuper.showCupertinoModalPopup<void>(
              context: context,
              builder: (BuildContext context) {
                return _buildBottomPicker(cuper.CupertinoDatePicker(
                  mode: cuper.CupertinoDatePickerMode.dateAndTime,
                  initialDateTime: DateTime(now.year - 30, now.month, now.day),
                  onDateTimeChanged: (DateTime newDateTime) {
                    setState(() {
                      initializeDateFormatting("ja_JP");
                      var formatter = new DateFormat('yyyy年M月d日', "ja_JP");
                      var formatted =
                      formatter.format(newDateTime); // DateからString
                      _selectedBirthday = newDateTime;
                      _displayBirthday = formatted;
                    });
                    _handleEnableSignUpButton();
                  },
                ));
              },
            );
            // if (result != null) {
            //   setState(() {
            //     initializeDateFormatting("ja_JP");
            //     var formatter = new DateFormat('yyyy年M月d日', "ja_JP");
            //     var formatted = formatter.format(result); // DateからString
            //     _selectedBirthday = result;
            //     _displayBirthday = formatted;
            //   });
            //   _handleEnableSignUpButton();
            // }
            return;
          }

          // 30歳基準
          final nowYear = DateTime.now().year;
          flutter_datetime_picker.DatePicker.showDatePicker(context,
              showTitleActions: true,
              minTime: DateTime(1900, 1, 1),
              maxTime: DateTime(nowYear, 12, 31),
              locale: flutter_datetime_picker.LocaleType.jp,
              theme: flutter_datetime_picker.DatePickerTheme(
                  headerColor: _colors.primary,
                  backgroundColor: Colors.white,
                  itemStyle: TextStyle(
                      color: _colors.textOrIcons,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                  cancelStyle:
                      TextStyle(color: _colors.textOrIcons, fontSize: 16),
                  doneStyle:
                      TextStyle(color: _colors.textOrIcons, fontSize: 16)),
              onChanged: (date) {
            print('change $date in time zone ' +
                date.timeZoneOffset.inHours.toString());
          }, onConfirm: (date) {
            print('confirm $date');
            _selectedBirthday = date;

            initializeDateFormatting("ja_JP");
            var formatter = new DateFormat('yyyy年M月d日', "ja_JP");
            var formatted = formatter.format(date); // DateからString
            setState(() {
              _displayBirthday = formatted;
            });
            _handleEnableSignUpButton();
          }, currentTime: _selectedBirthday ?? DateTime(nowYear - 30, 1, 1));
        },
        child: Center(
          child: buildNormalText(_displayBirthday ?? ''),
        ),
      ),
    );
  }

  Widget _buildBottomPicker(Widget picker) {
    return Container(
      height: 216,
      padding: const EdgeInsets.only(top: 6.0),
      color: _colors.primaryBg,
      child: DefaultTextStyle(
          style: TextStyle(
            color: _colors.primaryText,
            fontSize: 22.0,
          ),
          child: GestureDetector(
              onTap: () {},
              child: SafeArea(
                top: false,
                child: picker,
              ))),
    );
  }

  Widget _buildWidgetTextFieldEmail() {
    return buildPlainTextField(context, _controllerEmail,
        inputType: TextInputType.emailAddress,
        action: KeyboardNextAction.NEXT_FOCUS, onChanged: (String newValue) {
      _handleEnableSignInButton();
    });
  }

  Widget _buildWidgetTextFieldPassword() {
    return buildPasswordTextField(context, _controllerPassword,
        action: KeyboardNextAction.DONE,
        onChanged: (String newValue) {
          _handleEnableSignInButton();
        },
        showPassword: _showSignInPassword,
        onTapSuffixIcon: () {
          setState(() {
            _showSignInPassword = !(_showSignInPassword!);
          });
        });
  }

  Widget _buildWidgetButtonSignIn(BuildContext context) {
    VoidCallback onPressed = () {
      String username = _controllerEmail.text.trim();
      String password = _controllerPassword.text.trim();
      _signInScreenCubit.signIn(username, password);
    };
    return buildSettingHorizontalFullSizeButton(
        onPressed: _enableSignInButton == true ? onPressed : null,
        label: 'ログイン');
  }

  Widget _buildWidgetButtonSignUp(
      BuildContext context, List<MasterData> prefectures) {
    VoidCallback onPressed = () {
      String nickName = _controllerNickName.text.trim();
      int? prefectureId;
      if (_prefecture != null) {
        prefectureId =
            prefectures.firstWhere((element) => element.name == _prefecture).id;
      }
      if (prefectureId == null) return;
      assert(_sex != null);
      assert(_selectedBirthday != null);
      _signInScreenCubit.signUp(
          nickName, prefectureId, _sex!, _selectedBirthday!);
    };
    return buildSettingHorizontalFullSizeButton(
        onPressed: _enableSignUpButton == true ? onPressed : null,
        label: '登録する');
  }

  _showPicker(BuildContext context, List<MasterData> prefectures) {
    prefectures.sort((a, b) => (a.sortOrder ?? 0) - (b.sortOrder ?? 0));
    List<String> prefectureNameList = prefectures.map((e) => e.name).toList();

    showMasterDataPicker(context, _scaffoldKey, prefectures, _prefecture,
        (int newIndex) {
      _prefecture = prefectureNameList[newIndex];
      setState(() {});
    });
  }

  void _handleEnableSignInButton() {
    final String email = _controllerEmail.text;
    final String password = _controllerPassword.text;
    final currentEnabled = _enableSignInButton;

    bool newEnabled = false;

    if (email.isEmpty || password.isEmpty)
      newEnabled = false;
    else if (!RegExp(
            r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
        .hasMatch(email))
      // 正規表現でEmailの形式でないことがわかった
      newEnabled = false;
    else if (password.length < 6)
      newEnabled = false;
    else
      newEnabled = true;

    if (currentEnabled != newEnabled) {
      setState(() {
        _enableSignInButton = newEnabled;
      });
    }
  }

  void _handleEnableSignUpButton() {
    final String nickName = _controllerNickName.text;
    final currentEnabled = _enableSignUpButton;

    bool newEnabled = false;

    if (nickName.length < 2) {
      MyLogger.d('nickName.length < 2');
      newEnabled = false;
    } else if (_displayBirthday == null) {
      MyLogger.d('_displayBirthday == null');
      newEnabled = false;
    } else if (_sex == null) {
      MyLogger.d('_sex == null');
      newEnabled = false;
    } else if (_sex == null) {
      MyLogger.d('_sex == null');
      newEnabled = false;
    } else {
      newEnabled = true;
    }

    if (currentEnabled != newEnabled) {
      setState(() {
        _enableSignUpButton = newEnabled;
      });
    }
  }
}
