import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../../themes/styles.dart';

class ScannedPhotosCount extends StatelessWidget {
  const ScannedPhotosCount(
    this.photosCount, {
    Key? key,
  }) : super(key: key);

  final String photosCount;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          photosCount,
          style: Styles.textWhiteBold90,
        ),
        SizedBox(
            width: 130,
            height: 130,
            child: Lottie.asset(
              "assets/lottie/photos_searching.json",
            )),
      ],
    );
  }
}
