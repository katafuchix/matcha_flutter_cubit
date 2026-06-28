import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../base/base_stateful_widget.dart';
import '../../components/containers.dart';
import '../home/app_bars.dart';

class SimpleImageScreen extends BaseStatefulWidget {
  final String title;
  final String? url;
  final Uint8List? image;

  const SimpleImageScreen({required this.title, this.url, this.image});

  @override
  State<StatefulWidget> createState() =>
      _SimpleImageScreen(title, url: url, image: image);
}

class _SimpleImageScreen extends BaseState<SimpleImageScreen> {
  final String title;
  final String? url;
  final Uint8List? image;

  _SimpleImageScreen(this.title, {this.url, this.image}) : super();

  @override
  Widget build(BuildContext context) {
    assert(url != null || image != null);
    final img = url != null ? Image.network(url!) : Image.memory(image!);
    return SafeArea(
        top: false,
        child: Containers.createScreenContainer(
            context,
            Scaffold(
              appBar: buildNormalAppBar(context, title),
              body: Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: img,
                ),
              ),
            )));
  }
}
