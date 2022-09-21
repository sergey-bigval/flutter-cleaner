import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hello_flutter/presentation/screens/videos/bloc/big_videos_events.dart';
import 'package:hello_flutter/presentation/screens/videos/models/video_model.dart';
import 'package:hello_flutter/presentation/screens/videos/widgets/video_preview_dialog.dart';
import 'package:hello_flutter/utils/logging.dart';

import '../../../../themes/app_colors.dart';
import '../../../../themes/styles.dart';
import '../bloc/big_videos_bloc.dart';
import '../bloc/big_videos_state.dart';

class VideoList extends StatelessWidget {
  final BigVideosBloc bloc;

  const VideoList({Key? key, required this.bloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _getVideoGrid(context));
  }

  Widget _getVideoGrid(BuildContext context) {
    return GridView.builder(
      itemCount: bloc.videoRepo.allVideos.length,
      scrollDirection: Axis.vertical,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemBuilder: (BuildContext context, int index) {
        return _getVideoItem(context, videoModel: bloc.videoRepo.allVideos[index]);
      },
    );
  }

  Widget _getVideoItem(BuildContext context, {required VideoModel videoModel}) {
    if (videoModel.thumb == null) {
      return const SizedBox(
        height: 25,
        width: 25,
        child: Padding(
          padding: EdgeInsets.all(25),
          child: Icon(Icons.video_file),
        ),
      );
    } else {
      return Stack(
        children: [
          InkWell(
            onTap: () => _showVideoPreviewDialog(context, videoModel),
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
          _getVideoSizeWidget(videoModel),
          Row(children: [
            const Spacer(),
            Visibility(
              visible: bloc.state.isReadyToDelete,
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

  Column _getVideoSizeWidget(VideoModel videoModel) {
    return Column(
      children: [
        const Spacer(),
        Padding(
          padding: const EdgeInsets.all(2),
          child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8), color: AppColors.mainBtnColor),
              child: Padding(
                padding: const EdgeInsets.all(2),
                child: Text('${videoModel.size ~/ 1048576} MB', style: Styles.text16White),
              )),
        ),
      ],
    );
  }

  Future<void> _showVideoPreviewDialog(BuildContext context, VideoModel videoModel) async {
    File? videoFile = await videoModel.entity.originFile;
    if (videoFile == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Cannot load video file")));
      return;
    }

    showDialog(
        context: context,
        builder: (BuildContext context) {
          lol('====================${videoModel.absolutePath}');
          return VideoPreviewDialog(file: videoFile);
        });
  }
}
