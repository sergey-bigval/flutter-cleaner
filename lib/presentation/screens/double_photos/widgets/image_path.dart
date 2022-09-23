import 'package:flutter/material.dart';
import '../../../../themes/styles.dart';

class ImagePath extends StatelessWidget {
  const ImagePath(
    this.imagePath, {
    Key? key,
  }) : super(key: key);

  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Text(
        imagePath,
        textAlign: TextAlign.center,
        style: Styles.textWhite14,
      ),
    );
  }
}
