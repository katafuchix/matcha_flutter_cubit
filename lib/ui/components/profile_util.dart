import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../core/asseet_enum.dart';
import '../../core/colors.dart';
import '../../model/basic/sex.dart';
import '../../model/master/master_data.dart';
import '../../model/user/profile_image.dart';
import 'image_loader.dart';

void showMasterDataPicker(
    BuildContext context,
    GlobalKey<ScaffoldState> scaffoldKey,
    List<MasterData> items,
    String? currentValue,
    Function(int newIndex) onChanged) {
  final AppColors colors = getAppColors();
  items.sort((a, b) => (a.sortOrder ?? 0) - (b.sortOrder ?? 0));
  final nameList = items.map((e) => e.name).toList();
  final initialIndex =
      (currentValue == null ? 0 : nameList.indexOf(currentValue))
          .clamp(0, nameList.length - 1);
  int selectedIndex = initialIndex;

  showModalBottomSheet(
    context: context,
    builder: (ctx) => _PickerSheet(
      colors: colors,
      onConfirm: () => onChanged(selectedIndex),
      child: CupertinoPicker(
        scrollController:
            FixedExtentScrollController(initialItem: initialIndex),
        itemExtent: 40,
        onSelectedItemChanged: (i) => selectedIndex = i,
        children: nameList
            .map((n) => Center(
                  child: Text(n,
                      style: TextStyle(
                          color: colors.primaryText, fontSize: 16)),
                ))
            .toList(),
      ),
    ),
  );
}

void showStringListPicker(
    BuildContext context,
    GlobalKey<ScaffoldState> scaffoldKey,
    List<String> items,
    String currentValue,
    Function(int newIndex) onChanged) {
  final AppColors colors = getAppColors();
  final initialIndex = items.indexOf(currentValue).clamp(0, items.length - 1);
  int selectedIndex = initialIndex;

  showModalBottomSheet(
    context: context,
    builder: (ctx) => _PickerSheet(
      colors: colors,
      onConfirm: () => onChanged(selectedIndex),
      child: CupertinoPicker(
        scrollController:
            FixedExtentScrollController(initialItem: initialIndex),
        itemExtent: 40,
        onSelectedItemChanged: (i) => selectedIndex = i,
        children: items
            .map((n) => Center(
                  child: Text(n,
                      style: TextStyle(
                          color: colors.primaryText, fontSize: 16)),
                ))
            .toList(),
      ),
    ),
  );
}

class _PickerSheet extends StatelessWidget {
  final AppColors colors;
  final VoidCallback onConfirm;
  final Widget child;

  const _PickerSheet(
      {required this.colors,
      required this.onConfirm,
      required this.child});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Column(
        children: [
          Container(
            color: colors.primary,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('キャンセル',
                      style: TextStyle(color: colors.textOrIcons)),
                ),
                TextButton(
                  onPressed: () {
                    onConfirm();
                    Navigator.of(context).pop();
                  },
                  child:
                      Text('完了', style: TextStyle(color: colors.textOrIcons)),
                ),
              ],
            ),
          ),
          Expanded(child: child),
        ],
      ),
    );
  }
}

Widget buildProfileImage(
    {required double width,
    required double height,
    required Sex sex,
    List<ProfileImage>? images}) {
  Widget? i;
  if (images?.isNotEmpty == true) {
    final image = ImageLoader.apiUrlToFullPath(images!.first.image);
    if (image != null) {
      i = ExtendedImage.network(
        image,
        width: width,
        height: height,
        fit: BoxFit.contain,
        cache: true,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
      );
    }
  }
  if (i == null) {
    if (sex == Sex.Male) {
      i = Image.asset(
        AssetEnum.MALE.path,
        width: width,
        height: height,
      );
    } else {
      i = Image.asset(
        AssetEnum.FEMALE.path,
        width: width,
        height: height,
      );
    }
  }
  return SizedBox(
      height: height,
      width: width,
      child: Container(
        child: ClipRRect(borderRadius: BorderRadius.circular(8.0), child: i),
      ));
}
