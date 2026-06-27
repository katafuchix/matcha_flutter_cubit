import 'package:flutter/material.dart';

import '../../base/base_stateful_widget.dart';
import '../../components/containers.dart';
import '../../components/texts.dart';
import '../../my_navigator.dart';
import '../home/app_bars.dart';

class _SimpleTextScreenArgs {
  final String title;
  final String text;

  _SimpleTextScreenArgs(this.title, this.text);
}

class SimpleTextScreen extends BaseStatefulWidget {
  static final _keyArgs = 'key_profile_args';

  SimpleTextScreen({required ScreenArgs args}) : super(args: args);

  static ScreenArgs createScreenArgs(String title, String text) {
    ScreenArgs args = ScreenArgs()
      ..put(_keyArgs, _SimpleTextScreenArgs(title, text));
    return args;
  }

  @override
  State<StatefulWidget> createState() {
    final _SimpleTextScreenArgs screenArgs = getArgs();
    return _SimpleTextScreen(screenArgs.title, screenArgs.text);
  }

  @override
  String getArgsKey() {
    return _keyArgs;
  }
}

class _SimpleTextScreen extends BaseState<SimpleTextScreen> {
  final String title;
  final String text;

  _SimpleTextScreen(this.title, this.text) : super(null);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        top: false,
        child: Containers.createScreenContainer(
            context,
            Scaffold(
              appBar: buildNormalAppBar(context, title),
              body: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: buildNormalText(text, maxLines: 100000000),
                ),
              ),
            )));
  }
}
