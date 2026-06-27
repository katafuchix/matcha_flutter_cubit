import '../../../model/repository/repository_result.dart';
import '../../../model/user/handover.dart';
import '../../../repository/user_repository.dart';
import '../../base/base_cubit.dart';
import 'register_email_screen.dart';

// ============================================================================
// State
// ============================================================================
abstract class RegisterEmailScreenState {}

abstract class RegisterEmailScreenWidgetState extends RegisterEmailScreenState {}

class RegisterEmailScreenInitialState extends RegisterEmailScreenWidgetState {}

class RegisterEmailScreenLoadingState extends RegisterEmailScreenState {}

class RegisterEmailScreenLoadedViewDataState
    extends RegisterEmailScreenWidgetState {
  final RegisterEmailScreenViewData viewData;
  RegisterEmailScreenLoadedViewDataState(this.viewData);
}

class RegisterEmailScreenFailureState extends RegisterEmailScreenState {
  String errorMessage;
  RegisterEmailScreenFailureState(this.errorMessage);
}

class RegisterEmailScreenFinishState extends RegisterEmailScreenState {
  RegisterEmailScreenFinishState();
}
// ////////////////////////////////////////////////////////////////////////////

class RegisterEmailScreenCubit extends BaseCubit<RegisterEmailScreenState> {
  RegisterEmailScreenCubit() : super(RegisterEmailScreenInitialState());

  UserRepository _userRepository = UserRepository();

  Future<void> init() async {
    emit(RegisterEmailScreenLoadedViewDataState(
        RegisterEmailScreenViewData('your name')));
  }

  Future<void> register(String email, String password) async {
    emit(RegisterEmailScreenLoadingState());

    final settingResult =
        await _userRepository.postLoginSetting(HandOver(email, password));

    if (settingResult is RepositoryErrorResult) {
      final RepositoryErrorResult<void> errorResult = settingResult;
      emit(RegisterEmailScreenFailureState(errorResult.error.message));
      return;
    }

    emit(RegisterEmailScreenFinishState());
  }
}
