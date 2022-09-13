import 'package:flutter/cupertino.dart';
import 'package:hello_flutter/presentation/screens/videos/widgets/video_found_info.dart';
import 'package:hello_flutter/presentation/screens/videos/widgets/video_list.dart';
import 'package:hello_flutter/themes/app_colors.dart';
import 'package:hello_flutter/utils/logging.dart';
import 'package:lottie/lottie.dart';

import '../../../themes/styles.dart';

class BigVideosScreen extends StatefulWidget {
  const BigVideosScreen({Key? key}) : super(key: key);

  @override
  State<BigVideosScreen> createState() => _BigVideosScreenState();
}

class _BigVideosScreenState extends State<BigVideosScreen> {
  @override
  void initState() {
    super.initState();
    // VideoLogic().loadVideos();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        lol("popping from route disabled");
        return false;
      },
      child: SafeArea(
        child: Container(
          color: AppColors.mainBgColor,
          child: Column(
            children: [
              SizedBox(
                height: 250,
                width: 250,
                child: Lottie.asset("assets/lottie/108977-video-scanning.json"),
              ),
              const Text("Video searching...", style: Styles.titleStyle),
              const VideoFoundInfoWidget(),
              const Expanded(child: VideoList()),
            ],
          ),
        ),
      ),
    );
  }
}
