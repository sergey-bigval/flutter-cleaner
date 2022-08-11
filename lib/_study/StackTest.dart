import 'package:flutter/material.dart';

class StackTest extends StatelessWidget {
  const StackTest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 250,
            height: 250,
            color: Colors.yellowAccent,
            child: const Text("1"),
          ),
          Container(
            width: 150,
            height: 150,
            color: Colors.blue,
            child: const Text("2"),
          ),
          Positioned(
            top: 15,
            right: 15,
            child: Container(
              width: 50,
              height: 50,
              color: Colors.red,
              child: const Text("3"),
            ),
          ),
        ],
      ),
    );
  }
}
