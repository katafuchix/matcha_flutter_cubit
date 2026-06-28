import 'package:flutter/material.dart';

import '../../base/base_stateful_widget.dart';
import '../../components/buttons.dart';
import '../../my_navigator.dart';
import '../home/app_bars.dart';

export '../../route_args.dart' show MultiChoiceOneItem, MultiChoiceScreenResult;

class MultiChoiceScreen extends BaseStatefulWidget {
  final String title;
  final List<MultiChoiceOneItem> items;

  const MultiChoiceScreen({required this.title, required this.items});

  @override
  State<StatefulWidget> createState() => _MultiChoiceState(title, items);
}

class _MultiChoiceState extends BaseState<MultiChoiceScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final String _title;
  final List<MultiChoiceOneItem> _items;
  _MultiChoiceState(this._title, this._items) : super();

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
