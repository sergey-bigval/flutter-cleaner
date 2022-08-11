import 'package:flutter/material.dart';

class ContainerTesting extends StatelessWidget {
  const ContainerTesting({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: const Alignment(0, 0),
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                  "assets/imgs/darth_vader.png",
                ),
                fit: BoxFit.fill)
            // gradient: RadialGradient(
            //     colors: [Colors.yellowAccent, Colors.blueAccent],)
            ),
        child: Container(
          width: 150,
          height: 150,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: Colors.red,
            // borderRadius: BorderRadius.circular(30),
            border: Border.symmetric(
                horizontal: BorderSide(
                    width: 5, color: Colors.blue, style: BorderStyle.solid),
                vertical: BorderSide(width: 10, color: Colors.black38)),
            boxShadow: [
              BoxShadow(
                  color: Colors.black54,
                  spreadRadius: 5,
                  blurRadius: 15,
                  offset: Offset(10, 10))
            ],
          ),
          child: const ElevatedButton(
            onPressed: null,
            child: Text("Start"),
          ),
        ));
  }
}
