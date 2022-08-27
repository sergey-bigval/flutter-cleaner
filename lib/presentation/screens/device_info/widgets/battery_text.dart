import 'package:flutter/material.dart';

class BatteryText extends StatelessWidget {
  const BatteryText({
    Key? key,
    required String title,
    required String value,
  })  : _title = title,
        _value = value,
        super(key: key);

  final String _title;
  final String _value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: RichText(
        text: TextSpan(
            style: const TextStyle(
              fontSize: 14.0,
              color: Colors.white,
            ),
            children: [
              TextSpan(
                  text: _title,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(
                text: _value,
              ),
            ]),
      ),
    );
  }
}
