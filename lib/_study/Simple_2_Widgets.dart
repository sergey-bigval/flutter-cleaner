import 'package:flutter/material.dart';

//////////////////////////////////////////////////////////////////////////////
class StateLESS extends StatelessWidget {
  const StateLESS({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text("data");
  }
}

//////////////////////////////////////////////////////////////////////////////
class StateFULL extends StatefulWidget {
  const StateFULL({Key? key}) : super(key: key);

  @override
  StateForWidget createState() => StateForWidget();
}

class StateForWidget extends State<StateFULL> {
  String textMy = "Start text ";

  void fn1() => {textMy = "$textMy +1"};

  void _changeMyWidgetFunction() => setState(fn1);

  void _resetMyWidgetFunction() => setState(() => {textMy = "RESET: "});

  @override
  void initState() {
    super.initState();
    print("init STATE");
  }

  @override
  Widget build(BuildContext context) {
    print("--- BUILD");
    return Center(
      child: ElevatedButton(
        onPressed: _changeMyWidgetFunction,
        onLongPress: _resetMyWidgetFunction,
        child: Text(textMy),
      ),
    );
  }
}
