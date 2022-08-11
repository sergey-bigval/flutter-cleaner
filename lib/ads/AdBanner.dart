import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../main.dart';
import 'ad_id_helper.dart';

class BannerBlock extends StatefulWidget {
  const BannerBlock({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _BannerBlockState();
  }
}

class _BannerBlockState extends State<BannerBlock> {
  late BannerAd banner = BannerAd(
    adUnitId: AdHelper.bannerAdUnitId,
    size: AdSize.banner,
    request: const AdRequest(),
    listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          lol("BANNER_LOADED");
          banner = ad as BannerAd;
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          lol("BANNER_LOAD_FAILED");
          ad.dispose();
        },
        onAdOpened: (Ad ad) => lol("BANNER_OPENED"),
        onAdClosed: (Ad ad) => lol("BANNER_CLOSED"),
        onAdImpression: (Ad ad) => lol("BANNER_SHOWED"),
        onAdClicked: (Ad ad) => lol("BANNER_CLICKED")),
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: banner.size.width.toDouble(),
      height: banner.size.height.toDouble(),
      child: AdWidget(ad: banner),
    );
  }

  @override
  void initState() {
    super.initState();
    banner.load();
  }
}
