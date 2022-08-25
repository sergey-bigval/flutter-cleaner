

import 'package:flutter/cupertino.dart';

class SimpleGeneratedList extends StatelessWidget {
  const SimpleGeneratedList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: ListView(
          children: List.generate(
            100,
                (i) => const Text("This is any text"),
          ),
        ));
  }
}
