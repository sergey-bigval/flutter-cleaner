import 'package:flutter/material.dart';
import 'package:hello_flutter/models/photo_filter_info.dart';
import 'package:hello_flutter/presentation/screens/doubles/bloc/photos_controller.dart';
import 'package:hello_flutter/presentation/screens/videos/bloc/video_controller.dart';

import '../../../../models/video_found_info.dart';

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

  Widget getFoundVideosText(int count) => Text('Found videos : $count');

  Widget getCurrentFolderText(String folder) => Center(child: Text('Scanning in folder : \n $folder'));
}
