//
//
//

main() async {
  int i = 0;
  String name = "Natasha";
  method1();
  await Future.delayed(const Duration(seconds: 1));
  print('///////////////////// method-1 ends //////////////////////////////');
  method2();
}

void method1() {
  List<String> myArray = <String>['a', 'b', 'c'];
  print('before loop');
  myArray.forEach((String value) async {
    await delayedPrint(value);
  });
  print('end of loop');
}

void method2() async {
  List<String> myArray = <String>['a', 'b', 'c'];
  print('before loop');
  for (int i = 0; i < myArray.length; i++) {
    await delayedPrint(myArray[i]);
  }
  print('end of loop');
}

Future<void> delayedPrint(String value) async {
  await Future.delayed(const Duration(seconds: 1));
  print('delayedPrint: $value');
}
