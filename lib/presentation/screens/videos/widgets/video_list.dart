import 'package:flutter/material.dart';
import 'package:hello_flutter/presentation/screens/videos/bloc/video_controller.dart';

class VideoList extends StatelessWidget {
  const VideoList({super.key});

  @override
  Widget build(BuildContext context) {
    return getVideoGrid();
  }

  Widget getVideoGrid() {
    return ValueListenableBuilder<List<VideoModel>>(
      valueListenable: VideoController.videos,
      builder: (context, videoList, _) {
        return GridView.builder(
          itemCount: videoList.length,
          scrollDirection: Axis.vertical,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
          ),
          itemBuilder: (BuildContext context, int index) {
            return getVideoItem(videoModel: videoList[index]);
          },
        );
      },
    );
  }

  Widget getVideoItem({required VideoModel videoModel}) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              image: Image.memory(videoModel.thumb!, cacheWidth: 256).image,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Row(children: [
          const Spacer(),
          Checkbox(
            value: false,
            onChanged: (value) {
              // photoModel.isSelected = value ?? false;
              // photoModel.isSelectedVN.value = photoModel.isSelected;
            },
          ),
        ])
      ],
    );
  }
}
