import 'dart:async';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'ads/AdBanner.dart';
import 'ads/AdOpen.dart';
import 'lifecycles/extentions.dart';
import 'main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with WidgetsBindingObserver {
  late bool _loading;
  late double _progressValue;
  final maxSplashTime = 10000;
  var speedProgress = 1.0;

  @override
  void initState() {
    super.initState();
    _loading = false;
    _progressValue = 0.0;
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    lol(state.name);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.pink[200],
        // width: 360, // my Xiaomi Mi A3 points
        // height: 732, // my Xiaomi Mi A3 points
        alignment: Alignment.center,
        padding: const EdgeInsets.only(top: 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            const SizedBox(
              height: 250,
              width: 250,
              child: Image(image: AssetImage('assets/imgs/darth_vader.png')),
            ),
            const Text(
              "Flutter Monkey Maker",
              style: TextStyle(
                decoration: TextDecoration.none,
                color: Colors.black54,
                fontSize: 32.0,
                letterSpacing: 4,
                fontFamily: "MouseMemoirs",
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "By proceeding, you confirm that you have read and acknowledged Privacy Policy and Terms of Service",
                textAlign: TextAlign.center,
                style: TextStyle(
                  decoration: TextDecoration.none,
                  color: Colors.black54,
                  fontSize: 14.0,
                ),
              ),
            ),
            Visibility(
              visible: _loading,
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: LinearProgressIndicator(value: _progressValue)),
            ),
            Visibility(
              // visible: !_loading,
              child: TextButton(
                  onPressed: () => {
                        setState(() {
                          _loading = !_loading;
                          _startProgress();
                          AdOpen.load(() {
                            speedProgress = 4.0;
                          });
                        })
                      },
                  child: const Text(
                    "START",
                    textScaleFactor: 2.4,
                  )),
            ),
            const BannerBlock()
          ],
        ));
  }

  void _startProgress() {
    var delay = Duration(milliseconds: maxSplashTime ~/ 100);
    Timer.periodic(delay, (Timer timer) {
      setState(() {
        _progressValue += 100 / maxSplashTime * speedProgress;
        if (_progressValue >= 1.0) {
          timer.cancel();
          launchWhenResumed(() {
            // pushReplacementNamed - навигация без возврата бекпрессом
            AdOpen.show(() => {Navigator.pushNamed(context, "/todo")});
          });
          return;
        }
      });
    });
  }
}
