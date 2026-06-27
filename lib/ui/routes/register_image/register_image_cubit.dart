import '../../../model/repository/repository_result.dart';
import '../../../model/user/upload_image.dart';
import '../../../repository/user_repository.dart';
import '../../base/base_cubit.dart';
import 'register_image_screen.dart';

// ============================================================================
// State
// ============================================================================
abstract class RegisterImageScreenState {}

abstract class RegisterImageScreenWidgetState extends RegisterImageScreenState {}

class RegisterImageScreenInitialState extends RegisterImageScreenWidgetState {}

class RegisterImageScreenLoadingState extends RegisterImageScreenState {}

class RegisterImageScreenLoadedViewDataState
    extends RegisterImageScreenWidgetState {
  final RegisterImageScreenViewData viewData;
  RegisterImageScreenLoadedViewDataState(this.viewData);
}

class RegisterImageScreenFailureState extends RegisterImageScreenState {
  String errorMessage;
  RegisterImageScreenFailureState(this.errorMessage);
}

class RegisterImageScreenFinishState extends RegisterImageScreenState {
  RegisterImageScreenFinishState();
}
// ////////////////////////////////////////////////////////////////////////////

class RegisterImageScreenCubit extends BaseCubit<RegisterImageScreenState> {
  RegisterImageScreenCubit() : super(RegisterImageScreenInitialState());

  UserRepository _userRepository = UserRepository();
  bool hasProfileImage = false;

  Future<void> init(String? currentProfileImageUrl) async {
    hasProfileImage = currentProfileImageUrl != null;

    emit(RegisterImageScreenLoadedViewDataState(
        RegisterImageScreenViewData('your name')));
  }

  Future<void> register(String base64Image) async {
    emit(RegisterImageScreenLoadingState());

    RepositoryResult uploadImageResult;
    if (hasProfileImage) {
      uploadImageResult = await _userRepository
          .postUpdateProfileImage(UploadImage.forApi(base64Image));
    } else {
      uploadImageResult = await _userRepository
          .postProfileImage(UploadImage.forApi(base64Image));
    }

    if (uploadImageResult is RepositoryErrorResult) {
      final errorResult = uploadImageResult;
      emit(RegisterImageScreenFailureState(errorResult.error.message));
      return;
    }

    emit(RegisterImageScreenFinishState());
  }
}
