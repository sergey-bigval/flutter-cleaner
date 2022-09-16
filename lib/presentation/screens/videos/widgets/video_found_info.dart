import 'package:flutter/cupertino.dart';
import 'package:hello_flutter/themes/styles.dart';

class VideoFoundInfoWidget extends StatelessWidget {
  final int videos;
  final int size;
  final String folder;

  const VideoFoundInfoWidget({
    Key? key,
    required this.videos,
    required this.size,
    required this.folder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Searching in folder:', style: Styles.text15),
        getCurrentFolderText(),
        const SizedBox(height: 20),
        getFoundVideosText(),
        const SizedBox(height: 5),
        getVideosTotalSizeText(),
      ],
    );
  }

  Widget getFoundVideosText() => Text(
        'Videos found: $videos',
        style: Styles.text15,
      );

  Widget getVideosTotalSizeText() => Text(
        'Total size of videos: ${size}MB',
        style: Styles.text15,
      );

  Widget getCurrentFolderText() => Center(child: Text(folder, style: Styles.text15));
}
