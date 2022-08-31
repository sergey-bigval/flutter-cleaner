import 'dart:collection';
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
    // List<PhotoModel> plainDoubles = [];
    HashSet<PhotoModel> plainDoubles = HashSet();

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

        List<List<AssetEntity>> mediasByHundreds = _getMediaByHundreds(medias);

        for (List<AssetEntity> hundred in mediasByHundreds) {
          for (AssetEntity media in hundred) {
            File? file = await media.originFile;
            String path = file?.path ?? 'NON';
            int size = file?.lengthSync() ?? 0;
            String mimeType = media.mimeType ?? 'NON';
            int timeInSeconds = media
                .createDateTime.millisecondsSinceEpoch ~/ 1000;

            if (mimeType.contains('image')) {
              photosCount++;
              PhotosController.filterCounter.value = PhotoFilterInfo(
                  photoCount: photosCount,
                  duplicateCount: PhotosController.filterCounter
                      .value.duplicateCount
              );

              allPhotosEntities.add(media);
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

            List<PhotoModel> newDuplicates = [];

            if (allPhotos.length > 100 && allPhotos.length % 100 == 0) {
              newDuplicates = _getDuplicates(
                photos: [...allPhotos.getRange(
                    _getStartRange(allPhotos.length),
                    allPhotos.indexOf(allPhotos.last))],
                photosCount: photosCount,
                videoCount: videoCount,
              );
            } else {
              newDuplicates = _getDuplicates(
                photos: allPhotos,
                photosCount: photosCount,
                videoCount: videoCount,
              );

            }

            plainDoubles.addAll(newDuplicates);

            // plainDoubles.sort((m1, m2) {
            //   if (m1.timeInSeconds > m2.timeInSeconds) return 1;
            //   if (m1.timeInSeconds < m2.timeInSeconds) return -1;
            //   return 0;
            // });
            // plainDoubles.forEach((element) {lol('element is ${element.hashCode} and ${element.size}');});
          }
          List<PhotoModel> finalList = plainDoubles.toList();
          finalList.sort((m1, m2) {
            if (m1.timeInSeconds > m2.timeInSeconds) return 1;
            if (m1.timeInSeconds < m2.timeInSeconds) return -1;
            return 0;
          });
          PhotosController.duplicatedPhotos.value = finalList;
        }
      }
    }
  }

  List<List<AssetEntity>> _getMediaByHundreds(List<AssetEntity> mediaList) {
    List<List<AssetEntity>> hundredsList= [];

    int hundreds = mediaList.length ~/ 100;
    
    lol('hundreads ${hundreds}');
    lol('mediaList ${mediaList}');

    if (hundreds == 0) {
      hundredsList.add(mediaList);
    } else {
      for (int i = 0; i < hundreds; i++) {
        hundredsList.add(mediaList.getRange(
            i == 0 ? 0 : (i * 100) + 1,
            mediaList.length <= ((i * 100) + 99)
                ? mediaList.length 
                : (i * 100) + 99).toList()
        );
      }
    }

    return hundredsList;
  }

  int _getStartRange(int allPhotosLength) {
    int hundreds = allPhotosLength ~/ 100;

    return hundreds == 1
        ? 0
        : (hundreds * 100) - 1;
  }

  List<PhotoModel> _getDuplicates({
    required int photosCount,
    required int videoCount,
    required List<PhotoModel> photos,
  }) {
    List<PhotoModel> plainDoubles = [];

    lol('Found: photos - $photosCount , videos - $videoCount');
    List<List<PhotoModel>> dou = filterPhotosToGetDouble(photos);

    for (List<PhotoModel> row in dou) {
      // lol('-----------------------ROW----------------------------');
      for (PhotoModel item in row) {
        // lol('----DOUBLE----');
        // lol('size = ${item.size}');
        plainDoubles.add(item);

        PhotosController.filterCounter.value = PhotoFilterInfo(
          photoCount: PhotosController.filterCounter
              .value.photoCount,
          duplicateCount: plainDoubles.length,
        );
      }
    }

    return plainDoubles;
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

      if (filter1 < 3 && filter2 < 0.10 && imageModelCurrent.size > 100000) {
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
