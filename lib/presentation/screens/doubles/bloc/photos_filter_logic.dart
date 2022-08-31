import 'dart:core';
import 'dart:io';

import 'package:hello_flutter/models/photo_filter_info.dart';
import 'package:hello_flutter/presentation/screens/doubles/bloc/photos_controller.dart';
import 'package:hello_flutter/presentation/screens/doubles/doubles_screen.dart';
import 'package:hello_flutter/utils/logging.dart';
import 'package:photo_manager/photo_manager.dart';

class PhotosFilerLogic {
  Future<void> loadPhotos() async {
    int photosCount = 0;
    int videoCount = 0;
    List<AssetEntity> allPhotosEntities = [];
    List<PhotoModel> allPhotos = [];
    List<PhotoModel> plainDoubles = [];
    List<PhotoModel> totalPlainDoubles = [];

    PermissionState permState = await PhotoManager.requestPermissionExtend();

    if (permState.isAuth) {
      // если есть доступ (т.е. дан пермишен), то можем запрашивать медиа-контент
      List<AssetPathEntity> folders = await PhotoManager.getAssetPathList();
      lol('Number of folders = ${folders.length}');

      for (AssetPathEntity folder in folders) {
        ///////// цикл по папкам
        int num = await folder.assetCountAsync;
        lol('In folder <${folder.name}> are $num files');
        List<AssetEntity> mediasInFolder = await folder.getAssetListRange(start: 0, end: num);

        PhotosController.filterCounter.value = PhotosController.filterCounter.value.copyWith(folder: folder.name);
        List<PhotoModel> folderPhotos = [];
        for (AssetEntity media in mediasInFolder) {
          ///////// цикл по файлам в папке
          File? file = await media.originFile;
          String path = file?.path ?? 'NON';
          int size = file?.lengthSync() ?? 0;
          String mimeType = media.mimeType ?? 'NON';
          int timeInSeconds = media.createDateTime.millisecondsSinceEpoch ~/ 1000;

          if (mimeType.contains('image')) {
            photosCount++;
            PhotosController.filterCounter.value =
                PhotosController.filterCounter.value.copyWith(photoCount: photosCount);

            allPhotosEntities.add(media);
            allPhotos.add(PhotoModel(
              // возможно удалить
              absolutePath: path,
              size: size,
              timeInSeconds: timeInSeconds,
              isSelected: false,
            ));
            folderPhotos.add(PhotoModel(
              absolutePath: path,
              size: size,
              timeInSeconds: timeInSeconds,
              isSelected: false,
            ));
          }
        } ///////// цикл по файлам в папке
        lol("folderPhotos.length = ${folderPhotos.length}");
        var plainDoublesInFolder = _getDuplicatesInFolder(photos: folderPhotos);
        totalPlainDoubles.addAll(plainDoublesInFolder);

        PhotosController.duplicatedPhotos.value = totalPlainDoubles;
        PhotosController.filterCounter.value = PhotoFilterInfo(
          photoCount: photosCount,
          duplicateCount: totalPlainDoubles.length,
        );
      } ///////// цикл по папкам
    }
  }

  List<PhotoModel> _getDuplicatesInFolder({
    required List<PhotoModel> photos,
  }) {
    List<PhotoModel> plainDoublesInFolder = [];
    List<List<PhotoModel>> dou = filterPhotosToGetDouble(photos);

    for (List<PhotoModel> row in dou) {
      lol('-----------------------ROW----------------------------');
      for (PhotoModel item in row) {
        lol('----DOUBLE----');
        lol('size = ${item.size}');
        plainDoublesInFolder.add(item);
      }
    }

    return plainDoublesInFolder;
  }

  List<List<PhotoModel>> filterPhotosToGetDouble(List<PhotoModel> imageList) {
    List<List<PhotoModel>> listOfAllDoubleImages = [];
    List<PhotoModel> doublePhotosList = [];
    int currentIndex = 0;
    bool isNewDoublePhotoList = true;

    while (currentIndex < (imageList.length - 1)) {
      var imageModelCurrent = imageList[currentIndex]; // текущий для сравнения
      var imageModelNext = imageList[currentIndex + 1]; // следующий для сравнения

      int filter1 = (imageModelCurrent.timeInSeconds - imageModelNext.timeInSeconds).abs();
      double filter2 =
          ((imageModelCurrent.size - imageModelNext.size) / (imageModelCurrent.size / 2 + imageModelNext.size / 2))
              .abs();

      if (filter1 < 3 && filter2 < 0.05 && imageModelCurrent.size > 100000) {
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
