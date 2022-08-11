import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../main.dart';

class AdOpen {
  static late AppOpenAd _appOpenAd;

  static load(Function onLoadDoneFun) {
    AppOpenAd.load(
        adUnitId: 'ca-app-pub-3940256099942544/3419835294',
        request: const AdRequest(),
        adLoadCallback: AppOpenAdLoadCallback(
          onAdLoaded: (AppOpenAd ad) {
            lol("lol OPEN_LOADED");
            _appOpenAd = ad;
            onLoadDoneFun();
          },
          onAdFailedToLoad: (LoadAdError error) {
            lol("lol OPEN_LOAD_FAILED");
          },
        ), orientation: AppOpenAd.orientationPortrait);
    lol("lol OPEN_REQUESTED");
  }

  static _setFSCallBack(Function function) {
    _appOpenAd.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (AppOpenAd ad) => lol("lol OPEN_WAS_SHOWED_FS"),
      onAdDismissedFullScreenContent: (AppOpenAd ad) {
        lol("lol OPEN_WAS_DISMISSED");
        ad.dispose();
        function();
      },
      onAdClicked: (AppOpenAd ad) => lol("lol OPEN_WAS_CLICKED"),
      onAdFailedToShowFullScreenContent: (AppOpenAd ad, AdError error) {
        lol("lol OPEN_WAS_FAILED_TO_SHOW");
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
