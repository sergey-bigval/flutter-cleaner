import 'dart:io';
import 'dart:typed_data';

import 'package:hello_flutter/presentation/screens/videos/bloc/big_videos_state.dart';
import 'package:hello_flutter/presentation/screens/videos/models/video_model.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:video_compress/video_compress.dart';

import '../../../../utils/logging.dart';
import 'big_videos_bloc.dart';
import 'big_videos_events.dart';

class VideoRepo {
  late final BigVideosBloc bloc;

  VideoRepo({required this.bloc});

  int videosCount = 0;
  int videosTotalSizeInMB = 0;
  List<VideoModel> allVideos = [];
  int thumbsAvailable = 0;
  final Set<String> _idsToDelete = {};



  Future<void> loadVideos() async {
    PermissionState permState = await PhotoManager.requestPermissionExtend();
    if (permState.isAuth) {
      allVideos.clear();
      thumbsAvailable = 0;
      _idsToDelete.clear();
      List<AssetPathEntity> allFolders =
          await PhotoManager.getAssetPathList(type: RequestType.video);

      for (AssetPathEntity folder in allFolders) {
        ///////// цикл по папкам
        if (Platform.isAndroid && folder.name == "Recent") continue;

        int countOfAssets = await folder.assetCountAsync;
        List<AssetEntity> mediasInFolder =
            await folder.getAssetListRange(start: 0, end: countOfAssets);

        for (AssetEntity media in mediasInFolder) {
          if (bloc.state.isJobCancelled) {
            lol('SEARCHING CANCELLED');
            return;
          }
          ///////// цикл по файлам в папке
          File? file = await media.originFile;
          String path = file?.path ?? 'NON';
          int size = file?.lengthSync() ?? 0;
          int timeInSeconds = media.createDateTime.millisecondsSinceEpoch ~/ 1000;

          videosCount++;
          videosTotalSizeInMB += size ~/ 1048576;
          lol("VIDEO SIZE = $size");
          lol("VIDEOs TOTAL SIZE = $videosTotalSizeInMB MB");
          allVideos.add(VideoModel(
            absolutePath: path,
            size: size,
            timeInSeconds: timeInSeconds,
            entity: media,
            thumb: null,
          ));
          final bvs = BigVideosState(
            isScanning: true,
            videosFound: allVideos.length,
            videosTotalSize: videosTotalSizeInMB,
            currentFolder: folder.name,
            isReadyToDelete: false,
            isJobCancelled: false,
          );
          bloc.add(BigVideosFoundNewEvent(bigVideosState: bvs));
          lol("ADDED === $path");
          List<VideoModel> currentVideos = [];
          currentVideos.addAll(allVideos);

          if (videosCount > 60) {
            // чтобы побыстрее тестить //////////////////////// not RELEASE
            allVideos.sort((v1, v2) {
              if (v1.size > v2.size) return -1;
              if (v1.size < v2.size) return 1;
              return 0;
            });
            bloc.add(BigVideosScanFinishEvent());
            return;
          }
        } ///////// цикл по файлам в папке
      } ///////// цикл по папкам

      allVideos.sort((v1, v2) {
        if (v1.size > v2.size) return -1;
        if (v1.size < v2.size) return 1;
        return 0;
      });
      bloc.add(BigVideosScanFinishEvent());
    }
  }

  Future<void> setThumbs() async {
    var i = 0;
    for (VideoModel m in allVideos) {
      if (bloc.state.isJobCancelled) {
        lol('THUMBNAILING CANCELLED');
        return;
      }
      m.thumb = await _getThumb(m.absolutePath);
      thumbsAvailable++;
      bloc.add(BigVideosThumbDoneEvent());
      lol("======= Video #${++i} thumb ADDED ${m.thumb?.length}");
    }
    lol("======= All thumbs  DONE");
  }

  Future<Uint8List?> _getThumb(String path) async {
    try {
      final uInt8list = await VideoCompress.getByteThumbnail(path, quality: 25, position: -1)
          .timeout(const Duration(seconds: 5), onTimeout: () {
        return null;
      });
      return uInt8list;
    } catch (e) {
      return null;
    }
  }

  double getThumbsMakerProgress() {
    return thumbsAvailable / allVideos.length;
  }

  Future<void> deleteSelected() async {
    /////////////////////////////////////////
    final List<String> deletedIds = await PhotoManager.editor.deleteWithIds(_idsToDelete.toList());
    lol('DELETED ${deletedIds.length} videos');
    for (var id in deletedIds) {
      allVideos.removeWhere((element) => element.entity.id == id);
      lol('DELETED VIDEO # $id');
      _idsToDelete.remove(id);
    }
  }

  void addToRemoveList(String id) {
    _idsToDelete.add(id);
  }

  void takeFromRemoveList(String id) {
    _idsToDelete.remove(id);
  }

  bool isCheckedById(String id) {
    return _idsToDelete.contains(id);
  }
}
