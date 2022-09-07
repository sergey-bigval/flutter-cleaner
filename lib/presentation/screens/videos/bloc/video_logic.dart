import 'dart:io';

import 'package:hello_flutter/presentation/screens/doubles/doubles_screen.dart';
import 'package:hello_flutter/presentation/screens/videos/bloc/video_controller.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../../../../utils/logging.dart';

class VideoLogic {
  int videosCount = 0;
  List<List<PhotoModel>> totalGroupedDoubles = [];
  int totalGroupedDoublesCount = 0;

  static List<List<PhotoModel>> totalGroupedDoublesStatic = [];

  static Future<void> deleteVideos() async {
    lol("deletePhotos() async --===--");
    List<String> listToDelete = [];
    for (List<PhotoModel> list in totalGroupedDoublesStatic) {
      for (PhotoModel photo in list) {
        if (photo.isSelected) {
          lol("ADDED === ${photo.entity.id}");
          listToDelete.add(photo.entity.id);
        }
      }
    }
    lol("PREPARE ===== listToDelete.length = ${listToDelete.length} / list below:");
    listToDelete.forEach((element) {
      lol(element);
    });
    final List<String> result = await PhotoManager.editor.deleteWithIds(listToDelete);
    lol("DELETED ============== ${result.length}");
  }

  Future<void> loadVideos() async {
    PermissionState permState = await PhotoManager.requestPermissionExtend();

    if (permState.isAuth) {
      List<VideoModel> allVideos = [];
      // если есть доступ (т.е. дан пермишен), то можем запрашивать медиа-контент
      List<AssetPathEntity> allFolders = await PhotoManager.getAssetPathList(type: RequestType.video);

      for (AssetPathEntity folder in allFolders) {
        ///////// цикл по папкам
        if (Platform.isAndroid && folder.name == "Recent") continue;

        int countOfAssets = await folder.assetCountAsync;
        List<AssetEntity> mediasInFolder = await folder.getAssetListRange(start: 0, end: countOfAssets);

        VideoController.videosCount.value = VideoController.videosCount.value.copyWith(folder: folder.name);

        for (AssetEntity media in mediasInFolder) {
          ///////// цикл по файлам в папке
          File? file = await media.originFile;
          String path = file?.path ?? 'NON';
          int size = file?.lengthSync() ?? 0;
          int timeInSeconds = media.createDateTime.millisecondsSinceEpoch ~/ 1000;

          videosCount++;
          VideoController.videosCount.value = VideoController.videosCount.value.copyWith(videoCount: videosCount);
          // VideoController.videos.value = allVideos.length;
          final uint8list = await VideoThumbnail.thumbnailData(
            video: path,
            imageFormat: ImageFormat.JPEG,
            maxWidth: 256,
            // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
            quality: 25,
          );
          allVideos.add(VideoModel(
              absolutePath: path, size: size, timeInSeconds: timeInSeconds, entity: media, thumb: uint8list));
          lol("ADDED === " + path);
          List<VideoModel> currentVideos = [];
          currentVideos.addAll(allVideos);
          VideoController.videos.value = currentVideos;
        } ///////// цикл по файлам в папке
      } ///////// цикл по папкам
      allVideos.sort((v1, v2) {
        if (v1.size > v2.size) return -1;
        if (v1.size < v2.size) return 1;
        return 0;
      });
    }
  }
}
