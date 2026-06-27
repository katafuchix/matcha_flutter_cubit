import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../core/my_platform.dart';
import 'containers.dart';
import 'texts.dart';

enum DialogResult { OK, CANCEL }

Future<DialogResult?> showAlertDialog(BuildContext context,
    {required String message,
    String? title,
    bool cancelable = true,
    VoidCallback? onOk,
    String okLabel = 'OK',
    String cancelLabel = 'キャンセル',
    VoidCallback? onCancel}) {
  return showDialog(
      context: context,
      builder: (context) {
        if (cancelable) {
          if (MyPlatform.isIOS) {
            return _showOkCancelDialogForIOs(context, message,
                title: title,
                onOk: onOk,
                onCancel: onCancel,
                okLabel: okLabel,
                cancelLabel: cancelLabel);
          } else {
            return _showOkCancelDialogForAndroid(context, message,
                title: title,
                onOk: onOk,
                onCancel: onCancel,
                okLabel: okLabel,
                cancelLabel: cancelLabel);
          }
        } else {
          if (MyPlatform.isIOS) {
            return _showOkDialogForIOs(context, message,
                title: title, onOk: onOk, okLabel: okLabel);
          } else {
            return PopScope(
                canPop: false,
                child: _showOkDialogForAndroid(context, message,
                    title: title, onOk: onOk, okLabel: okLabel));
          }
        }
      },
      barrierDismissible: false);
}

Future<DialogResult?> showErrorDialog(
    BuildContext context, String errorMessage) {
  return showAlertDialog(context,
      title: 'エラー', message: errorMessage, cancelable: false);
}

Future<DialogResult?> showCustomDialog(
    {required BuildContext context,
    required Widget Function(BuildContext context, StateSetter setState)
        builder,
    bool barrierDismissible = true}) {
  Widget w;
  if (barrierDismissible == true) {
    w = StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
      return AlertDialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        content: SingleChildScrollView(
          child: Container(
              width: calcContainerWidth(context) * 0.8,
              child: builder(context, setState)),
        ),
      );
    });
  } else {
    // 戻るボタンで消えるのを防ぐ
    w = StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
      return AlertDialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        content: SingleChildScrollView(
          child: Container(
              width: calcContainerWidth(context) * 0.8,
              child: PopScope(
                canPop: false,
                child: builder(context, setState),
              )),
        ),
      );
    });
  }
  return showDialog(
      context: context,
      builder: (context) {
        return w;
      },
      barrierDismissible: barrierDismissible);
}

Widget _showOkCancelDialogForAndroid(BuildContext context, String message,
    {String? title,
    String okLabel = 'OK',
    String cancelLabel = 'キャンセル',
    VoidCallback? onOk,
    VoidCallback? onCancel}) {
  return AlertDialog(
    title: title == null ? null : buildH3Text(title),
    content: buildNormalText(message),
    actions: [
      TextButton(
          onPressed: () {
            onCancel?.call();
            Navigator.of(context).pop(DialogResult.CANCEL);
          },
          child: buildNormalText(cancelLabel)),
      TextButton(
          onPressed: () {
            onOk?.call();
            Navigator.of(context).pop(DialogResult.OK);
          },
          child: buildNormalText(okLabel)),
    ],
  );
}

Widget _showOkCancelDialogForIOs(BuildContext context, String message,
    {String? title,
    String okLabel = 'OK',
    String cancelLabel = 'キャンセル',
    VoidCallback? onOk,
    VoidCallback? onCancel}) {
  return CupertinoAlertDialog(
    title: title == null ? null : buildH3Text(title),
    content: buildNormalText(message),
    actions: [
      TextButton(
          onPressed: () {
            onCancel?.call();
            Navigator.of(context).pop(DialogResult.CANCEL);
          },
          child: buildNormalText(cancelLabel)),
      TextButton(
          onPressed: () {
            onOk?.call();
            Navigator.of(context).pop(DialogResult.OK);
          },
          child: buildNormalText(okLabel)),
    ],
  );
}

Widget _showOkDialogForAndroid(BuildContext context, String message,
    {String? title, String okLabel = 'OK', VoidCallback? onOk}) {
  return AlertDialog(
    title: title == null ? null : buildH3Text(title),
    content: buildNormalText(message),
    actions: [
      TextButton(
          onPressed: () {
            onOk?.call();
            Navigator.of(context).pop(DialogResult.OK);
          },
          child: buildNormalText(okLabel)),
    ],
  );
}

Widget _showOkDialogForIOs(BuildContext context, String message,
    {String? title, String okLabel = 'OK', VoidCallback? onOk}) {
  return CupertinoAlertDialog(
    title: title == null ? null : buildH3Text(title),
    content: buildNormalText(message),
    actions: [
      TextButton(
          onPressed: () {
            onOk?.call();
            Navigator.of(context).pop(DialogResult.OK);
          },
          child: buildNormalText(okLabel)),
    ],
  );
}
