import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget with PreferredSizeWidget {
  const MyAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      centerTitle: true,
      title: Padding(
        padding: const EdgeInsets.all(10),
        child: Text("Device Info",
            style: TextStyle(
                decoration: TextDecoration.none,
                color: Colors.blueGrey[700],
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: "Comfortaa")),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}