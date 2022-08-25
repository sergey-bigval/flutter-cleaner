//
//
//

import 'package:flutter/material.dart';

main() async {
  method1();
  await Future.delayed(const Duration(seconds: 1));
  print('///////////////////// method-1 ends //////////////////////////////');
  method2();
}

Future<void> method1() async {
  List<String> myArray = <String>['a', 'b', 'c'];
  debugPrint('before loop');

  for (String value in myArray) {
    await delayedPrint(value);
  }

  debugPrint('end of loop');
}

Future<void> delayedPrint(String value) async {
  await Future.delayed(const Duration(seconds: 1), () {
    debugPrint('delayedPrint: $value');
  });
}

void method2() async {
  List<String> myArray = <String>['a', 'b', 'c'];
  print('before loop');
  for (int i = 0; i < myArray.length; i++) {
    await delayedPrint(myArray[i]);
  }
  print('end of loop');
}

