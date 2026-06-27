import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/app_info.dart';
import '../../../core/colors.dart';
import '../../../core/event_tracking.dart';
import '../../../core/my_logger.dart';
import '../../../model/master/master_data.dart';
import '../../../model/search_condition/search_condition.dart';
import '../../../repository/master_repository.dart';
import '../../app.dart';
import '../../base/base_stateful_widget.dart';
import '../../components/buttons.dart';
import '../../components/texts.dart';
import '../../helper/repository_handler.dart';
import '../../my_navigator.dart';
import '../home/app_bars.dart';
import 'multi_choice_screen.dart';

class _SearchConditionScreenArgs {
  final bool showSexField;
  final SearchCondition currentCondition;

  _SearchConditionScreenArgs(this.showSexField, this.currentCondition);
}

class SearchConditionScreen extends BaseStatefulWidget {
  static final _keyArgs = 'key_profile_args';

  SearchConditionScreen({required ScreenArgs args}) : super(args: args);

  static ScreenArgs createScreenArgs(
      {bool showSexField = true, required SearchCondition currentCondition}) {
    ScreenArgs args = ScreenArgs()
      ..put(
        _keyArgs,
        _SearchConditionScreenArgs(showSexField, currentCondition),
      );
    return args;
  }

  @override
  State<StatefulWidget> createState() {
    final _SearchConditionScreenArgs screenArgs = getArgs();
    return _SearchConditionState(screenArgs.currentCondition);
  }

  @override
  String getArgsKey() {
    return _keyArgs;
  }
}

class IntRangeItem {
  List<int> items;
  int? minIndex;
  int? maxIndex;
  String? Function(int? item) converter;

  IntRangeItem(
      {required this.items,
      this.minIndex,
      this.maxIndex,
      required this.converter});
}

