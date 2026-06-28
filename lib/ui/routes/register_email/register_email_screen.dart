import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../base/base_stateful_widget.dart';
import '../../components/buttons.dart';
import '../../components/snack_bar.dart';
import '../../components/text_field.dart';
import '../../components/text_labels.dart';
import '../../components/widget_circular_progress.dart';
import '../home/app_bars.dart';
import 'register_email_cubit.dart';

class RegisterEmailScreen extends BaseStatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RegisterEmailScreen(RegisterEmailScreenCubit());
  }
}

// TODO 適宜修正
class RegisterEmailScreenViewData {
  final String name;
  final String? gender;

  RegisterEmailScreenViewData(this.name, {this.gender});
}

class _RegisterEmailScreen extends BaseState<RegisterEmailScreen> {
  final RegisterEmailScreenCubit _registerEmailScreenCubit;

  _RegisterEmailScreen(this._registerEmailScreenCubit)
      : super();

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerPasswordConfirm =
      TextEditingController();
  bool _showPasswordOnMainPassword = false;
  bool _showPasswordOnConfirmPassword = false;
  bool _enableRegisterButton = false;

  @override
  void initState() {
    super.initState();
    _registerEmailScreenCubit.init();
  }

  @override
  Widget build(BuildContext context) {
    return _buildMainWidget();
  }

  @override
  void dispose() {
    _controllerEmail.dispose();
    _controllerPassword.dispose();
    _controllerPasswordConfirm.dispose();
    super.dispose();
  }

  Widget _buildMainWidget() {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: buildNormalAppBar(context, '機種変更時のデータ移行'),
      body: BlocProvider<RegisterEmailScreenCubit>(
        create: (context) => _registerEmailScreenCubit,
        child: BlocConsumer<RegisterEmailScreenCubit, RegisterEmailScreenState>(
          listener: (context, state) {
            if (state is RegisterEmailScreenFailureState) {
              // progress閉じる
              closeProgressIfNeed(context);
              // エラー表示
              showErrorSnackBar(context, text: state.errorMessage);
            } else if (state is RegisterEmailScreenFinishState) {
              // progress閉じる
              closeProgressIfNeed(context);

              showInfoSnackBar(context, text: 'メールアドレスを登録しました');

              // そのまま終了する場合
              Navigator.pop(context);
            } else if (state is RegisterEmailScreenLoadingState) {
              // progress表示
              showProgress(context);
            }
          },
          buildWhen: (context, state) {
            return state is RegisterEmailScreenWidgetState;
          },
          builder: (context, state) {
            if (state is RegisterEmailScreenInitialState) {
              return _buildInitializingWidget();
            } else if (state is RegisterEmailScreenLoadedViewDataState) {
              return _buildViewData(context, state.viewData);
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

  Widget _buildViewData(
      BuildContext context, RegisterEmailScreenViewData viewData) {
    return Container(
        child: SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
          left: 16.0,
          right: 16.0,
        ),
        child: Column(
          children: <Widget>[
            SizedBox(height: 32.0),
            buildWidgetLabel(context, 'メールアドレス'),
            SizedBox(height: 8.0),
            buildPlainTextField(context, _controllerEmail,
                inputType: TextInputType.emailAddress,
                action: KeyboardNextAction.NEXT_FOCUS,
                onChanged: (String newValue) {
              handleEnableRegisterButton();
            }),
            SizedBox(height: 16.0),
            buildWidgetLabel(context, 'パスワード(英数字6文字以上)'),
            SizedBox(height: 8.0),
            buildPasswordTextField(context, _controllerPassword,
                action: KeyboardNextAction.NEXT_FOCUS,
                onChanged: (String newValue) {
                  handleEnableRegisterButton();
                },
                showPassword: _showPasswordOnMainPassword,
                onTapSuffixIcon: () {
                  setState(() {
                    _showPasswordOnMainPassword = !_showPasswordOnMainPassword;
                  });
                }),
            SizedBox(height: 16.0),
            buildWidgetLabel(context, 'パスワード(確認)'),
            SizedBox(height: 8.0),
            buildPasswordTextField(context, _controllerPasswordConfirm,
                action: KeyboardNextAction.DONE,
                onChanged: (String newValue) {
                  handleEnableRegisterButton();
                },
                showPassword: _showPasswordOnConfirmPassword,
                onTapSuffixIcon: () {
                  setState(() {
                    _showPasswordOnConfirmPassword =
                        !_showPasswordOnConfirmPassword;
                  });
                }),
            SizedBox(height: 32.0),
            _buildWidgetButtonSignIn(context),
          ],
        ),
      ),
    ));
  }

  Widget _buildWidgetButtonSignIn(BuildContext context) {
    VoidCallback onPressed = () {
      final String email = _controllerEmail.text;
      final String password = _controllerPassword.text;
      if (email == null || password == null) return;
      _registerEmailScreenCubit.register(email, password);
    };
    return buildSettingHorizontalFullSizeButton(
        onPressed: _enableRegisterButton ? onPressed : null, label: '登録');
  }

  void handleEnableRegisterButton() {
    final String email = _controllerEmail.text;
    final String password = _controllerPassword.text;
    final String passwordConfirm = _controllerPasswordConfirm.text;
    final currentEnabled = _enableRegisterButton;

    bool newEnabled = false;

    if (email.isEmpty || password.isEmpty || passwordConfirm.isEmpty)
      newEnabled = false;
    else if (password != passwordConfirm)
      newEnabled = false;
    else if (!RegExp(
            r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
        .hasMatch(email)) {
      // 正規表現でEmailの形式でないことがわかった
      newEnabled = false;
    } else if (password.length < 6) {
      newEnabled = false;
    } else
      newEnabled = true;

    if (currentEnabled != newEnabled) {
      setState(() {
        _enableRegisterButton = newEnabled;
      });
    }
  }
}
