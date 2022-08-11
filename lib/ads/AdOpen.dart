import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hello_flutter/ads/ad_id_helper.dart';

import '../main.dart';

class AdOpen {
  static late AppOpenAd _appOpenAd;

  static load(Function onLoadDoneFun) {
    AppOpenAd.load(
        adUnitId: AdHelper.openAdUnitId,
        request: const AdRequest(),
        adLoadCallback: AppOpenAdLoadCallback(
          onAdLoaded: (AppOpenAd ad) {
            lol("OPEN_LOADED");
            _appOpenAd = ad;
            onLoadDoneFun();
          },
          onAdFailedToLoad: (LoadAdError error) {
            lol("OPEN_LOAD_FAILED");
          },
        ), orientation: AppOpenAd.orientationPortrait);
    lol("OPEN_REQUESTED");
  }

  static _setFSCallBack(Function function) {
    _appOpenAd.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (AppOpenAd ad) => lol("OPEN_WAS_SHOWED_FS"),
      onAdDismissedFullScreenContent: (AppOpenAd ad) {
        lol("OPEN_WAS_DISMISSED");
        ad.dispose();
        function();
      },
      onAdClicked: (AppOpenAd ad) => lol("OPEN_WAS_CLICKED"),
      onAdFailedToShowFullScreenContent: (AppOpenAd ad, AdError error) {
        lol("OPEN_WAS_FAILED_TO_SHOW");
        ad.dispose();
      },
      // onAdImpression: (InterstitialAd ad) => lol("lol INTER_WAS_SHOWED"),
    );
  }

  static show(Function function) {
    _setFSCallBack(function);
    _appOpenAd.show();
  }
}
