import 'package:matcha_flutter_cubit/core/app_info.dart';

import '../../../core/event_tracking.dart';
import '../../../model/basic/sex.dart';
import '../../../model/master/master_data.dart';
import '../../../model/repository/repository_result.dart';
import '../../../model/sign_in/sign_in_request.dart';
import '../../../model/sign_in/sign_in_response.dart';
import '../../../model/sign_up/sign_up_request.dart';
import '../../../model/sign_up/sign_up_response.dart';
import '../../../repository/auth_repository.dart';
import '../../../repository/master_repository.dart';
import '../../../repository/storage/shared_preferences/shared_preferences_keys.dart';
import '../../../repository/storage/shared_preferences/shared_preferences_manager.dart';
import '../../base/base_cubit.dart';
import 'sign_in_screen.dart';

// ----------------------------------------------------------------------------
// State
// ----------------------------------------------------------------------------
abstract class SignInScreenState {}

abstract class SignInScreenWidgetState extends SignInScreenState {}

class SignInScreenInitialState extends SignInScreenWidgetState {}

class SignInScreenLoadedViewDataState extends SignInScreenWidgetState {
  final SignInScreenViewData viewData;
  SignInScreenLoadedViewDataState(this.viewData);
}

class SignInScreenLoadingState extends SignInScreenState {}

class SignInScreenSignInDoneState extends SignInScreenState {}

class SignInScreenFailureState extends SignInScreenState {
  String errorMessage;
  SignInScreenFailureState(this.errorMessage);
}

class SignInScreenShowAgreeDialogState extends SignInScreenState {}
// ----------------------------------------------------------------------------

class SignInScreenCubit extends BaseCubit<SignInScreenState> {
  final AuthRepository _authRepository = AuthRepository();
  final MasterRepository _masterRepository = MasterRepository();

  SignInScreenCubit() : super(SignInScreenInitialState());

  Future<void> init() async {
    final prefectureResult = await _masterRepository.getPrefectureMaster();
    if (prefectureResult.isError()) {
      print('getPrefectureMaster error');
      emit(SignInScreenFailureState('予期せぬエラーが発生しました。時間をあけて再度おためしください。'));
      emit(SignInScreenLoadedViewDataState(SignInScreenViewData([])));
      return;
    }

    final List<MasterData> prefectures = prefectureResult.getData() ?? [];
    prefectures.removeWhere((element) => element.enabled != true);

    emit(SignInScreenLoadedViewDataState(SignInScreenViewData(prefectures)));
    emit(SignInScreenShowAgreeDialogState());
  }

  Future<void> signUp(
      String nickname, int profAddressId, Sex sex, DateTime birthday) async {
    if (nickname.isNotEmpty != true) return;

    emit(SignInScreenLoadingState());

    final String? clientIdentifier = AppInfo.deviceId;

    var request = SignUpRequest.fromUi(
        nickname, profAddressId, sex, birthday, clientIdentifier);
    var result = await _authRepository.postCreateUser(request);

    if (!(result is RepositorySuccessResult)) {
      emit(SignInScreenFailureState('ログインに失敗しました'));
      return;
    }

    SignUpResponse r = result.getData()!;
    _saveTokens(r.authenticationToken!);
    _saveSex(r.sex);
    emit(SignInScreenSignInDoneState());

    await _sendRegisterEvent(sex);
  }

  Future<void> signIn(String email, String password) async {
    if (email.isEmpty) {
      emit(SignInScreenFailureState('メールアドレスを入力してください。'));
      return;
    }

    if (password.isEmpty) {
      emit(SignInScreenFailureState('パスワードを入力してください。'));
      return;
    }

    emit(SignInScreenLoadingState());

    var request = SignInRequest(email, password);
    var result = await _authRepository.postSignIn(request);

    if (!(result is RepositorySuccessResult)) {
      emit(SignInScreenFailureState('ログインに失敗しました'));
      return;
    }

    SignInResponse r = result.getData()!;
    _saveTokens(r.authenticationToken);
    _saveSex(r.sex);
    emit(SignInScreenSignInDoneState());
  }

  void _saveTokens(String token) {
    SharedPreferencesManager.getInstance().then((manager) {
      manager.putString(SharedPreferencesKeys.ACCESS_TOKEN, token);
    });
  }

  void _saveSex(SexAsResponse sex) {
    SharedPreferencesManager.getInstance().then((manager) {
      manager.putBool(
          SharedPreferencesKeys.IS_MALE, sex == SexAsResponse.Male);
    });
  }

  Future _sendRegisterEvent(Sex sex) async {
    await AppEvent.sendRegisterEvent(sex);
  }
}
