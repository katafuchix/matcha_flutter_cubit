import 'package:flutter/material.dart';

import '../../core/app_info.dart';
import '../../core/colors.dart';
import '../../core/my_platform.dart';
import 'texts.dart';

Widget buildSeparator() {
  return const SizedBox(height: 32);
}

Widget borderLine() {
  return Container(
    color: getAppColors().divider,
    height: 1,
  );
  return Divider(
    height: 0,
    thickness: 1,
    color: getAppColors().divider,
  );
}

Widget settingLabel(String text) {
  return Padding(
    padding: EdgeInsets.only(left: 16, bottom: 16),
    child: buildSmallerText(text, colors: TextColors.SECONDARY_TEXT),
  );
}

Widget settingButton(
    {required String text,
    VoidCallback? action,
    bool? visibleForward,
    void Function(bool value)? onChanged,
    String? currentValue}) {
  return Builder(
    builder: (context) {
      return Container(
        height: 48,
        width: double.infinity,
        child: Material(
          child: InkWell(
            onTap: action,
            child: Padding(
              padding: EdgeInsets.only(left: 16, right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: AppInfo.getAppWidth(context) / 2,
                    child: buildNormalText(text, maxLines: 1),
                  ),
                  Container(
                    width: AppInfo.getAppWidth(context) / 3,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: _buildSwitchOrForwardOrValue(
                          onChanged: onChanged,
                          visibleForward: visibleForward,
                          value: currentValue),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

Widget _buildSwitchOrForwardOrValue(
    {void Function(bool value)? onChanged,
    bool? visibleForward,
    String? value}) {
  if (visibleForward == true) {
    // 矢印 (タップでページ遷移)
    return _buildForward();
  }
  if (onChanged != null) {
    // スイッチ
    return Container(
      child: Switch(
        value: true,
        onChanged: (bool value) => onChanged(value),
      ),
    );
  }
  if (value != null) {
    return Container(
      child: buildNormalText(value.replaceAll('\n', ''), maxLines: 1),
    );
  }
  // 何も表示しない
  return Container();
}

Widget _buildForward() {
  if (MyPlatform.isIOS) {
    return Container(
      child: Padding(
        padding: EdgeInsets.only(right: 8),
        child: Icon(Icons.arrow_forward_ios, color: Colors.grey),
      ),
    );
  } else {
    return Container();
  }
}
