import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class LifecycleEventHandler extends WidgetsBindingObserver {
  final AsyncCallback resumeCallBack;
  final AsyncCallback suspendingCallBack;

  LifecycleEventHandler({
    required this.resumeCallBack,
    required this.suspendingCallBack,
  });

  @override
  Future<InitializationStatus> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        await resumeCallBack();
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        suspendingCallBack();
        WidgetsBinding.instance.removeObserver(this);
        break;
    }
    return MobileAds.instance.initialize();
  }
}
