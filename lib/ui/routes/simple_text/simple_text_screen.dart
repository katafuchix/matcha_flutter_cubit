import 'package:flutter/material.dart';

import '../../base/base_stateful_widget.dart';
import '../../components/containers.dart';
import '../../components/texts.dart';
import '../home/app_bars.dart';

class SimpleTextScreen extends BaseStatefulWidget {
  final String title;
  final String text;

  const SimpleTextScreen({required this.title, required this.text});

  @override
  State<StatefulWidget> createState() => _SimpleTextScreen(title, text);
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
