import 'package:flutter/material.dart';
import 'package:hello_flutter/presentation/screens/doubles/bloc/photos_controller.dart';
import 'package:hello_flutter/presentation/screens/doubles/bloc/photos_filter_logic.dart';
import 'package:hello_flutter/presentation/screens/doubles/doubles_screen.dart';
import 'package:hello_flutter/themes/styles.dart';
import 'package:hello_flutter/utils/constants.dart';

class DuplicateButton extends StatefulWidget {
  const DuplicateButton({super.key});

  @override
  State<DuplicateButton> createState() => _DuplicateButtonState();
}

class _DuplicateButtonState extends State<DuplicateButton> {
  bool isActive = true;

  @override
  Widget build(BuildContext context) {
    return checkDoublesButton();
  }

  Widget checkDoublesButton() {
    return TextButton(
      onPressed: checkDoubles,
      style: TextButton.styleFrom(
        backgroundColor: Colors.red,
        primary: Colors.white,
        minimumSize: const Size(double.infinity, 55),
        maximumSize: const Size(double.infinity, 55),
      ),
      child: isActive ? text() : loader(),
    );
  }

  Widget text() {
    return const Text(
      'Press or long press',
      textAlign: TextAlign.center,
      style: Styles.titleStyle,
    );
  }

  Widget loader() {
    return const SizedBox(
      height: 25,
      width: 25,
      child: CircularProgressIndicator(
        color: Colors.black54,
      ),
    );
  }

  Future<void> checkDoubles() async {
    if (isActive) {
      setState(() => isActive = false);
      await PhotosFilerLogic().loadPhotos();
      setState(() => isActive = true);
    }
  }
}
