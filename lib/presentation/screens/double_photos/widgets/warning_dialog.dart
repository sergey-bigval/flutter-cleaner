import 'package:flutter/material.dart';
import 'package:hello_flutter/utils/constants.dart';

class WarningDialog extends StatelessWidget {
  const WarningDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      //this right here
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Icon(
            Icons.warning_rounded,
            size: 100,
            color: Colors.deepOrange,
          ),
          const Padding(
            padding: EdgeInsets.all(15.0),
            child: Text(
              textAlign: TextAlign.center,
              'Are you sure you want stop progress?',
              style: TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: OutlinedButton(
                      onPressed: () {
                        Navigator.popUntil(context, ModalRoute.withName(homeScreen));
                      },
                      child: const Text(
                        "STOP",
                        style: TextStyle(color: Colors.grey),
                      )),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: Colors.blue),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("CONTINUE",
                          style: TextStyle(color: Colors.white))),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
