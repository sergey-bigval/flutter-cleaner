import 'package:flutter/cupertino.dart';
import 'package:hello_flutter/themes/styles.dart';

import '../bloc/video_controller.dart';
import '../models/video_found_info.dart';

class VideoFoundInfoWidget extends StatelessWidget {
  const VideoFoundInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<VideoFoundInfo>(
        valueListenable: VideoController.videosCount,
        builder: (context, info, _) {
          return Column(
            children: [
              getFoundVideosText(info.videoCount),
              const SizedBox(height: 5),
              getCurrentFolderText(info.folder),
            ],
          );
        });
  }

  Widget getFoundVideosText(int count) => Text(
        'Found videos : $count',
        style: Styles.text15,
      );

  Widget getCurrentFolderText(String folder) => Center(
          child: Text(
        'Scanning in folder : \n $folder',
        style: Styles.text15,
      ));
}
