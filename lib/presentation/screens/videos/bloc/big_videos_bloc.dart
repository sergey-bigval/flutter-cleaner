import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hello_flutter/presentation/screens/videos/bloc/big_videos_state.dart';
import 'package:hello_flutter/presentation/screens/videos/bloc/video_model.dart';
import 'package:hello_flutter/presentation/screens/videos/bloc/video_repo.dart';
import 'package:video_compress/video_compress.dart';

import '../../../../utils/logging.dart';
import 'big_videos_events.dart';

class BigVideosBloc extends Bloc<BigVideosEvent, BigVideosState> {
  late final VideoRepo videoRepo;

  BigVideosBloc() : super(BigVideosState.initial()) {
    videoRepo = VideoRepo(bloc: this)..loadVideos();

    on<BigVideosFoundNewEvent>(_onBigVideosFoundNewEvent);
    on<BigVideosScanFinishEvent>(_onBigVideosScanFinishEvent);
    on<BigVideosThumbDoneEvent>(_onBigVideosThumbDoneEvent);
    on<BigVideosItemSelectedEvent>(_onBigVideosItemSelectedEvent);
    on<BigVideosItemUnSelectedEvent>(_onBigVideosItemUnSelectedEvent);
    on<BigVideosDeleteEvent>(_onBigVideosDeleteEvent);
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

  Future<void> _onBigVideosScanFinishEvent(
    BigVideosScanFinishEvent event,
    Emitter emitter,
  ) async {
    emitter(
      state.copyWith(isScanning: false),
    );
    await _setThumbs();
  }

  Future<void> _setThumbs() async {
    var i = 0;
    for (VideoModel m in videoRepo.allVideos) {
      m.thumb = await _getThumb(m.absolutePath);
      videoRepo.thumbsAvailable++;
      add(BigVideosThumbDoneEvent());
      lol("======= Video #${++i} thumb ADDED ${m.thumb?.length}");
    }
    lol("======= All thumbs  DONE");
  }

  Future<Uint8List?> _getThumb(String path) async {
    try {
      final uInt8list = await VideoCompress.getByteThumbnail(path, quality: 25, position: -1)
          .timeout(const Duration(seconds: 2), onTimeout: () {
        return null;
      });
      return uInt8list;
    } catch (e) {
      return null;
    }
  }

  Future<void> _onBigVideosThumbDoneEvent(
    BigVideosThumbDoneEvent event,
    Emitter emitter,
  ) async {
    emitter(state.copyWith(currentFolder: ''));
  }

  Future<void> _onBigVideosItemSelectedEvent(
    BigVideosItemSelectedEvent event,
    Emitter emitter,
  ) async {
    lol("SELECT ${event.id}");
    videoRepo.add(event.id);
    emitter(state.copyWith(currentFolder: ''));
  }

  Future<void> _onBigVideosItemUnSelectedEvent(
    BigVideosItemUnSelectedEvent event,
    Emitter emitter,
  ) async {
    lol("UN SELECT ${event.id}");
    videoRepo.remove(event.id);
    emitter(state.copyWith(currentFolder: ''));
  }

  Future<void> _onBigVideosDeleteEvent(
      BigVideosDeleteEvent event,
      Emitter emitter,
      ) async {
    await videoRepo.deleteSelected();
    emitter(state.copyWith(currentFolder: ''));
  }
}
