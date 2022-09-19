import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hello_flutter/presentation/screens/videos/bloc/big_videos_events.dart';
import 'package:hello_flutter/presentation/screens/videos/bloc/video_model.dart';
import 'package:hello_flutter/utils/logging.dart';
import 'package:video_player/video_player.dart';

import '../../../../themes/app_colors.dart';
import '../../../../themes/styles.dart';
import '../bloc/big_videos_bloc.dart';
import '../bloc/big_videos_state.dart';

class VideoList extends StatelessWidget {
  final BigVideosBloc bloc;

  const VideoList({Key? key, required this.bloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: getVideoGrid(context));
  }

  Widget getVideoGrid(BuildContext context) {
    return GridView.builder(
      itemCount: bloc.videoRepo.allVideos.length,
      scrollDirection: Axis.vertical,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemBuilder: (BuildContext context, int index) {
        return getVideoItem(context, videoModel: bloc.videoRepo.allVideos[index]);
      },
    );
  }

  Widget getVideoItem(BuildContext context, {required VideoModel videoModel}) {
    if (videoModel.thumb == null) {
      return const SizedBox(
        height: 25,
        width: 25,
        child: Padding(
          padding: EdgeInsets.all(25),
          child: CircularProgressIndicator(
            color: Colors.black54,
          ),
        ),
      );
    } else {
      return Stack(
        children: [
          InkWell(
            onTap: () => showVideoDialog(context, videoModel),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: Image.memory(videoModel.thumb!, cacheWidth: 256).image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          getVideoSizeWidget(videoModel),
          Row(children: [
            const Spacer(),
            Visibility(
              visible: bloc.videoRepo.isAllThumbsAvailable(),
              child: BlocBuilder<BigVideosBloc, BigVideosState>(
                bloc: bloc,
                builder: (BuildContext context, state) {
                  return Checkbox(
                    value: bloc.videoRepo.isCheckedById(videoModel.entity.id),
                    onChanged: (isChecked) {
                      if (isChecked!) {
                        bloc.add(BigVideosItemSelectedEvent(id: videoModel.entity.id));
                      } else {
                        bloc.add(BigVideosItemUnSelectedEvent(id: videoModel.entity.id));
                      }
                    },
                  );
                },
              ),
            ),
          ])
        ],
      );
    }
  }

  Column getVideoSizeWidget(VideoModel videoModel) {
    return Column(
      children: [
        const Spacer(),
        Padding(
          padding: const EdgeInsets.all(2),
          child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: AppColors.mainBtnColor
              ),
              child: Padding(
                padding: const EdgeInsets.all(2),
                child: Text(
            '${videoModel.size ~/ 1048576} MB',
            style: Styles.text16White,
          ),
              )),
        ),
      ],
    );
  }

  Future<void> showVideoDialog(BuildContext context, VideoModel videoModel) async {
    File? file = await videoModel.entity.originFile;
    VideoPlayerController controller = VideoPlayerController.file(file!);
    controller.initialize();
    controller.seekTo(const Duration(seconds: 2));
    controller.play();

    final chewieController = ChewieController(
      videoPlayerController: controller,
      allowMuting: false,
      allowFullScreen: false,
      aspectRatio: 2,
      autoPlay: true,
      looping: true,
      showOptions: false,
    );
    final playerWidget = Chewie(controller: chewieController);

    showDialog(
        context: context,
        builder: (BuildContext context) {
          lol('====================${videoModel.absolutePath}');
          return AlertDialog(
            title: const Padding(padding: EdgeInsets.only(bottom: 20), child: Center(child: Text("Video preview"))),
            contentPadding: const EdgeInsets.all(1),
            insetPadding: const EdgeInsets.all(10),
            content: AspectRatio(aspectRatio: 2, child: playerWidget),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    releaseControllers(controller, chewieController);
                    Navigator.of(context).pop();
                  },
                  child: const Text("Dismiss")),
            ],
          );
        }).then((value) {
      releaseControllers(controller, chewieController);
    });
  }

  void releaseControllers(VideoPlayerController controller, ChewieController chewieController) {
    controller.pause();
    chewieController.pause();
    controller.dispose();
    chewieController.dispose();
  }
}
