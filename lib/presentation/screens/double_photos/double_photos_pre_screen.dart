import 'package:flutter/material.dart';
import 'package:hello_flutter/presentation/screens/double_photos/widgets/double_photos_button.dart';

class DoublePhotosPreScreen extends StatelessWidget {
  const DoublePhotosPreScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(child: DoublePhotosButton());
  }
}
