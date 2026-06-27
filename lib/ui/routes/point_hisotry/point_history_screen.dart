import 'package:flutter/material.dart';

import '../../../core/colors.dart';
import '../../../model/point/point_model.dart';
import '../../../model/repository/repository_result.dart';
import '../../../repository/point_repository.dart';
import '../../base/base_stateful_widget.dart';
import '../../components/containers.dart';
import '../../components/texts.dart';
import '../../components/widget_circular_progress.dart';
import '../../helper/repository_handler.dart';
import '../home/app_bars.dart';

class PointHistoryScreen extends BaseStatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PointHistoryState();
  }
}

class _PointHistoryState extends BaseState<PointHistoryScreen> {
  _PointHistoryState() : super(null);

  final PointRepository _pointRepository = PointRepository();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final List<PointModel> _pointList = [];
  int? _page = 1;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initialLoad();
  }

  Future _initialLoad() async {
    _page = 1;
    _pointList.clear();
    _load();
  }

  Future _load() async {
    if (_isLoading || _page == null) return;

    _isLoading = true;

    final result = await _pointRepository.getPointHistory(_page!);
    RepositoryHandler.handleRepositoryResult(context, result,
        onSuccess: (List<PointModel>? value, RepositoryResultMisc? misc) {
      if (value != null) {
        _pointList.addAll(value);
      }

      // ページ情報更新
      if (misc?.loadedPageIndex == null ||
          misc?.totalCount == 0 ||
          value?.isEmpty == true) {
        _page = null;
      } else {
        _page = misc!.loadedPageIndex! + 1;
      }
    });
    _isLoading = false;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Containers.createScreenContainer(
        context,
        Scaffold(
            key: _scaffoldKey,
            appBar: buildNormalAppBar(
              context,
              'チケット履歴',
            ),
            body: Container(
              color: getAppColors().primaryBg,
              child: _buildList(),
            )));
  }

  Widget _buildList() {
    if (_isLoading) {
      return _buildLoading();
    }
    if (_pointList.isEmpty && !_isLoading) {
      return _buildEmpty();
    }
    return RefreshIndicator(
      onRefresh: () async {
        await _initialLoad();
      },
      child: NotificationListener<ScrollNotification>(
        onNotification: (scrollNotification) {
          if (scrollNotification.metrics.pixels >
              scrollNotification.metrics.maxScrollExtent * 0.7) {
            _load();
          }
          return false;
        },
        child: ListView.builder(
          key: PageStorageKey(1),
          itemCount: _pointList.length,
          itemBuilder: (context, index) {
            return _buildItem(_pointList[index]);
          },
        ),
      ),
    );
  }

  Widget _buildItem(PointModel pointModel) {
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildNormalText(pointModel.processDate),
              const SizedBox(
                height: 4,
              ),
              Row(
                children: [
                  buildNormalText(pointModel.processType),
                  const SizedBox(
                    width: 8,
                  ),
                  buildNormalText(pointModel.point.toString()),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return Center(
      child: WidgetCircularProgress(),
    );
  }

  Widget _buildEmpty() {
    // ビジネスロジック上ここにはこない
    return Center(
      child: buildNormalText('チケット履歴はありません'),
    );
  }
}
