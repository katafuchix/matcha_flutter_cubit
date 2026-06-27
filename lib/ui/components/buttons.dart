import 'package:flutter/material.dart';

import '../../core/colors.dart';
import 'texts.dart';

Widget buildTextButton(
    {required VoidCallback? onPressed, required String label}) {
  return TextButton(
    child: buildSmallerText(label, colors: TextColors.PRIMARY),
    onPressed: onPressed,
  );
}

Widget buildNormalButton(
    {required VoidCallback? onPressed,
    required String label,
    bool alert = false}) {
  AppColors colors = getAppColors();
  if (alert) {
    return ElevatedButton(
      child: buildNormalText(label, colors: TextColors.WHITE),
      style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
      onPressed: onPressed,
    );
  }
  return ElevatedButton(
    child: buildNormalText(label, colors: TextColors.WHITE),
    style: ElevatedButton.styleFrom(backgroundColor: colors.primary),
    onPressed: onPressed,
  );
}

Widget buildSettingHorizontalFullSizeButton(
    {required VoidCallback? onPressed, required String label}) {
  return Container(
    width: double.infinity,
    height: 48,
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          backgroundColor: getAppColors().primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          )),
      child: buildNormalText(label, colors: TextColors.WHITE),
    ),
  );
}
