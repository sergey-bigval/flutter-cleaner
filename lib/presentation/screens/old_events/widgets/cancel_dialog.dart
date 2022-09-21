import 'package:flutter/material.dart';

class CancelDialogEvents extends StatelessWidget {
  final Function onCancel;

  const CancelDialogEvents({required this.onCancel, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Padding(
          padding: EdgeInsets.only(bottom: 20),
          child: Center(child: Text("Cancel searching old events?"))),
      contentPadding: const EdgeInsets.all(1),
      insetPadding: const EdgeInsets.all(10),
      content: const Padding(
        padding: EdgeInsets.only(left: 20, bottom: 15, right: 20),
        child: Text(
          'Are you sure you want to cancel? Canceling this operation will result in the loss of current results!',
          textAlign: TextAlign.center,
        ),
      ),
      actions: [
        ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Continue")),
        ElevatedButton(
            onPressed: () {
              onCancel.call();
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text("Cancel")),
      ],
    );
  }
}
