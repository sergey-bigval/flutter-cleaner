import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hello_flutter/presentation/screens/videos/bloc/video_controller.dart';
import 'package:video_player/video_player.dart';

class VideoList extends StatelessWidget {
  const VideoList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: getVideoGrid(context));
  }

  Widget getVideoGrid(BuildContext context) {
    return ValueListenableBuilder<List<VideoModel>>(
      valueListenable: VideoController.videos,
      builder: (context, videoList, _) {
        return GridView.builder(
          itemCount: videoList.length,
          scrollDirection: Axis.vertical,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
          ),
          itemBuilder: (BuildContext context, int index) {
            return getVideoItem(context, videoModel: videoList[index]);
          },
        );
      },
    );
  }

  Widget getVideoItem(BuildContext context, {required VideoModel videoModel}) {
    return Stack(
      children: [
        InkWell(
          onTap: () {
            showVideoDialog(context, videoModel);
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: Image.memory(videoModel.thumb!, cacheWidth: 128).image,
                fit: BoxFit.cover,
              ),
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

  Future<void> showVideoDialog(BuildContext context, VideoModel videoModel) async {
    File? file = await videoModel.entity.originFile;
    VideoPlayerController controller = VideoPlayerController.file(file!);
    controller.initialize();
    controller.seekTo(Duration(seconds: 2));
    controller.play();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Showing video"),
            content: AspectRatio(aspectRatio: controller.value.aspectRatio, child: VideoPlayer(controller)),
            actions: [
              ElevatedButton(onPressed: () => Navigator.of(context).pop(), child: const Text("Dismiss")),
            ],
          );
        });
  }
}
