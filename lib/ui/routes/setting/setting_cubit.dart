import '../../base/base_cubit.dart';
import 'setting_screen.dart';

// ============================================================================
// State
// ============================================================================
abstract class SettingScreenState {}

abstract class SettingScreenWidgetState extends SettingScreenState {}

class SettingScreenInitialState extends SettingScreenWidgetState {}

class SettingScreenLoadingState extends SettingScreenState {}

class SettingScreenLoadedViewDataState extends SettingScreenWidgetState {
  final SettingScreenViewData viewData;
  SettingScreenLoadedViewDataState(this.viewData);
}

class SettingScreenFailureState extends SettingScreenState {
  String errorMessage;
  SettingScreenFailureState(this.errorMessage);
}

class SettingScreenFinishState extends SettingScreenState {
  final SettingScreenResult result;
  SettingScreenFinishState(this.result);
}
// ////////////////////////////////////////////////////////////////////////////

class SettingScreenCubit extends BaseCubit<SettingScreenState> {
  SettingScreenCubit() : super(SettingScreenInitialState());

  Future<void> init() async {
    emit(SettingScreenLoadedViewDataState(SettingScreenViewData('your name')));
  }

  Future<void> doSomething1(String value1, String value2) async {
    emit(SettingScreenLoadingState());

    // TODO 実装

    emit(SettingScreenLoadedViewDataState(SettingScreenViewData('new name')));
  }

  Future<void> doSomething2() async {
    emit(SettingScreenLoadingState());

    // TODO 実装

    emit(SettingScreenLoadedViewDataState(SettingScreenViewData('new name')));
  }
}
