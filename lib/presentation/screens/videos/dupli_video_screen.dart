import 'package:flutter/material.dart';
import 'package:hello_flutter/presentation/screens/doubles/widgets/duplicate_button.dart';
import 'package:hello_flutter/presentation/screens/doubles/widgets/filtering_info.dart';
import 'package:hello_flutter/presentation/screens/doubles/widgets/photo_list.dart';
import 'package:hello_flutter/presentation/screens/videos/widgets/dupli_video_button.dart';
import 'package:hello_flutter/presentation/screens/videos/widgets/video_found_info.dart';
import 'package:hello_flutter/presentation/screens/videos/widgets/video_list.dart';

class DupliVideoScreen extends StatelessWidget {
  const DupliVideoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 10),
            const Center(child: DupliVideoButton()),
            const SizedBox(height: 5),
            // InkWell(
            //   onTap: () {
            //     // VideoLogic.deleteVideos();
            //   },
            //   child: const Center(
            //       child: SizedBox(
            //     width: 100,
            //     height: 50,
            //     child: Center(child: Text("Delete Video")),
            //   )),
            // ),
            // const SizedBox(height: 10),
            const VideoFoundInfoWidget(),
            const SizedBox(height: 10),
            const Expanded(child: VideoList()),
          ],
        ),
      ),
    );
  }
}
