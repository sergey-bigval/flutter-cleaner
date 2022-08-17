import 'package:flutter/material.dart';
import 'package:hello_flutter/screens/home_screen.dart';
import 'package:hello_flutter/screens/splash_screen.dart';
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
      },
      navigatorObservers: [_observer],
    );
  }
}
