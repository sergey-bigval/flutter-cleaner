import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:hello_flutter/utils/logging.dart';
import 'package:video_player/video_player.dart';

class VideoPreviewDialog extends StatefulWidget {
  final File file;

  const VideoPreviewDialog({required this.file, Key? key}) : super(key: key);

  @override
  State<VideoPreviewDialog> createState() => _VideoPreviewDialogState(file: file);
}

class _VideoPreviewDialogState extends State<VideoPreviewDialog> {
  final File file;
  late VideoPlayerController controller;
  late ChewieController chewieController;

  _VideoPreviewDialogState({required this.file});

  @override
  void initState() {
    super.initState();

    controller = VideoPlayerController.file(file);
    controller.initialize();
    controller.seekTo(const Duration(seconds: 2));
    controller.play();

    chewieController = ChewieController(
      videoPlayerController: controller,
      allowMuting: false,
      allowFullScreen: false,
      aspectRatio: 2,
      autoPlay: true,
      looping: true,
      showOptions: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final playerWidget = Chewie(controller: chewieController);
    return AlertDialog(
      title: const Padding(
          padding: EdgeInsets.only(bottom: 20), child: Center(child: Text("Video preview"))),
      contentPadding: const EdgeInsets.all(1),
      insetPadding: const EdgeInsets.all(10),
      content: AspectRatio(aspectRatio: 2, child: playerWidget),
      actions: [
        ElevatedButton(
            onPressed: () {
              controller.pause();
              chewieController.pause();
              Navigator.of(context).pop();
            },
            child: const Text("Dismiss")),
      ],
    );
  }

  @override
  void dispose() {
    lol('RELEASE PLAYER on dispose');
    _releaseControllers(controller, chewieController);
    super.dispose();
  }

  void _releaseControllers(VideoPlayerController controller, ChewieController chewieController) {
    controller.pause();
    chewieController.pause();
    controller.dispose();
    chewieController.dispose();
  }
}
