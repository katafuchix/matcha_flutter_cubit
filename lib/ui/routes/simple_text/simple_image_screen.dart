import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../base/base_stateful_widget.dart';
import '../../components/containers.dart';
import '../../my_navigator.dart';
import '../home/app_bars.dart';

class _SimpleImageScreenArgs {
  final String title;
  final String? url;
  final Uint8List? image;

  _SimpleImageScreenArgs(this.title, {this.url, this.image});
}

class SimpleImageScreen extends BaseStatefulWidget {
  static final _keyArgs = 'key_profile_args';

  SimpleImageScreen({required ScreenArgs args}) : super(args: args);

  static ScreenArgs createScreenArgs(String title,
      {String? url, Uint8List? image}) {
    ScreenArgs args = ScreenArgs()
      ..put(_keyArgs, _SimpleImageScreenArgs(title, url: url, image: image));
    return args;
  }

  @override
  State<StatefulWidget> createState() {
    final _SimpleImageScreenArgs screenArgs = getArgs();
    return _SimpleTextScreen(screenArgs.title,
        url: screenArgs.url, image: screenArgs.image);
  }

  @override
  String getArgsKey() {
    return _keyArgs;
  }
}

class _SimpleTextScreen extends BaseState<SimpleImageScreen> {
  final String title;
  final String? url;
  final Uint8List? image;
  _SimpleTextScreen(this.title, {this.url, this.image}) : super(null);

  @override
  Widget build(BuildContext context) {
    assert(url != null || this.image != null);
    Image image;
    if (url != null) {
      image = Image.network(url!);
    } else if (this.image != null) {
      image = Image.memory(this.image!);
    } else {
      throw Error();
    }
    return SafeArea(
        top: false,
        child: Containers.createScreenContainer(
            context,
            Scaffold(
              appBar: buildNormalAppBar(context, title),
              body: Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: image,
                ),
              ),
            )));
  }
}
