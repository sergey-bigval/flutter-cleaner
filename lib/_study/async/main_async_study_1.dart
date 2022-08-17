//
//
//
// Function() log(String str) => () {
//       return print(str);
//     };
//
// Function(dynamic) lor(String str) => (a) {
//       return print(str);
//     };

main() async {
  // print('Before the Future');
  // Future(log('Running the Future')).then(lor('Future is complete'));
  // print('After the Future');

  methodA();
  await methodB();
  await methodC('main');
  methodD();
}

methodA() {
  print('A');
}

methodB() async {
  print('B start');
  await methodC('B');
  print('B end');
}

methodC(String from) async {
  print('C start from $from');

  await Future(() {
    // <== изменение здесь
    print('C running Future from $from');
  }).then((_) {
    print('C end of Future from $from');
  });
  print('C end from $from');
}

methodD() {
  print('D');
}
