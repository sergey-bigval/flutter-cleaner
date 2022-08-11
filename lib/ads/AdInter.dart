import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../main.dart';

class AdInter {
  static late InterstitialAd _interstitialAd;

  static load(Function onLoadDoneFun) {
    InterstitialAd.load(
        adUnitId: 'ca-app-pub-3940256099942544/1033173712',
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            lol("lol INTER_LOADED");
            _interstitialAd = ad;
            onLoadDoneFun();
          },
          onAdFailedToLoad: (LoadAdError error) {
            lol("lol INTER_LOAD_FAILED");
          },
        ));
    lol("lol INTER_REQUESTED");
  }

  static _setFSCallBack(Function function) {
    _interstitialAd.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) => lol("lol INTER_WAS_SHOWED_FS"),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        lol("lol INTER_WAS_DISMISSED");
        ad.dispose();
        function();
      },
      onAdClicked: (InterstitialAd ad) => lol("lol INTER_WAS_CLICKED"),
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        lol("lol INTER_WAS_FAILED_TO_SHOW");
        ad.dispose();
      },
      // onAdImpression: (InterstitialAd ad) => lol("lol INTER_WAS_SHOWED"),
    );
  }

  static show(Function function) {
    _setFSCallBack(function);
    _interstitialAd.show();
  }
}
