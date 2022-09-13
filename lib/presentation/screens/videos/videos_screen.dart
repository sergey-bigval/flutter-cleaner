import 'package:flutter/material.dart';
import 'package:hello_flutter/presentation/screens/videos/widgets/big_videos_button.dart';

class MyVideosScreen extends StatelessWidget {
  const MyVideosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: BigVideosButton()),
    );
  }
}
