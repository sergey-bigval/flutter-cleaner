import 'dart:io';

const dur1 = Duration(seconds: 1);
const dur3 = Duration(seconds: 3);

main() {
  print('----------------');
  test();
  print('================');

  // var result = File('d:/kotlin_edu_TEST.txt').readAsString();
  // result.then((value) => print(value));
  // result.whenComplete(() => print('F-1'));
  // var fut = Future<String>.delayed(dur3, () {
  //   return "FUTURE";
  // });
  // fut.whenComplete(() => print('F-2'));
  //
  // var futures = Future.wait([result, fut]);
  // futures.whenComplete(() => print('All ready'));
}

Future<void> test() async {
  final a = await sum(1, 4);
  print(a);
  final b = await sum(a, 9);
  print(b);
  final c = await sum(b, 100);
  print(c);
}

Future<int> sum(int a, int b) {
  sleep(dur1);
  return Future.sync(() => a + b);
}
