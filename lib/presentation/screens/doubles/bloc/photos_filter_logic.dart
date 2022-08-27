import 'dart:core';
import 'dart:io';
import 'package:hello_flutter/presentation/screens/doubles/doubles_screen.dart';
import 'package:hello_flutter/utils/logging.dart';
import 'package:photo_manager/photo_manager.dart';

class PhotosFilerLogic {

  Future<List<PhotoModel>> loadPhotos() async {
    int photosCount = 0;
    int videoCount = 0;
    List<AssetEntity> allPhotosEntities = [];
    List<PhotoModel> allPhotos = [];
    List<PhotoModel> plainDoubles = [];

    PermissionState permState = await PhotoManager.requestPermissionExtend();

    if (permState.isAuth) {
      // если есть доступ (т.е. дан пермишен), то можем запрашивать медиа-контент
      List<AssetPathEntity> folders = await PhotoManager.getAssetPathList();
      lol('Number of folders = ${folders.length}');

      for (AssetPathEntity folder in folders) {
        // final subFolders = await folder.getSubPathList();
        // lol('In folder <${folder.name}> are ${subFolders.length} subfolders');
        int num = await folder.assetCountAsync;
        lol('In folder <${folder.name}> are $num files');
        List<AssetEntity> medias = await folder.getAssetListRange(
            start: 0,
            end: num,
        );

        for (AssetEntity mediaFile in medias) {
          File? file = await mediaFile.originFile;
          String path = file?.path ?? 'NON';
          int size = file?.lengthSync() ?? 0;
          String mimeType = mediaFile.mimeType ?? 'NON';
          int timeInSeconds = mediaFile
              .createDateTime.millisecondsSinceEpoch ~/ 1000;

          if (mimeType.contains('image')) {
            photosCount++;
            allPhotosEntities.add(mediaFile);
            allPhotos.add(PhotoModel(
              absolutePath: path,
              size: size,
              timeInSeconds: timeInSeconds,
              isSelected: false,
            ));
          }

          if (mimeType.contains("video")) {
            videoCount++;
          }
          // lol(path);
          // lol(mimeType);
        }
      }

      lol('Found: photos - $photosCount , videos - $videoCount');
      List<List<PhotoModel>> dou = filterPhotosToGetDouble(allPhotos);

      for (List<PhotoModel> row in dou) {
        lol('-----------------------ROW----------------------------');
        for (PhotoModel item in row) {
          lol('----DOUBLE----');
          lol('size = ${item.size}');
          plainDoubles.add(item);
        }
      }

      plainDoubles.sort((m1, m2) {
        if (m1.timeInSeconds > m2.timeInSeconds) return 1;
        if (m1.timeInSeconds < m2.timeInSeconds) return -1;
        return 0;
      });
    }

    return allPhotos;
  }

  List<List<PhotoModel>> filterPhotosToGetDouble(List<PhotoModel> imageList) {
    List<List<PhotoModel>> listOfAllDoubleImages = [];
    List<PhotoModel> doublePhotosList = [];
    int currentIndex = 0;
    bool isNewDoublePhotoList = true;

    while (currentIndex < (imageList.length - 1)) {
      var imageModelCurrent = imageList[currentIndex]; // текущий для сравнения
      var imageModelNext = imageList[currentIndex + 1]; // следующий для сравнения

      int filter1 = (imageModelCurrent.timeInSeconds
          - imageModelNext.timeInSeconds).abs();
      double filter2 = ((imageModelCurrent.size - imageModelNext.size)
          / (imageModelCurrent.size / 2 + imageModelNext.size / 2)).abs();

      if (filter1 < 3 && filter2 < 0.10 && imageModelCurrent.size > 600000) {
        if (isNewDoublePhotoList) {
          doublePhotosList.add(imageList[currentIndex]); // original
          isNewDoublePhotoList = false;
        }
        doublePhotosList.add(imageList[currentIndex + 1]); // double
        currentIndex++;
      } else {
        currentIndex++;

        if (doublePhotosList.length > 1) {
          listOfAllDoubleImages.add(doublePhotosList);
          doublePhotosList = [];
          isNewDoublePhotoList = true;
        }
      }
    }

    return listOfAllDoubleImages;
  }
}
