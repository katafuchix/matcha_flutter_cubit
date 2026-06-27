import 'package:flutter/material.dart';

import '../../core/colors.dart';
import '../../core/constants.dart';
import '../../core/my_platform.dart';

class Containers {
  static Widget createScreenContainer(BuildContext context, Widget child) {
    final double maxWidth = MAX_APP_WIDTH;
    final double displayWidth = MediaQuery.of(context).size.width;
    if (displayWidth <= maxWidth || MyPlatform.isMobileApp) {
      return child;
    } else {
      return Container(
        color: getAppColors().secondaryBg,
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: (displayWidth - maxWidth) / 2.0),
          child: child,
        ),
      );
    }
  }
}

double calcContainerWidth(BuildContext context) {
  final double maxWidth = MAX_APP_WIDTH;
  final double displayWidth = MediaQuery.of(context).size.width;
  if (displayWidth <= maxWidth) {
    return displayWidth;
  }
  return maxWidth;
}
