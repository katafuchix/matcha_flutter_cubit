import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../components/widget_circular_progress.dart';

abstract class BaseStatefulWidget extends StatefulWidget {
  const BaseStatefulWidget({super.key});
}

abstract class BaseState<T extends BaseStatefulWidget> extends State<T>
    with WidgetsBindingObserver {
  BlocBase? bloc;
  BaseState([this.bloc]);

  bool _showingProgress = false;

  @protected
  @mustCallSuper
  void onResume() {}

  @protected
  @mustCallSuper
  void onPaused() {}

  @protected
  @mustCallSuper
  void onInactive() {}

  @protected
  @mustCallSuper
  void onDetached() {}

  @protected
  @mustCallSuper
  void onBuildWidget() {}

  @mustCallSuper
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) => onBuildWidget());
    super.initState();
  }

  @mustCallSuper
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    bloc?.close();
    super.dispose();
  }

  @mustCallSuper
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        onResume();
        break;
      case AppLifecycleState.inactive:
        onInactive();
        break;
      case AppLifecycleState.paused:
        onPaused();
        break;
      case AppLifecycleState.detached:
        onDetached();
        break;
      case AppLifecycleState.hidden:
        break;
    }
  }

  @protected
  void showProgress(BuildContext context) {
    _showingProgress = true;
    showCircularProgress(context);
  }

  @protected
  void closeProgressIfNeed(BuildContext context) {
    if (_showingProgress) {
      _showingProgress = false;
      closeCircularProgress(context);
    }
  }
}
