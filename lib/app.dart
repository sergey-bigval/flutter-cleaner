import 'package:flutter/material.dart';
import 'package:hello_flutter/presentation/screens/double_photos/double_photos_screen.dart';
import 'package:hello_flutter/presentation/screens/double_photos/widgets/permissions_handler.dart';
import 'package:hello_flutter/presentation/screens/home_screen.dart';
import 'package:hello_flutter/presentation/screens/splash/splash_screen.dart';
import 'package:hello_flutter/presentation/screens/videos/big_videos_screen.dart';
import 'package:hello_flutter/utils/constants.dart';

import 'lifecycles/nav_observer.dart';

class FlutterCleanerApp extends StatelessWidget {
  FlutterCleanerApp({Key? key}) : super(key: key);

  final _observer = NavigatorObserverWithOrientation();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(canvasColor: Colors.grey),
      // home: const Scaffold(body: SplashScreen()), // не нужно при routes
      initialRoute: homeScreen,
      routes: {
        splashScreen: (context) => const SplashScreen(),
        homeScreen: (context) => const HomeScreen(),
        permScreen: (context) => const PermissionHandlerWidget(),
        bigVideosScreen: (context) => const BigVideosScreen(),
        doublePhotosScreen: (context) => const DoublePhotosScreen(),
      },
      navigatorObservers: [_observer],
    );
  }
}
