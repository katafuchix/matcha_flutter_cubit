import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/app_info.dart';
import '../../../core/colors.dart';
import '../../base/base_stateful_widget.dart';
import '../../components/buttons.dart';
import '../../components/containers.dart';
import '../../components/snack_bar.dart';
import '../../components/widget_circular_progress.dart';
import '../../helper/image_util.dart';
import '../home/app_bars.dart';
import 'register_image_cubit.dart';

class RegisterImageScreen extends BaseStatefulWidget {
  final String? profileImageUrl;

  const RegisterImageScreen({this.profileImageUrl});

  @override
  State<StatefulWidget> createState() =>
      _RegisterImageScreen(RegisterImageScreenCubit(), profileImageUrl);
}

// TODO 適宜修正 / 削除
class RegisterImageScreenResult {
  final String result;

  RegisterImageScreenResult(this.result);
}

// TODO 適宜修正
class RegisterImageScreenViewData {
  final String name;
  final String? gender;

  RegisterImageScreenViewData(this.name, {this.gender});
}

class _RegisterImageScreen extends BaseState<RegisterImageScreen> {
  final RegisterImageScreenCubit _registerImageScreenCubit;
  final String? _currentProfileImageUrl;
  final AppColors _colors = getAppColors();

  _RegisterImageScreen(
      this._registerImageScreenCubit, this._currentProfileImageUrl)
      : super(_registerImageScreenCubit);

  String? _base64Image;
  bool _enableRegisterButton = false;

  @override
  void initState() {
    super.initState();
    _registerImageScreenCubit.init(_currentProfileImageUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Containers.createScreenContainer(context, _buildMainWidget());
  }

  Widget _buildMainWidget() {
    return Scaffold(
      appBar: buildNormalAppBar(context, 'プロフィール画像登録'),
      body: BlocProvider<RegisterImageScreenCubit>(
        create: (context) => _registerImageScreenCubit,
        child: BlocConsumer<RegisterImageScreenCubit, RegisterImageScreenState>(
          listener: (context, state) {
            if (state is RegisterImageScreenFailureState) {
              // progress閉じる
              closeProgressIfNeed(context);
              // エラー表示
              showErrorSnackBar(context, text: state.errorMessage);
            } else if (state is RegisterImageScreenFinishState) {
              // progress閉じる
              closeProgressIfNeed(context);

              showInfoSnackBar(context, text: '画像を登録しました');

              // そのまま終了する場合
              Navigator.pop(context, true);
            } else if (state is RegisterImageScreenLoadingState) {
              // progress表示
              showProgress(context);
            }
          },
          buildWhen: (context, state) {
            return state is RegisterImageScreenWidgetState;
          },
          builder: (context, state) {
            if (state is RegisterImageScreenInitialState) {
              return _buildInitializingWidget();
            } else if (state is RegisterImageScreenLoadedViewDataState) {
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

  Widget _buildViewData(RegisterImageScreenViewData viewData) {
    VoidCallback onPressed = () {
      assert(_base64Image != null);
      _registerImageScreenCubit.register(_base64Image!);
    };
    return Column(
      children: [
        SizedBox(
          height: 32,
        ),
        Container(
          child: InkWell(
            onTap: () async {
              _base64Image =
                  await ImageUtil.base64ImagePicker(context: context);

              setState(() {
                _enableRegisterButton = true;
              });
            },
            child: Container(
              height: AppInfo.getAppWidth(context) - 32,
              width: AppInfo.getAppWidth(context) - 32,
              decoration: BoxDecoration(
                border: Border.all(color: _colors.primaryLight, width: 2),
              ),
              child: Center(
                child: _base64Image == null
                    ? (_currentProfileImageUrl == null
                        ? Icon(Icons.person)
                        : Image.network(_currentProfileImageUrl!))
                    : Image.memory(base64Decode(_base64Image!)),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 32,
        ),
        Padding(
          padding: EdgeInsets.only(left: 16, right: 16),
          child: buildSettingHorizontalFullSizeButton(
              onPressed: _enableRegisterButton ? onPressed : null,
              label: '登録する'),
        )
      ],
    );
  }
}
