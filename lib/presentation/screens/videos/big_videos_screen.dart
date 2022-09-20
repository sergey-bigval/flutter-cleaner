import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hello_flutter/presentation/screens/videos/bloc/big_videos_state.dart';
import 'package:hello_flutter/presentation/screens/videos/widgets/video_found_info.dart';
import 'package:hello_flutter/presentation/screens/videos/widgets/video_found_result.dart';
import 'package:hello_flutter/presentation/screens/videos/widgets/video_list.dart';
import 'package:hello_flutter/themes/app_colors.dart';
import 'package:lottie/lottie.dart';

import '../../../themes/styles.dart';
import 'bloc/big_videos_bloc.dart';
import 'bloc/big_videos_events.dart';

class BigVideosScreen extends StatefulWidget {
  const BigVideosScreen({Key? key}) : super(key: key);

  @override
  State<BigVideosScreen> createState() => _BigVideosScreenState();
}

class _BigVideosScreenState extends State<BigVideosScreen> {
  var _backPressCount = 0;
  late BigVideosBloc _bloc;

  @override
  void initState() {
    _bloc = BigVideosBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _backPressCount++;
        if (_backPressCount < 3) {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Are you sure you want to stop searching?")));
          return false;
        } else {
          return true;
        }
      },
      child: SafeArea(
        child: Container(
          color: AppColors.mainBgColor,
          child: BlocBuilder<BigVideosBloc, BigVideosState>(
            bloc: _bloc,
            buildWhen: (previous, current) => previous.isScanning != current.isScanning,
            builder: (BuildContext context, state) {
              if (state.isScanning) {
                return Column(
                  children: [
                    Expanded(flex: 2, child: Lottie.asset("assets/lottie/108977-video-scanning.json")),
                    const Expanded(flex: 1, child: Center(child: Text("Video searching...", style: Styles.titleStyle))),
                    Expanded(
                      flex: 2,
                      child: BlocBuilder<BigVideosBloc, BigVideosState>(
                        bloc: _bloc,
                        buildWhen: (previous, current) => previous.videosFound != current.videosFound,
                        builder: (BuildContext context, state) {
                          return VideoFoundInfoWidget(
                            videos: state.videosFound,
                            size: state.videosTotalSize,
                            folder: state.currentFolder,
                          );
                        },
                      ),
                    ),
                  ],
                );
              } else {
                return Column(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Row(children: [
                        Lottie.asset("assets/lottie/done_676.json"),
                        const Expanded(
                            flex: 7, child: Center(child: Text("Searching completed!", style: Styles.titleStyle))),
                      ]),
                    ),
                    Expanded(
                      flex: 4,
                      child: BlocBuilder<BigVideosBloc, BigVideosState>(
                        bloc: _bloc,
                        builder: (BuildContext context, state) {
                          return Column(
                            children: [
                              VideoFoundResultWidget(
                                videos: state.videosFound,
                                size: state.videosTotalSize,
                                progress: _bloc.videoRepo.getThumbsMakerProgress(),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 3),
                                child: CupertinoButton(
                                  onPressed: () {
                                    _bloc.add(BigVideosDeleteEvent());
                                  },
                                  color: AppColors.mainBtnColor,
                                  child: const Text('Delete'),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    Expanded(
                        flex: 15,
                        child: BlocBuilder<BigVideosBloc, BigVideosState>(
                            bloc: _bloc,
                            builder: (BuildContext context, state) {
                              return VideoList(bloc: _bloc);
                            })),
                  ],
                );
                ;
              }
            },
          ),
        ),
      ),
    );
  }
}
