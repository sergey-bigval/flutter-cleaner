import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hello_flutter/presentation/screens/videos/bloc/big_videos_state.dart';
import 'package:hello_flutter/presentation/screens/videos/bloc/video_logic.dart';

import 'big_videos_events.dart';

class BigVideosBloc extends Bloc<BigVideosEvent, BigVideosState> {
  late final VideoRepo _videoRepo;

  BigVideosBloc() : super(BigVideosState.initial()) {
    _videoRepo = VideoRepo(bloc: this)..loadVideos();

    on<BigVideosFoundNewEvent>(_onBigVideosFoundNewEvent);
  }

  @override
  Future<void> close() async {
    super.close();
  }

  Future<void> _onBigVideosFoundNewEvent(
    BigVideosFoundNewEvent event,
    Emitter emitter,
  ) async {
    emitter(
      state.copyWith(
        videosFound: event.bigVideosState.videosFound,
        currentFolder: event.bigVideosState.currentFolder,
        videosTotalSize: event.bigVideosState.videosTotalSize,
      ),
    );
  }
}
