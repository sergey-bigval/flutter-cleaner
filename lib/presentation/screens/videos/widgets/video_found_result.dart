import 'package:flutter/material.dart';
import 'package:hello_flutter/themes/styles.dart';

class VideoFoundResultWidget extends StatelessWidget {
  final int videos;
  final int size;
  final double progress;

  const VideoFoundResultWidget({
    Key? key,
    required this.videos,
    required this.size,
    required this.progress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        getFoundVideosText(),
        const SizedBox(height: 5),
        getVideosTotalSizeText(),
        const SizedBox(height: 5),
        Visibility(
            visible: progress != 1.0,
            child: Column(
              children: [
                const Text('Thumbnails creating...', style: Styles.text15),
                LinearProgressIndicator(value: progress),
              ],
            ))
      ],
    );
  }

  Widget getFoundVideosText() => Text(
        'Total videos found: $videos',
        style: Styles.text15,
      );

  Widget getVideosTotalSizeText() => Text(
        'Total size of videos: ${size}MB',
        style: Styles.text15,
      );
}
