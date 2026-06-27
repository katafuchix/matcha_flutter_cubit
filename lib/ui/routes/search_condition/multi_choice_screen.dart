import 'package:flutter/material.dart';

import '../../base/base_stateful_widget.dart';
import '../../components/buttons.dart';
import '../../my_navigator.dart';
import '../home/app_bars.dart';

class MultiChoiceOneItem {
  int id;
  String label;
  bool selected;
  MultiChoiceOneItem(this.id, this.label, this.selected);

  @override
  String toString() => '{id : $id, label : $label, selected : $selected}';
}

class MultiChoiceScreenResult {
  List<MultiChoiceOneItem> selectedItems;
  MultiChoiceScreenResult(this.selectedItems);

  @override
  String toString() => '{selectedItems : $selectedItems}';
}

class _MultiChoiceScreenArgs {
  final String title;
  final List<MultiChoiceOneItem> items;
  // キャンセル時に呼び出し側の値が変わらないよう、ハードコピーしておく
  _MultiChoiceScreenArgs(this.title, List<MultiChoiceOneItem> items)
      : this.items = List.generate(
            items.length,
            (index) => MultiChoiceOneItem(
                items[index].id, items[index].label, items[index].selected));
}

class MultiChoiceScreen extends BaseStatefulWidget {
  static final _keyArgs = 'key_profile_args';

  MultiChoiceScreen({required ScreenArgs args}) : super(args: args);

  static ScreenArgs createScreenArgs(
      String title, List<MultiChoiceOneItem> items) {
    ScreenArgs args = ScreenArgs()
      ..put(
        _keyArgs,
        _MultiChoiceScreenArgs(title, items),
      );
    return args;
  }

  @override
  State<StatefulWidget> createState() {
    final _MultiChoiceScreenArgs screenArgs = getArgs();
    return _MultiChoiceState(screenArgs.title, screenArgs.items);
  }

  @override
  String getArgsKey() {
    return _keyArgs;
  }
}

class _MultiChoiceState extends BaseState<MultiChoiceScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final String _title;
  final List<MultiChoiceOneItem> _items;
  _MultiChoiceState(this._title, this._items) : super(null);

  @override
  Widget build(BuildContext context) {
    return _buildMainWidget();
  }

  Widget _buildMainWidget() {
    return SafeArea(
        top: false,
        child: Scaffold(
            key: _scaffoldKey,
            appBar: buildNormalAppBar(context, _title),
            body: _buildMainBody()));
  }

  Widget _buildMainBody() {
    return Column(
      children: [
        Expanded(
            child: ListView.builder(
          key: PageStorageKey(1),
          itemCount: _items.length,
          itemBuilder: (context, index) => _buildItem(_items[index]),
        )),
        Padding(
          padding: EdgeInsets.all(16),
          child: buildSettingHorizontalFullSizeButton(
              onPressed: () {
                Navigator.pop(context, MultiChoiceScreenResult(_items));
              },
              label: '完了'),
        )
      ],
    );
  }

  Widget _buildItem(MultiChoiceOneItem item) {
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16, top: 4, bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(item.label),
          Checkbox(
              value: item.selected,
              onChanged: (checked) {
                setState(() {
                  item.selected = checked == true;
                });
              })
        ],
      ),
    );
  }
}
