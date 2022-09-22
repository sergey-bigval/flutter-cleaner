import 'package:flutter/material.dart';
import 'package:hello_flutter/themes/app_colors.dart';

class Styles {
  static const TextStyle titleStyle = TextStyle(
    decoration: TextDecoration.none,
    color: Colors.black54,
    fontSize: 32.0,
    letterSpacing: 4,
    fontFamily: "MouseMemoirs",
  );

  static const text20 = TextStyle(
    fontSize: 20,
    color: Colors.black,
    decoration: TextDecoration.none,
  );

  static const text15 = TextStyle(
    fontSize: 15,
    color: Colors.black45,
    decoration: TextDecoration.none,
  );

  static const text16White = TextStyle(
    fontSize: 16,
    color: Colors.white,
    decoration: TextDecoration.none,
    fontWeight: FontWeight.bold
  );

  static const text20WhiteB = TextStyle(
      fontSize: 20,
      color: Colors.white,
      decoration: TextDecoration.none,
      fontWeight: FontWeight.bold
  );

  static const text16B = TextStyle(
      fontSize: 16,
      color: Colors.black,
      decoration: TextDecoration.none,
      fontWeight: FontWeight.bold
  );

  static const text18 = TextStyle(
    fontSize: 18,
    color: Colors.black,
    decoration: TextDecoration.none,
  );

  static TextStyle clickable16 = TextStyle(
      fontSize: 16,
      color: Colors.blue[600],
      decoration: TextDecoration.none,
      fontWeight: FontWeight.bold
  );
}
