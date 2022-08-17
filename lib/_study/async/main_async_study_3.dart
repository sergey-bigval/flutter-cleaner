//
//
//

import 'dart:io';
import 'dart:isolate';

main() async {
  callerCreateIsolate();
  for (int i = 0; i < 999; i++) {
    print('Thread-1 ->>> $i');
    sleep(Duration(milliseconds: 1000));
  }
  print('done');
}

late SendPort newIsolateSendPort;
late Isolate? newIsolate;

void callerCreateIsolate() async {
  ReceivePort receivePort = ReceivePort();
  newIsolate = await Isolate.spawn(
    callbackFunction,
    receivePort.sendPort,
  );
  newIsolateSendPort = await receivePort.first;
}

// Точка входа нового изолята
void callbackFunction(SendPort callerSendPort) {
// Создание экземпляра SendPort для получения сообщений от "вызывающего"
  ReceivePort newIsolateReceivePort = ReceivePort();
// Даём "вызывающему" ссылку на SendPort ЭТОГО изолята
  callerSendPort.send(newIsolateReceivePort.sendPort);
// Дальнейшая работа
  for (int i = 0; i < 999; i++) {
    print('Thread-2');
    sleep(Duration(milliseconds: 1200));
  }
}

void dispose() {
  newIsolate?.kill(priority: Isolate.beforeNextEvent);
  newIsolate = null;
}

// Future<String> sendReceive(String messageToBeSent) async {
//   // Временный порт для получения ответа
//   ReceivePort port = ReceivePort();
//   // Отправляем сообщение изоляту, а также
//   // говорим изоляту, какой порт использовать
//   // для отправки ответа
//   print('object-1');
//   newIsolateSendPort.send(
//     CrossIsolatesMessage<String>(sender: port.sendPort, message: messageToBeSent),
//   );
//   print('object-2');
//   return port.first as String;
// }
//
// //
// // Callback-функция для обработки входящего сообщения
// //
// void callbackFunction(SendPort callerSendPort) {
// // Создаём экземпляр SendPort для получения сообщения от вызывающего
//   ReceivePort newIsolateReceivePort = ReceivePort();
// // Даём "вызывающему" ссылку на SendPort ЭТОГО изолята
//   callerSendPort.send(newIsolateReceivePort.sendPort);
// // Функция изолята, которая слушает входящие сообщения,
// // обрабатывает и отправляет ответ
//   print('listen - 1');
//   newIsolateReceivePort.listen((dynamic message) {
//     print('listen');
//     CrossIsolatesMessage incomingMessage = message as CrossIsolatesMessage;
// // Обработка сообщения
//     String newMessage = "complemented string ${incomingMessage.message}";
//     print(newMessage);
// // Отправляем результат обработки
//     incomingMessage.sender.send(newMessage);
//   });
//   print('listen - 2');
//   for (int i = 0; i < 99999; i++) {
//     print('Thread-2 ->>> $i');
//     sleep(Duration(milliseconds: 1200));
//   }
// }
//
// // Вспомогательный класс
// class CrossIsolatesMessage<T> {
//   final SendPort sender;
//   final T message;
//
//   CrossIsolatesMessage({
//     required this.sender,
//     required this.message,
//   });
// }
