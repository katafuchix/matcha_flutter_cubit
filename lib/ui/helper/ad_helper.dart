import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../core/my_platform.dart';

class BannerAdWidget {
  final String? adUnitId;

  bool _isAdLoaded = false;
  BannerAd? _ad;

  BannerAdWidget(this.adUnitId);

  void onInitState(BuildContext context, Function onSetState) async {
    if (!MyPlatform.isMobileApp) return;

    final size = await AdSize.getAnchoredAdaptiveBannerAdSize(
        Orientation.portrait, MediaQuery.of(context).size.width.truncate());
    _ad = BannerAd(
      adUnitId: adUnitId!,
      size: size ?? AdSize.largeBanner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          print('onAdLoaded');
          _isAdLoaded = true;
          onSetState.call();
        },
        onAdFailedToLoad: (ad, error) {
          // Releases an ad resource when it fails to load
          ad.dispose();

          print('Ad load failed (code=${error.code} message=${error.message})');
        },
      ),
    );

    _ad?.load();
  }

  void onDispose() {
    if (!MyPlatform.isMobileApp) return;
    _ad?.dispose();
  }

  Widget buildBannerAdOrEmptyContainer() {
    if (!MyPlatform.isMobileApp) return Container();

    double width = _ad?.size.width.toDouble() ?? 320.0;
    double height = _ad?.size.height.toDouble() ?? 50.0;
    return _isAdLoaded && _ad != null
        ? Container(
            child: AdWidget(ad: _ad!),
            width: width,
            height: height + 10,
            alignment: Alignment.center,
          )
        : Container();
  }

  double adHeight() {
    if (!MyPlatform.isMobileApp) return 0;

    return _isAdLoaded ? (_ad?.size.height.toDouble() ?? 50) + 10 : 0;
  }
}
