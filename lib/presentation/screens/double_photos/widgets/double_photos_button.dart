import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../../../themes/styles.dart';
import '../../../../utils/constants.dart';

class DoublePhotosButton extends StatefulWidget {
  const DoublePhotosButton({
    Key? key,
  }) : super(key: key);

  @override
  State<DoublePhotosButton> createState() => _DoublePhotosButtonState();
}

class _DoublePhotosButtonState extends State<DoublePhotosButton> {
  bool isActive = true;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: checkDoubles,
      child: const Text(
        "Start searching double photos",
        style: Styles.text20,
      ),
    );
  }

  Future<void> checkDoubles() async {
    if (isActive) {
      PermissionState permState = await PhotoManager.requestPermissionExtend();
      if (permState.isAuth) {
        Navigator.pushNamed(context, doublePhotosScreen);
      }
    }
  }
}
