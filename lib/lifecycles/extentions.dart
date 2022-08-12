import 'package:flutter/cupertino.dart';
import 'lifecycle_event_handler.dart';

void launchWhenResumed(Function fun) {
  if (WidgetsBinding.instance.lifecycleState == AppLifecycleState.resumed) {
    fun();
  } else {
    WidgetsBinding.instance.addObserver(LifecycleEventHandler(
        resumeCallBack: () async => fun(), suspendingCallBack: () async => {}));
  }
}
