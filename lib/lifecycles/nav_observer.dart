import 'package:flutter/cupertino.dart';

import '../utils/logging.dart';

class NavigatorObserverWithOrientation extends NavigatorObserver {
  @override
  void didPop(Route route, Route? previousRoute) {
    lol("USER_POP_${previousRoute?.settings.name}_TO_${route.settings.name}");
    // if (previousRoute?.settings.arguments is ScreenOrientation) {
    //   setOrientation(previousRoute?.settings.arguments as ScreenOrientation);
    // } else {
    //   setOrientation(ScreenOrientation.portraitOnly);
    // }
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    lol("USER_PUSH_${previousRoute?.settings.name}_TO_${route.settings.name}");
    // if (route.settings.arguments is ScreenOrientation) {
    //   setOrientation(route.settings.arguments as ScreenOrientation);
    // } else {
    //   setOrientation(ScreenOrientation.portraitOnly);
    // }
  }
  @override
  void didRemove(Route route, Route? previousRoute) {
    lol("USER_REM_${previousRoute?.settings.name}_TO_${route.settings.name}");
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    lol("USER_REP_${oldRoute?.settings.name}_TO_${newRoute?.settings.name}");
  }
}
