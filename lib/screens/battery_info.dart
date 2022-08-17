import 'dart:async';

import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/material.dart';

class BatteryInfoPage extends StatefulWidget {
  const BatteryInfoPage({Key? key}) : super(key: key);

  @override
  _BatteryInfoPageState createState() => _BatteryInfoPageState();
}

class _BatteryInfoPageState extends State<BatteryInfoPage> {
  final Battery _battery = Battery();

  String _batteryState = "";
  StreamSubscription<BatteryState>? _batteryStateSubscription;
  int _batteryLevel = 0;
  late Timer timer;
  String _isInPowerSaveMode = "Not available";

  final mainTextStyleSmall = const TextStyle(
    decoration: TextDecoration.none,
    color: Colors.black54,
    fontSize: 14.0,
    letterSpacing: 1,);

  @override
  void initState() {
    super.initState();
    getBatteryState();
    checkBatterSaveMode();
    Timer.periodic(const Duration(seconds: 5), (timer) {
      getBatteryLevel();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Battery State: $_batteryState', style:mainTextStyleSmall),
          Text('Battery Level: $_batteryLevel %', style: mainTextStyleSmall),
          Text("Is on low power mode: $_isInPowerSaveMode", style: mainTextStyleSmall)
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    if (_batteryStateSubscription != null) {
      _batteryStateSubscription!.cancel();
    }
  }

  void getBatteryState() {
    _batteryStateSubscription =
        _battery.onBatteryStateChanged.listen((BatteryState state) {
          var batState = "";
          switch (state) {
            case BatteryState.charging : {
              batState = "Charging";
              break;
            }
            case BatteryState.discharging : {
              batState = "Discharging";
              break;
            }
            case BatteryState.full : {
              batState = "Full";
              break;
            }
            case BatteryState.unknown : {
              batState = "No info";
              break;
            }
          }
          setState(() {
            _batteryState = batState;
          });
        });
  }

  getBatteryLevel() async {
    final level = await _battery.batteryLevel;
    setState(() {
      _batteryLevel = level;
    });
  }

 checkBatterSaveMode() async {
    await _battery.isInBatterySaveMode.then((value) {
      var saveModeMessage = "";
      if (value) {
        saveModeMessage = "Enabled";
      } else {
        saveModeMessage = "Disabled";
      }
      setState(() {
        _isInPowerSaveMode = saveModeMessage;
      });
    });
  }
}