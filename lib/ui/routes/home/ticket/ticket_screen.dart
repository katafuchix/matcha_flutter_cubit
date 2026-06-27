import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:matcha_flutter_cubit/model/user/profile.dart';
import 'package:provider/provider.dart';

import '../../../../core/asseet_enum.dart';
import '../../../../core/colors.dart';
import '../../../../core/event_tracking.dart';
import '../../../../core/my_logger.dart';
import '../../../../core/tap_joy.dart';
import '../../../../core/words.dart';
import '../../../../model/master/point_master.dart';
import '../../../../model/purchase/android_purchase.dart';
import '../../../../model/purchase/ios_purchase.dart';
import '../../../../model/purchase/local_receipt.dart';
import '../../../../model/repository/repository_result.dart';
import '../../../../repository/master_repository.dart';
import '../../../../repository/purchase_repository.dart';
import '../../../../repository/storage/shared_preferences/shared_preferences_keys.dart';
import '../../../../repository/storage/shared_preferences/shared_preferences_manager.dart';
import '../../../../ui/components/int_util.dart';
import '../../../../ui/components/snack_bar.dart';
import '../../../../ui/components/widget_circular_progress.dart';
import '../../../../ui/helper/ad_helper.dart';
import '../../../../ui/helper/ad_unit.dart';
import '../../../base/base_stateful_widget.dart';
import '../../../components/buttons.dart';
import '../../../components/dialogs.dart';
import '../../../components/int_util.dart';
import '../../../components/snack_bar.dart';
import '../../../components/texts.dart';
import '../../../helper/ad_helper.dart';
import '../../../helper/ad_unit.dart';
import '../../../helper/repository_handler.dart';
import '../app_bars.dart';
import '../home_change_notifier.dart';
import 'consumable_store.dart';

class TicketScreen extends BaseStatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TicketScreenState();
  }
}

class _TicketScreenState extends BaseState<TicketScreen> {
  static const String _failPurchaseMessage = 'チケット購入に失敗しました。';

  final MasterRepository _masterRepository = MasterRepository();

  final List<String> _consumableIds = [];
  final List<String> _productIds = [];
  final List<PointMaster> _pointMasterList = [];
  final InAppPurchase _connection = InAppPurchase.instance;
  final bool _autoConsume = false;
  final PurchaseRepository _purchaseRepository = PurchaseRepository();
  final AppColors _colors = getAppColors();
  late SharedPreferencesManager _sharedPreferencesManager;
  StreamSubscription<List<PurchaseDetails>>? _subscription;
  List<String> _notFoundIds = [];
  List<ProductDetails> _products = [];
  bool _isAvailable = false;
  bool _loading = true;
  String? _queryProductError;
  BannerAdWidget _ad = BannerAdWidget(AdUnits.ticketScreenBannerAdUnitId);
  bool _tapJoysContentsIsEnable = false;
  bool _showAppBar = true;
  // String? _apiErrorMessage;

  bool _showProgress = false;

  _TicketScreenState() : super(null);

  @override
  void initState() {
    final Stream<List<PurchaseDetails>> purchaseUpdated =
        InAppPurchase.instance.purchaseStream;
    _subscription = purchaseUpdated.listen((purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      _subscription?.cancel();
    }, onError: (error) {
      showErrorDialog(context, unexpectedErrorMessage);
    });
    _initStoreInfo();
    SharedPreferencesManager.getInstance().then((value) {
      _sharedPreferencesManager = value;
    });

    super.initState();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _ad.onDispose();
    super.dispose();
  }

  @mustCallSuper
  void onBuildWidget() {
    super.onBuildWidget();
    _ad.onInitState(context, () {
      setState(() {});
    });
    // TapJoy
    // setupTapjoy();
    reSetupTapjoy();
  }

  Future setupTapjoy() async {
    final result = await TapJoys.isReady();
    setState(() {
      _tapJoysContentsIsEnable = result;
    });
  }

