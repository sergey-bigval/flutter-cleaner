import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../main.dart';
import 'ad_id_helper.dart';

class AdInter {
  static late InterstitialAd _interstitialAd;

  static load(Function onLoadDoneFun) {
    InterstitialAd.load(
        adUnitId: AdHelper.interAdUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            lol("INTER_LOADED");
            _interstitialAd = ad;
            onLoadDoneFun();
          },
          onAdFailedToLoad: (LoadAdError error) {
            lol("INTER_LOAD_FAILED");
          },
        ));
    lol("INTER_REQUESTED");
  }

  static _setFSCallBack(Function function) {
    _interstitialAd.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) => lol("INTER_WAS_SHOWED_FULL"),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        lol("INTER_WAS_DISMISSED");
        ad.dispose();
        function();
      },
      onAdClicked: (InterstitialAd ad) => lol("INTER_WAS_CLICKED"),
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        lol("INTER_WAS_FAILED_TO_SHOW");
        ad.dispose();
      },
    );
  }

  static show(Function function) {
    _setFSCallBack(function);
    _interstitialAd.show();
  }
}
