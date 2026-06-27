import 'package:flutter/material.dart';

import '../../core/colors.dart';
import '../../core/my_logger.dart';
import 'texts.dart';

BorderSide get _borderSide =>
    BorderSide(color: getAppColors().primaryDark, width: 2);

enum KeyboardNextAction { NEXT_FOCUS, DONE }

Widget buildPlainTextField(
    BuildContext context, TextEditingController controller,
    {TextAlign? textAlign,
    TextHeight? height,
    TextInputType inputType = TextInputType.name,
    KeyboardNextAction? action,
    ValueChanged<String>? onChanged,
    bool multiline = false}) {
  return _buildBaseTextField(context, controller,
      inputType: inputType,
      action: action,
      onChanged: onChanged,
      multiline: multiline);
}

Widget buildPasswordTextField(
    BuildContext context, TextEditingController controller,
    {TextAlign? textAlign,
    TextInputType inputType = TextInputType.visiblePassword,
    KeyboardNextAction? action,
    required ValueChanged<String> onChanged,
    bool? showPassword,
    VoidCallback? onTapSuffixIcon}) {
  return _buildBaseTextField(context, controller,
      inputType: inputType,
      action: action,
      onChanged: onChanged,
      showPassword: showPassword,
      onTapSuffixIcon: onTapSuffixIcon);
}

Widget _buildBaseTextField(
    BuildContext context, TextEditingController controller,
    {TextAlign textAlign = TextAlign.start,
    TextHeight? height,
    TextInputType inputType = TextInputType.name,
    KeyboardNextAction? action,
    ValueChanged<String>? onChanged,
    bool? showPassword,
    VoidCallback? onTapSuffixIcon,
    bool multiline = false}) {
  final node = FocusScope.of(context);

  KeyboardNextAction a = KeyboardNextAction.DONE;
  if (action != null) {
    a = action;
  }

  // アイコン
  Widget? suffixIcon;
  if (showPassword != null) {
    suffixIcon = IconButton(
      icon: Icon(showPassword ? Icons.visibility : Icons.visibility_off),
      onPressed: onTapSuffixIcon,
    );
  }

  // パスワードマスク
  bool obscureText = false;
  if (showPassword != null) {
    obscureText = !showPassword;
  }

  InputDecoration inputDecoration;
  TextInputAction textInputAction;
  int? maxLine = 1;

  if (multiline) {
    inputDecoration = InputDecoration(
        enabledBorder: OutlineInputBorder(borderSide: _borderSide),
        focusedBorder: OutlineInputBorder(borderSide: _borderSide),
        contentPadding: EdgeInsets.all(8));
    inputType = TextInputType.multiline;
    textInputAction = TextInputAction.newline;
    maxLine = null;
  } else {
    inputDecoration = InputDecoration(
        enabledBorder: UnderlineInputBorder(borderSide: _borderSide),
        suffixIcon: suffixIcon);
    textInputAction = a == KeyboardNextAction.NEXT_FOCUS
        ? TextInputAction.next
        : TextInputAction.done;
  }

  return TextField(
      textAlign: textAlign,
      controller: controller,
      style: createAppTextStyle(height: height),
      cursorColor: getAppColors().primary,
      onChanged: onChanged,
      decoration: inputDecoration,
      keyboardType: inputType,
      obscureText: obscureText,
      textInputAction: textInputAction,
      maxLines: maxLine,
      onEditingComplete: () {
        if (a == KeyboardNextAction.NEXT_FOCUS) {
          bool result = node.nextFocus();
          MyLogger.d('node.nextFocus() = $result');
        } else {
          node.unfocus();
        }
      });
}
