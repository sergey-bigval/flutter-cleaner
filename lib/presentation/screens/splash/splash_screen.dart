import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hello_flutter/ads/AdOpen.dart';
import 'package:hello_flutter/assets/styles.dart';
import 'package:hello_flutter/lifecycles/extentions.dart';
import 'package:hello_flutter/lifecycles/orientation.dart';
import 'package:hello_flutter/presentation/screens/splash/widgets/policy_widget.dart';
import 'package:hello_flutter/presentation/widgets/visibility.dart';
import 'package:hello_flutter/services/shared_preference.dart';
import 'package:hello_flutter/utils/constants.dart';
import 'package:hello_flutter/utils/logging.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  late bool _loading;
  late double _progressValue;
  final maxSplashTime = 10000;
  var speedProgress = 1.0;
  // bool isVisible = true;
  ValueNotifier<bool> visibilityNotifier = ValueNotifier(true);

  late AnimationController animationController;
  late Tween<double> _tween;
  late Animation<double> _animation;


  // late SharedPreferences _prefs;
  bool _boolPref = false;

  @override
  void initState() {
    super.initState();
    setOrientation(ScreenOrientation.portraitOnly);

    initAnimation();

    _loading = false;
    _progressValue = 0.0;
    WidgetsBinding.instance.addObserver(this);
    SharedPref.getStartButtonVisibility()
        .then((value) {
      _boolPref = value;

      if (_boolPref) {
        setState(() {
          _loading = !_loading;
          visibilityNotifier.value = !visibilityNotifier.value;
          // isVisible = !isVisible;
          nat("nat");
          _startProgress();
          AdOpen.load(() {
            speedProgress = 4.0;
          });
        });
      }

    });
  }
/// execute when widget dies
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    animationController.dispose();
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

          ),
          const Text(
            "Flutter Monkey Cleaner",
            style: Styles.titleStyle
          ),
          Visibility(
            visible: _loading,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return LinearProgressIndicator(
                    value: _animation.value,
                  );
                },
              ),
            ),
          ),
          Visibility(
            visible: !_boolPref,
              child: VisibilityWidget(
                notifier: visibilityNotifier,
                child: TextButton(
                  onPressed: () => {
                    setState(() {
                      ('$this._boolPref');
                      _setBoolPref(!_boolPref);
                      _loading = !_loading;
                      _startProgress();
                      visibilityNotifier.value = !visibilityNotifier.value;
                      // isVisible = !isVisible;
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
            ),
           VisibilityWidget(
             notifier: visibilityNotifier,
               child: const PolicyWidget()),

        ],
      ),
    );
  }

  void _setBoolPref(bool value)  {
    SharedPref.saveStartButtonVisibility(value: value);
    _loadBoolPref();
  }

  void _loadBoolPref() {
    setState(() {
      SharedPref.getStartButtonVisibility().then((value) => _boolPref = value);
      nat('nat');
    });
  }

  void _startProgress() {
    var delay = Duration(milliseconds: maxSplashTime ~/ 100);
    Timer.periodic(delay, (Timer timer) {
      setState(() {
        animateProgress();
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

  void initAnimation() {
    animationController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );

    _tween = Tween(begin: 0, end: 0);
    _animation = _tween.animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.easeIn,
      ),
    );
  }

  void animateProgress() {
    _progressValue += 100 / maxSplashTime * speedProgress;
    _tween = Tween(begin: _tween.end, end: _progressValue);
    _animation = _tween.animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.easeIn,
      ),
    );

    animationController
      ..reset()
      ..forward();
  }
}


