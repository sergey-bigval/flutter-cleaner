import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hello_flutter/screens/home_screen.dart';
import 'utils/constants.dart';
import 'screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(canvasColor: Colors.grey),
    // home: const Scaffold(body: SplashScreen()), // не нужно при routes
    initialRoute: splashScreen,
    routes: {
      splashScreen: (context) => const SplashScreen(),
      homeScreen: (context) => const HomeScreen(),
    },
  ));
}

void lol (String lol) {
  debugPrint("lol $lol");
}