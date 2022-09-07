import 'dart:async';

Stream<int>? stream;
StreamSubscription<int>? subscriber1;
StreamSubscription<String>? subscriber2;
// StreamController - чтобы сдать свои значения и гибко контроллировать
StreamController<String> streamController = StreamController<String>();

main() async {
  print("-------------------");

  stream = Stream.periodic(Duration(seconds: 1), (counter) {
    print("counter sent -> $counter");
    return counter;
  });
  stream =  stream?.asBroadcastStream(); // Только так можно повесить более 1го подписчика на стрим,
  // но тогда стрим вещает ВСЕГДА и не реагирует на комманду .pause()
  // В этом случае, после .pause() и .resume() подписчик в мгновение получит все пропущенные значения.

  print("---------Stream started----------");

  subscriber2 = streamController.stream.asBroadcastStream().listen((string) {
    print("subscriber2 get : $string");
  });
  streamController.add('FIRST_EVENT');

  subscriber1 = stream?.listen((counter) {
    print("subs_1 : counter received -> $counter");
  });

  // await for(int item in stream!) { // осторожно - мы не пройдём дальше await
  //   print("Бескнечный обзёрвер: counter = $item");
  // }

  print("---------Listener has been set----------");

  Future.delayed(Duration(seconds: 4), () {
    subscriber1?.pause();
    print("------------ PAUSED -------------");
    streamController.add('PAUSED');
  }).whenComplete(() {
    Future.delayed(const Duration(seconds: 4), () {
      subscriber1?.resume();
      print("------------ RESUMED -------------");
      streamController.add('RESUMED');
    });
  });

  Future.delayed(const Duration(seconds: 10), () {
    // stream?.close(); // Stream нельзя закрыть !!! BroadcastStream будет слать ВЕЧНО!!!
    subscriber1?.cancel();
    subscriber2?.cancel(); // а BroadcastStream у контроллера МОЖНО закрыть! ;)
    streamController.close();
    print("------------ THE END -------------");
  });
}
