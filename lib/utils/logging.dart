import 'package:flutter/foundation.dart';

void lol(String lol) {
  debugPrint("lol $lol");
}

void bat(String batteryLog) {
  debugPrint("bat $batteryLog");
}

void nat(String nat) {
  if (kDebugMode) {
    print("nat is $nat");
  }
}