class _SearchConditionState extends BaseState<SearchConditionScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final MasterRepository _masterRepository = MasterRepository();
  final AppColors _colors = getAppColors();
  final SearchCondition currentCondition;
  final List<MultiChoiceOneItem> _bloodMaster = [];
  final List<MultiChoiceOneItem> _holidayMaster = [];
  final List<MultiChoiceOneItem> _jobMaster = [];
  final List<MultiChoiceOneItem> _animalMaster = [];
  final List<MultiChoiceOneItem> _hobbyMaster = [];
  final IntRangeItem _ageItems = IntRangeItem(
      items: List<int>.generate(83, (i) => i + 18),
      converter: (int? item) => item == null ? null : '$item歳');
  final IntRangeItem _heightItems = IntRangeItem(
      items: List<int>.generate(71, (i) => i + 130),
      converter: (int? item) => item == null ? null : '${item}cm');

  _SearchConditionState(this.currentCondition) : super(null);

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future _load() async {
    List<OnResultHandler> handlerList = [
      OnResultHandler(await _masterRepository.getBloodMaster(),
          onSuccess: (value) {
        if (value is List<MasterData>) {
          _bloodMaster.addAll(value
              .map((e) => MultiChoiceOneItem(e.id, e.name, false))
              .toList());
        }
      }),
      OnResultHandler(await _masterRepository.getHolidayMaster(),
          onSuccess: (value) {
        if (value is List<MasterData>) {
          _holidayMaster.addAll(value
              .map((e) => MultiChoiceOneItem(e.id, e.name, false))
              .toList());
        }
      }),
      OnResultHandler(await _masterRepository.getJobMaster(),
          onSuccess: (value) {
        if (value is List<MasterData>) {
          _jobMaster.addAll(value
              .map((e) => MultiChoiceOneItem(e.id, e.name, false))
              .toList());
        }
      }),
      OnResultHandler(await _masterRepository.getAnimalMaster(),
          onSuccess: (value) {
        if (value is List<MasterData>) {
          _animalMaster.addAll(value
              .map((e) => MultiChoiceOneItem(e.id, e.name, false))
              .toList());
        }
      }),
      OnResultHandler(await _masterRepository.getHobbyMaster(),
          onSuccess: (value) {
        if (value is List<MasterData>) {
          _hobbyMaster.addAll(value
              .map((e) => MultiChoiceOneItem(e.id, e.name, false))
              .toList());
        }
      }),
    ];

    RepositoryHandler.handleMultipleRepositoryResult(context, handlerList);
    restoreSearchCondition();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return _buildMainWidget();
  }

  Widget _buildMainWidget() {
    return SafeArea(
        top: false,
        child: Scaffold(
            key: _scaffoldKey,
            appBar: buildNormalAppBar(context, '絞り込み'),
            body: _buildMainBody()));
  }

  Widget _buildMainBody() {
    return Column(
      children: [
        Expanded(
            child: ListView(
          children: [
            // 1つ選択 男　女　指定しない(null)
            // Text('性別'),
            // 範囲指定
            _buildRangeChoiceItem('年齢', _ageItems),
            // 複数指定
            _buildMultiChoiceItem('血液型', _bloodMaster),
            // 範囲指定
            _buildRangeChoiceItem('身長', _heightItems),
            // 複数指定
            _buildMultiChoiceItem('休日', _holidayMaster),
            // 複数指定
            _buildMultiChoiceItem('仕事', _jobMaster),
            // 複数指定
            _buildMultiChoiceItem('動物に例えると', _animalMaster),
            // 複数指定
            _buildMultiChoiceItem('趣味・マイブーム', _hobbyMaster),
          ],
        )),
        Padding(
          padding: EdgeInsets.all(16),
          child: buildSettingHorizontalFullSizeButton(
              onPressed: () {
                Navigator.pop(
                    context,
                    SearchCondition.fromParam(
                      ageMin:
                          _ageItems.minIndex == null || _ageItems.minIndex! < 0
                              ? null
                              : _ageItems.items[_ageItems.minIndex!],
                      ageMax:
                          _ageItems.maxIndex == null || _ageItems.maxIndex! < 0
                              ? null
                              : _ageItems.items[_ageItems.maxIndex!],
                      heightMin: _heightItems.minIndex == null ||
                              _heightItems.minIndex! < 0
                          ? null
                          : _heightItems.items[_heightItems.minIndex!],
                      heightMax: _heightItems.maxIndex == null ||
                              _heightItems.maxIndex! < 0
                          ? null
                          : _heightItems.items[_heightItems.maxIndex!],
                      userProfileBloodIn: _bloodMaster
                          .where((element) => element.selected)
                          .map((e) => e.id)
                          .toList(),
                      userProfileProfHolidayIdIn: _holidayMaster
                          .where((element) => element.selected)
                          .map((e) => e.id)
                          .toList(),
                      userProfileProfJobIdIn: _jobMaster
                          .where((element) => element.selected)
                          .map((e) => e.id)
                          .toList(),
                      userProfileProfAnimalIdIn: _animalMaster
                          .where((element) => element.selected)
                          .map((e) => e.id)
                          .toList(),
                      userProfileProfHobbyIdIn: _hobbyMaster
                          .where((element) => element.selected)
                          .map((e) => e.id)
                          .toList(),
                    ));
                AppEvent.sendRefinedResearchEvent();
              },
              label: '完了'),
        )
      ],
    );
  }

  Widget _buildMultiChoiceItem(
      final String title, final List<MultiChoiceOneItem> items) {
    // ハードコピーしておく
    final List<MultiChoiceOneItem> newItemsList = List.generate(
        items.length,
        (index) => MultiChoiceOneItem(
            items[index].id, items[index].label, items[index].selected));
    return InkWell(
      onTap: () async {
        final result = await MyNavigator.pushNamed(context, Routes.multiChoice,
            arguments: MultiChoiceScreen.createScreenArgs(title, newItemsList));
        if (result is MultiChoiceScreenResult) {
          MyLogger.d(result);
          // この関数の引数は、メンバー変数を受け取っている想定
          // メンバー変数の中身だけを更新する
          items.forEach((src) {
            src.selected =
                result.selectedItems.firstWhere((e) => e.id == src.id).selected;
          });
          setState(() {});
        }
      },
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [buildNormalText(title), _buildPreviewText(items)],
        ),
      ),
    );
  }

  Widget _buildRangeChoiceItem(String title, IntRangeItem result) {
    return InkWell(
      onTap: () async {
        // TODO
        _showRangePicker(
            title,
            result.items
                .map((e) => result.converter(e) as String)
                .toList(),
            result);
      },
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            buildNormalText(title),
            _buildPreviewTextFromRange(
                result.converter(result.minIndex == null || result.minIndex! < 0
                    ? null
                    : result.items[result.minIndex!]),
                result.converter(result.maxIndex == null || result.maxIndex! < 0
                    ? null
                    : result.items[result.maxIndex!]))
          ],
        ),
      ),
    );
  }

  Widget _buildPreviewText(List<MultiChoiceOneItem> items) {
    StringBuffer sb = StringBuffer();
    items.where((element) => element.selected).forEach((element) {
      sb.write('${element.label},');
    });
    if (sb.isEmpty)
      return Container();
    else {
      final String text = sb.toString().substring(0, sb.toString().length - 1);
      return Container(
        width: AppInfo.getAppWidth(context) / 3,
        child: Align(
          alignment: Alignment.centerRight,
          child: buildNormalText(text, maxLines: 1),
        ),
      );
    }
  }

  Widget _buildPreviewTextFromRange(String? minText, String? maxText) {
    if (minText == null && maxText == null) {
      return Container();
    }

    String min = minText ?? '選択しない';
    String max = maxText ?? '選択しない';

    final String text = '$min 〜 $max';
    return Container(
      width: AppInfo.getAppWidth(context) / 3,
      child: Align(
        alignment: Alignment.centerRight,
        child: buildNormalText(text, maxLines: 1),
      ),
    );
  }

  Future _showRangePicker(
      String title, List<String> items, IntRangeItem result) async {
    final list = ['選択しない', ...items];
    int minSel = result.minIndex == null ? 0 : result.minIndex! + 1;
    int maxSel = result.maxIndex == null ? 0 : result.maxIndex! + 1;

    await showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return SizedBox(
          height: 320,
          child: Column(
            children: [
              Container(
                color: _colors.primary,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: Text('キャンセル',
                          style: TextStyle(color: _colors.textOrIcons)),
                    ),
                    Text(title,
                        style: TextStyle(
                            color: _colors.textOrIcons, fontSize: 16)),
                    TextButton(
                      onPressed: () {
                        result.minIndex = minSel == 0 ? null : minSel - 1;
                        result.maxIndex = maxSel == 0 ? null : maxSel - 1;
                        setState(() {});
                        Navigator.of(ctx).pop();
                      },
                      child: Text('完了',
                          style: TextStyle(color: _colors.textOrIcons)),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: CupertinoPicker(
                        scrollController:
                            FixedExtentScrollController(initialItem: minSel),
                        itemExtent: 40,
                        onSelectedItemChanged: (i) => minSel = i,
                        children: list
                            .map((n) => Center(
                                  child: Text(n,
                                      style: TextStyle(
                                          color: _colors.primaryText,
                                          fontSize: 16)),
                                ))
                            .toList(),
                      ),
                    ),
                    Expanded(
                      child: CupertinoPicker(
                        scrollController:
                            FixedExtentScrollController(initialItem: maxSel),
                        itemExtent: 40,
                        onSelectedItemChanged: (i) => maxSel = i,
                        children: list
                            .map((n) => Center(
                                  child: Text(n,
                                      style: TextStyle(
                                          color: _colors.primaryText,
                                          fontSize: 16)),
                                ))
                            .toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  restoreSearchCondition() {
    // 範囲系の検索条件を反映
    if (currentCondition.ageRange != null) {
      _ageItems.minIndex = _ageItems.items
          .indexOf(int.parse(currentCondition.ageRange!.split('..')[0]));
      _ageItems.maxIndex = _ageItems.items
          .indexOf(int.parse(currentCondition.ageRange!.split('..')[1]));
    }

    if (currentCondition.userProfileHeightIn != null) {
      _heightItems.minIndex = _heightItems.items.indexOf(
          int.parse(currentCondition.userProfileHeightIn!.split('..')[0]));
      _heightItems.maxIndex = _heightItems.items.indexOf(
          int.parse(currentCondition.userProfileHeightIn!.split('..')[1]));
    }

    // チェックボックス系の検索条件を反映

    // 血液型
    if (currentCondition.userProfileBloodIn != null) {
      restoreMultiChoiceItems(
          _bloodMaster, currentCondition.userProfileBloodIn!);
    }
    // 休日
    if (currentCondition.userProfileProfHolidayIdIn != null) {
      restoreMultiChoiceItems(
          _holidayMaster, currentCondition.userProfileProfHolidayIdIn!);
    }
    // 仕事
    if (currentCondition.userProfileProfJobIdIn != null) {
      restoreMultiChoiceItems(
          _jobMaster, currentCondition.userProfileProfJobIdIn!);
    }
    // 動物に例えると
    if (currentCondition.userProfileProfAnimalIdIn != null) {
      restoreMultiChoiceItems(
          _animalMaster, currentCondition.userProfileProfAnimalIdIn!);
    }
    // マイブーム
    if (currentCondition.userProfileProfHobbyIdIn != null) {
      restoreMultiChoiceItems(
          _hobbyMaster, currentCondition.userProfileProfHobbyIdIn!);
    }
  }

  restoreMultiChoiceItems(
      List<MultiChoiceOneItem> items, String searchConditionFields) {
    final enableList = searchConditionFields.split(',').map((e) {
      try {
        return int.parse(e);
      } catch (_) {
        return null;
      }
    }).where((element) => element != null);
    // この関数の引数は、メンバー変数を受け取っている想定
    // メンバー変数の中身だけを更新する
    items.forEach((element) {
      element.selected = enableList.contains(element.id) == true;
    });
  }
}
