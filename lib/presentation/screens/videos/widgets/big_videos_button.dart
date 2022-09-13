import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hello_flutter/themes/app_colors.dart';
import 'package:hello_flutter/themes/styles.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../../../utils/constants.dart';

class BigVideosButton extends StatefulWidget {
  const BigVideosButton({super.key});

  @override
  State<BigVideosButton> createState() => _BigVideosButtonState();
}

class _BigVideosButtonState extends State<BigVideosButton> {
  bool isActive = true;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      color: AppColors.optimizeBtnColor,
      onPressed: checkDoubles,
      child: isActive ? getText() : getLoader(),
    );
  }

  Widget getText() {
    return const Text(
      'Press for video searching or long press',
      textAlign: TextAlign.center,
      style: Styles.text20,
    );
  }

  Widget getLoader() {
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
      PermissionState permState = await PhotoManager.requestPermissionExtend();
      if (permState.isAuth) {
        // setState(() => isActive = false);
        Navigator.pushReplacementNamed(context, bigVideosScreen);
        // await VideoLogic().loadVideos();
        // setState(() => isActive = true);
      }
    }
  }
}
