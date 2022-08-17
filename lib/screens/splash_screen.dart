import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hello_flutter/utils/constants.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

import '../ads/AdOpen.dart';
import '../lifecycles/extentions.dart';
import '../lifecycles/orientation.dart';
import '../utils/logging.dart';
import 'package:flutter/gestures.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with WidgetsBindingObserver {
  late bool _loading;
  late double _progressValue;
  final maxSplashTime = 10000;
  var speedProgress = 1.0;

  @override
  void initState() {
    super.initState();
    setOrientation(ScreenOrientation.portraitOnly);
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
          SizedBox(
            height: 250,
            width: 250,
            child: Lottie.asset("assets/lottie/monkey.json"),
            // child: Lottie.network("https://assets7.lottiefiles.com/packages/lf20_bburfggv.json"),
            // child: Image(image: AssetImage('assets/imgs/darth_vader.png')),
          ),
          const Text(
            "Flutter Monkey Cleaner",
            style: TextStyle(
              decoration: TextDecoration.none,
              color: Colors.black54,
              fontSize: 32.0,
              letterSpacing: 4,
              fontFamily: "MouseMemoirs",
            ),
          ),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(20),
            child: Center(
                child: DefaultTextStyle(
              style: const TextStyle(),
                child: Text.rich(
                    textAlign: TextAlign.center,
                    TextSpan(
                        text:
                            'By proceeding, you confirm that you have read and acknowledged ',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                          fontFamily: "CustomIcons.ttf",
                        ),
                        children: <TextSpan>[
                          TextSpan(
                              text: 'Privacy Policy',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.blueAccent,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  launchUrl(Uri.parse(urlPolicy));
                                }),
                          TextSpan(
                              text: ' and ',
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.black87),
                              children: <TextSpan>[
                                TextSpan(
                                    text: 'Terms of Service',
                                    style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.blueAccent,
                                        decoration: TextDecoration.underline),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        launchUrl(Uri.parse(urlTerms));
                                      }),
                              ]),
                        ])),

            )),
          ),
          Visibility(
            visible: _loading,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: LinearProgressIndicator(value: _progressValue),
            ),
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
                }),
              },
              child: const Text(
                "START",
                textScaleFactor: 2.4,
              ),
            ),
          ),
        ],
      ),
    );
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
            AdOpen.show(
                () => {Navigator.pushReplacementNamed(context, homeScreen)});
          });
          return;
        }
      });
    });
  }
}
