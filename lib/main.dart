import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hello_flutter/SplashScreen.dart';
import 'package:hello_flutter/second_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(canvasColor: Colors.grey),
    // home: const Scaffold(body: SplashScreen()), // не нужно при routes
    initialRoute: '/',
    routes: {
      '/': (context) => const SplashScreen(),
      '/todo': (context) => const SecondScreen(),
    },
  ));
}

void lol (String lol) {
  debugPrint("lol $lol");
}