  Future reSetupTapjoy() async {
    _showProgressImpl();
    bool value = await TapJoys.isReady();
    for (int i = 0; i < 10; i++) {
      if (value) break;
      await TapJoys.requestContents();
      await Future.delayed(Duration(milliseconds: 500));
      value = await TapJoys.isReady();
    }
    // _closeProgressImpl() でsetStateされる前提
    _tapJoysContentsIsEnable = value;
    _closeProgressImpl();
  }

  @override
  Widget build(BuildContext context) {
    return _buildMainWidget();
  }

  @override
  void onResume() {
    super.onResume();
    // TapJoy表示中はappBarのアクションをオフにする
    setState(() {
      _showAppBar = true;
    });
    // TapJoyから戻った際に、コンテンツの準備があるか確認しておく
    reSetupTapjoy();
    MyProfileNotifier.getNoListenerNotifier(context).update(context);
  }

  Widget _buildMainWidget() {
    return Scaffold(
      appBar: buildHomeAppBar(context, 'チケット追加', noActions: !_showAppBar),
      body: _buildTicketList(),
    );
  }

  Widget _buildTicketList() {
    return Consumer<MyProfileNotifier>(
      builder: (_, MyProfileNotifier notifier, __) {
        final noPoint = '--';
        Widget main;
        if (_queryProductError == null && _isAvailable != false) {
          final productList = _buildProductList(notifier.myProfile!.profile);
          final tapJoyButton = _buildTapJoyButton();
          main = Container(
            color: _colors.primaryBg,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                _buildMyPoint(notifier.myProfile?.profile.point),
                Divider(
                  height: 0,
                  thickness: 1,
                  color: getAppColors().divider,
                ),
                Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 4),
                      child: ListView(
                        children: List.from(productList)..add(tapJoyButton),
                      ),
                    )),
                _buildRestoreButton(),
                _ad.buildBannerAdOrEmptyContainer()
              ],
            ),
          );
        } else {
          main = Center(
            child: Column(
              children: [Text(_queryProductError ?? ''), _buildTapJoyButton()],
            ),
          );
        }
        return Stack(
          alignment: AlignmentDirectional.center,
          children: [
            main,
            _showProgress ? buildWidgetCircularProgress() : Container(),
          ],
        );

        return Padding(
          padding: EdgeInsets.all(16),
          child: buildNormalText(
              '保有チケット : ${notifier.myProfile?.profile?.point ?? noPoint}枚'),
        );
      },
    );
  }

  Widget _buildMyPoint(int? point) {
    return Consumer<MyProfileNotifier>(
      builder: (_, MyProfileNotifier notifier, __) {
        final noPoint = '--';
        return Padding(
          padding: EdgeInsets.all(16),
          child: buildNormalText(
              '保有チケット : ${notifier.myProfile?.profile?.point ?? noPoint}枚'),
        );
      },
    );
  }

  List<Widget> _buildProductList(Profile me) {
    if (_loading || !_isAvailable) {
      return [
        Card(
            child: (ListTile(
                leading: CircularProgressIndicator(),
                title: Text('商品を読み込み中...'))))
      ];
    }
    if (!_isAvailable) {
      return [Card()];
    }
    // デバッグ用
    // if (_notFoundIds.isNotEmpty) {
    //   return [
    //     ListTile(
    //         title: Text('[${_notFoundIds.join(", ")}] not found',
    //             style: TextStyle(color: ThemeData.light().errorColor)),
    //         subtitle: Text(
    //             'This app needs special configuration to run. Please see example/README.md for instructions.'))
    //   ];
    // }

    // 購入経験があるユーザーには初回のみ購入可能な商品を表示しない
    final bool purchased =
        (me.androidPurchaseCount ?? 0) > 0 || me.clientIdentifierExistExcludeMe == true;

    final colors = getAppColors();
    List<Widget?> widgets = [];
    widgets.addAll(_pointMasterList.map((PointMaster pointMaster) {
      ProductDetails productDetails;
      try {
        productDetails = _products
            .firstWhere((element) => element.id == pointMaster.productIdStr);
        _products
            .firstWhere((element) => element.id == pointMaster.productIdStr);
      } catch (_) {
        return null;
      }

      bool initialCampaign = false;
      if (pointMaster.productIdStr.endsWith('_welcome')) {
        initialCampaign = true;

        // 既に購入済みの場合は表示しない
        if (purchased) {
          return null;
        }
      } else {
        // 既に購入済みの場合のみ表示
        if (!purchased) {
          return null;
        }
      }

      final String priceText =
          '${IntFormatter.toThreeDigits(pointMaster.price)}円';
      final String tickerText =
          '${IntFormatter.toThreeDigits(pointMaster.point)}枚';

      String? priceBeforeDiscountText;
      if (pointMaster.priceBeforeDiscount != null &&
          pointMaster.price != pointMaster.priceBeforeDiscount) {
        if (pointMaster.priceBeforeDiscount != null) {
          priceBeforeDiscountText =
              '${IntFormatter.toThreeDigits(pointMaster.priceBeforeDiscount!)}円';
        }
      }

      MyLogger.d('$priceText $tickerText $priceBeforeDiscountText');

      final Card card = Card(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: colors.primary,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: InkWell(
          onTap: () {
            PurchaseParam purchaseParam = PurchaseParam(
              productDetails: productDetails,
              applicationUserName: null,
            );
            if (_consumableIds.contains(productDetails.id)) {
              _connection.buyConsumable(
                  purchaseParam: purchaseParam,
                  autoConsume: _autoConsume || Platform.isIOS);
            } else {
              _connection.buyNonConsumable(purchaseParam: purchaseParam);
            }
          },
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 4),
                  child: Image.asset(
                    AssetEnum.TICKET.path,
                    width: 32,
                    height: 32,
                    color: colors.textOrIcons,
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        buildH3Text(tickerText, colors: TextColors.ACCENT),
                        initialCampaign
                            ? buildNormalText('(初回のみ！！)',
                                colors: TextColors.ACCENT)
                            : Container(),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.ideographic,
                      children: [
                        priceBeforeDiscountText == null
                            ? null
                            : buildNormalText(priceBeforeDiscountText,
                                colors: TextColors.ACCENT,
                                decoration: TextDecoration.lineThrough),
                        const SizedBox(
                          width: 16,
                        ),
                        buildH3Text(priceText, colors: TextColors.ACCENT)
                      ]
                          .where((element) => element != null)
                          .map((e) => e as Widget)
                          .toList(),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      );
      return card;
    }));

    return widgets
        .where((element) => element != null)
        .map((e) => e as Widget)
        .toList();
  }

  Widget _buildTapJoyButton() {
    if (_tapJoysContentsIsEnable) {
      return Padding(
        padding: EdgeInsets.all(16),
        child: buildSettingHorizontalFullSizeButton(
            onPressed: () async {
              _showProgressImpl();
              await Future.delayed(Duration(microseconds: 500));
              _closeProgressImpl();
              EventTracking.sendLog('Tapjoyボタンクリック');
              final int result = await TapJoys.showContents();
              if (result == 0) {
                setState(() {
                  _showAppBar = false;
                });
              }
              MyLogger.d('method channel result = $result');
              EventTracking.sendLog('method channel result = $result');
            },
            label: '無料でポイントGet！'),
      );
    } else {
      return Container();
    }
  }

  Widget _buildRestoreButton() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: buildSettingHorizontalFullSizeButton(
          onPressed: () => _restore(), label: '購入情報復元'),
    );
  }

  Future<void> _initStoreInfo() async {
    {
      final result = await _masterRepository.getPointMaster();
      if (result.isError()) {
        showErrorSnackBar(context,
            text: result.getErrorMessage() ?? unexpectedErrorMessage);
      }

      _pointMasterList.clear();
      _pointMasterList.addAll(result
          .getData()!
          .where((element) =>
              element.enabled && element.os == getPointOsAsCurrentOs())
          .toList()
        ..sort((a, b) => (a.sortOrder - b.sortOrder)));

      _consumableIds.clear();
      _consumableIds.addAll(result
          .getData()!
          .where((element) => element.enabled)
          .map((e) => e.productIdStr)
          .toList());

      _productIds.clear();
      _productIds.addAll(result
          .getData()!
          .where((element) => element.enabled)
          .map((e) => e.productIdStr)
          .toList());
    }

    final bool isAvailable = await _connection.isAvailable();
    if (!isAvailable) {
      setState(() {
        _isAvailable = isAvailable;
        _products = [];
        _notFoundIds = [];
        _loading = false;
      });
      return;
    }

    ProductDetailsResponse productDetailResponse =
        await _connection.queryProductDetails(_productIds.toSet());
    if (productDetailResponse.error != null) {
      setState(() {
        _queryProductError = productDetailResponse.error?.message;
        _isAvailable = isAvailable;
        _products = productDetailResponse.productDetails;
        _notFoundIds = productDetailResponse.notFoundIDs;
        _loading = false;
      });
      return;
    }

    if (productDetailResponse.productDetails.isEmpty) {
      setState(() {
        _queryProductError = null;
        _isAvailable = isAvailable;
        _products = productDetailResponse.productDetails;
        _notFoundIds = productDetailResponse.notFoundIDs;
        _loading = false;
      });
      return;
    }

    setState(() {
      _isAvailable = isAvailable;
      _products = productDetailResponse.productDetails;
      _notFoundIds = productDetailResponse.notFoundIDs;
      _loading = false;
    });
  }

  Future _restore() async {
    if (Platform.isIOS) {
      _restoreForIos();
      return;
    }

    if (Platform.isAndroid) {
      _restoreForAndroid();
      return;
    }
  }

  Future _restoreForIos() async {
    List<LocalReceipt> consumables = await ConsumableStoreForIos.load();

    if (consumables.isEmpty) {
      showAlertDialog(context,
          title: 'お知らせ', message: '復元が必要なアイテムは見つかりませんでした。', cancelable: false);
      return;
    }

    for (LocalReceipt localReceipt in consumables) {
      final result = await _purchaseRepository.postRestorePurchaseForIos(
          IosPurchaseRequest.forRestore(
              base64ReceiptData: localReceipt.receiptData));
      RepositoryHandler.handleRepositoryResult(context, result);
    }

    showAlertDialog(context,
        title: 'お知らせ', message: '購入情報を復元しました。', cancelable: false);
  }

  Future _restoreForAndroid() async {
    // v3.x では restorePurchases() を呼ぶと purchaseStream 経由で結果が届く
    await InAppPurchase.instance.restorePurchases();

    final ProductDetailsResponse productDetailResponse =
        await _connection.queryProductDetails(_productIds.toSet());
    setState(() {
      _products = productDetailResponse.productDetails;
      _notFoundIds = productDetailResponse.notFoundIDs;
      _loading = false;
    });
  }

  Future<void> _consume(LocalReceipt id) async {
    await ConsumableStoreForIos.consume(id);
  }

  void _showPendingUI() {
    showAlertDialog(context,
        title: '確認',
        message: '商品が保留状態になっております。支払い完了後、購入情報の復元をお試しください。',
        cancelable: false);
  }

  void _deliverProduct(PurchaseDetails purchaseDetails) async {
    if ((Platform.isIOS || !_autoConsume) &&
        _consumableIds.contains(purchaseDetails.productID)) {
      // 消費する
      await _consume(LocalReceipt(
          productId: purchaseDetails.purchaseID!,
          receiptData: purchaseDetails.verificationData.localVerificationData));
    }
    if (purchaseDetails.pendingCompletePurchase) {
      await InAppPurchase.instance.completePurchase(purchaseDetails);
    }

    if (purchaseDetails.productID.endsWith('_welcome')) {
      await AppEvent.sendPurchaseFirstEvent();
    } else {
      await AppEvent.sendPurchaseRegularEvent();
    }

    // バックグラウンドでプロフィール更新しておく
    await MyProfileNotifier.getNoListenerNotifier(context).update(context);

    await showAlertDialog(context,
        title: 'お知らせ',
        message: 'チケット購入決済が完了しました。チケット追加完了まで少々お時間がかかる場合がありますのでご了承ください。',
        cancelable: false);

    setState(() {});
  }

  void _handleError(IAPError error) {
    // showErrorDialog(context, error.message);
    showErrorDialog(context, _failPurchaseMessage);
  }

  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails,
      {bool isRestore = false}) async {
    // _apiErrorMessage = null;

    if ((Platform.isIOS || !_autoConsume) &&
        _consumableIds.contains(purchaseDetails.productID)) {
      // 消費アイテムの購入を永続化
      await ConsumableStoreForIos.save(LocalReceipt(
          productId: purchaseDetails.productID,
          receiptData: purchaseDetails.verificationData.localVerificationData));
    }

    if (Platform.isAndroid) {
      try {
        _showProgressImpl();
        // in_app_purchase v3: Android固有情報は GooglePlayPurchaseDetails にキャストして取得
        final googlePurchase = purchaseDetails as GooglePlayPurchaseDetails;
        final signature = googlePurchase.billingClientPurchase.signature;
        final isAutoRenewing =
            googlePurchase.billingClientPurchase.isAutoRenewing;

        RepositoryResult<AndroidPurchaseResponse> result;
        if (isRestore) {
          result = await _purchaseRepository.postRestorePurchaseForAndroid(
              AndroidPurchaseRequest.forRestore(
                  purchaseData:
                      purchaseDetails.verificationData.localVerificationData,
                  signature: signature));
        } else {
          result = await _purchaseRepository.postPurchaseForAndroid(
              AndroidPurchaseRequest.forPurchase(
                  productId: purchaseDetails.productID,
                  purchaseData:
                      purchaseDetails.verificationData.localVerificationData,
                  signature: signature));
        }

        _closeProgressImpl();
        bool success;
        if (result.isError()) {
          success = false;
          MyLogger.e('チケット購入API失敗 : ${result.getErrorMessage()}');
        } else {
          success = true;
        }

        /// isAutoRenewing = true の場合、定期購読タイプのアイテム
        if (isAutoRenewing) {
          return success;
        } else {
          return success;
        }
      } catch (e, s) {
        MyLogger.e('チケット購入例外 : $e', stacktrace: s);
        return false;
      }
    } else if (Platform.isIOS) {
      try {
        _showProgressImpl();
        final result = await _purchaseRepository.postPurchaseForIos(
            IosPurchaseRequest(
                productId: purchaseDetails.productID,
                base64ReceiptData:
                    purchaseDetails.verificationData.localVerificationData));
        _closeProgressImpl();
        bool success;
        if (result.isError()) {
          success = false;
          // _apiErrorMessage = result.getErrorMessage();
        } else {
          success = true;
        }

        return success;
      } catch (e) {
        return false;
      }
    }
    return Future<bool>.value(false);
  }

  void _handleInvalidPurchase(PurchaseDetails purchaseDetails) {
    showErrorDialog(context, /* _apiErrorMessage ?? */ _failPurchaseMessage);
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      _onPurchase(purchaseDetails);
    });
  }

  Future _onPurchase(PurchaseDetails purchaseDetails,
      {bool isRestore = false}) async {
    if (purchaseDetails.status == PurchaseStatus.pending) {
      _showPendingUI();
    } else {
      if (purchaseDetails.status == PurchaseStatus.error) {
        _handleError(purchaseDetails.error!);
      } else if (purchaseDetails.status == PurchaseStatus.purchased) {
        bool valid = await _verifyPurchase(purchaseDetails);
        if (valid) {
          _deliverProduct(purchaseDetails);
        } else {
          _handleInvalidPurchase(purchaseDetails);
          return;
        }
      }
    }
  }

  _showProgressImpl() {
    setState(() {
      _showProgress = true;
    });
  }

  _closeProgressImpl() {
    setState(() {
      _showProgress = false;
    });
  }
}
