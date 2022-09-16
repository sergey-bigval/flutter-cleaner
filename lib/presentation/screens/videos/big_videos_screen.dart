import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hello_flutter/presentation/screens/videos/bloc/big_videos_state.dart';
import 'package:hello_flutter/presentation/screens/videos/widgets/video_found_info.dart';
import 'package:hello_flutter/themes/app_colors.dart';
import 'package:lottie/lottie.dart';

import '../../../themes/styles.dart';
import 'bloc/big_videos_bloc.dart';

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
          child: Column(
            children: [
              Expanded(flex: 2, child: Lottie.asset("assets/lottie/108977-video-scanning.json")),
              const Expanded(flex: 1, child: Center(child: Text("Video searching...", style: Styles.titleStyle))),
              Expanded(
                flex: 2,
                child: BlocBuilder<BigVideosBloc, BigVideosState>(
                  bloc: _bloc,
                  builder: (BuildContext context, state) {
                    return VideoFoundInfoWidget(
                      videos: state.videosFound,
                      size: state.videosTotalSize,
                      folder: state.currentFolder,
                    );
                  },
                ),
              ),
              // const Expanded(flex: 1, child: VideoList()),
            ],
          ),
        ),
      ),
    );
  }
}
