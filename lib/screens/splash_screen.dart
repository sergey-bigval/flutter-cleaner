import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hello_flutter/assets/styles.dart';
import 'package:hello_flutter/screens/splash/widgets/policy_widget.dart';
import 'package:hello_flutter/utils/constants.dart';
import 'package:lottie/lottie.dart';
import '../ads/AdOpen.dart';
import '../lifecycles/extentions.dart';
import '../lifecycles/orientation.dart';
import '../utils/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  // bool switchValue = false;
  bool isVisible = true;


  late SharedPreferences _prefs;
  bool _boolpref = false;

  static const String kBoolPrefKey = 'bool_pref';

  @override
  void initState() {
    super.initState();
    setOrientation(ScreenOrientation.portraitOnly);
    _loading = false;
    _progressValue = 0.0;
    WidgetsBinding.instance.addObserver(this);
    SharedPreferences.getInstance()
    .then((prefs) {
      setState(() => _prefs = prefs);
      _loadBoolPref();
    }).then((value) {
     nat('nat');
      if(_boolpref) {
        setState(() {
          _loading = !_loading;
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
              child: LinearProgressIndicator(value: _progressValue),
            ),
          ),
          Visibility(
            visible: !_boolpref,
            child: Visibility(
              // visible: isVisible,
              // maintainState: false,
              child: TextButton(
                onPressed: () => {
                  setState(() {
                    ('$this._boolPref');
                    _setBoolPref(!_boolpref);
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
          ),
          const Visibility(visible: true,
              maintainState: false,
              child : policy_widget()),

        ],
      ),
    );
  }

  void _setBoolPref(bool value)  {
    _prefs.setBool(kBoolPrefKey, value);
    _loadBoolPref();
  }

  void _loadBoolPref() {
    setState(() {
      _boolpref = _prefs.getBool(kBoolPrefKey) ?? false;
      nat('nat');
    });
  }

  void _startProgress() {
    isVisible = !isVisible;
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


