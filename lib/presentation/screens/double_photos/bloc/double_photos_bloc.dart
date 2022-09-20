import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hello_flutter/presentation/screens/double_photos/bloc/events.dart';
import 'package:hello_flutter/presentation/screens/double_photos/bloc/state.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../../../utils/logging.dart';
import '../models/photo_model.dart';

class DoublePhotosBloc extends Bloc<DoublePhotosEvent, DoublePhotosState> {
  DoublePhotosBloc() : super(DoublePhotosState.initial()) {
    on<DoublePhotosLoadPhotosEvent>(_onLoadPhotos);
    on<DoublePhotosDeletePhotosEvent>(_onDeletePhotos);
  }

  int photosCount = 0;
  List<List<PhotoModel>> totalGroupedDoubles = [];
  int totalGroupedDoublesCount = 0;

  List<List<PhotoModel>> totalGroupedDoublesList = [];

  Future<void> _onLoadPhotos(
    DoublePhotosLoadPhotosEvent event,
    Emitter emitter,
  ) async {
    PermissionState permState = await PhotoManager.requestPermissionExtend();

    if (permState.isAuth) {
      // если есть доступ (т.е. дан пермишен), то можем запрашивать медиа-контент
      List<AssetPathEntity> allFolders =
          await PhotoManager.getAssetPathList(type: RequestType.image);

      for (AssetPathEntity folder in allFolders) {
        ///////// цикл по папкам
        if (Platform.isAndroid && folder.name == "Recent") continue;

        int countOfAssets = await folder.assetCountAsync;
        List<AssetEntity> mediasInFolder =
            await folder.getAssetListRange(start: 0, end: countOfAssets);

        emitter(state.copyWith(folderName: folder.name));
        List<PhotoModel> folderPhotos = [];
        for (AssetEntity media in mediasInFolder) {
          ///////// цикл по файлам в папке
          File? file = await media.originFile;
          String path = file?.path ?? 'NON';
          int size = file?.lengthSync() ?? 0;
          // String mimeType = media.mimeType ?? 'NON';
          int timeInSeconds =
              media.createDateTime.millisecondsSinceEpoch ~/ 1000;

          // if (mimeType.contains('image')) {
          photosCount++;
          emitter(state.copyWith(photosCount: photosCount));

          folderPhotos.add(PhotoModel(
              absolutePath: path,
              size: size,
              timeInSeconds: timeInSeconds,
              isSelected: false,
              entity: media));
          // }

        } ///////// цикл по файлам в папке

        folderPhotos.sort((m1, m2) {
          if (m1.timeInSeconds > m2.timeInSeconds) return 1;
          if (m1.timeInSeconds < m2.timeInSeconds) return -1;
          return 0;
        });

        List<List<PhotoModel>> groupedDoublesInFolder =
            _getGroupedDuplicatesInFolder(photos: folderPhotos);
        totalGroupedDoubles.addAll(groupedDoublesInFolder);
        _addCurrentFolderDoublesToTotalCount(groupedDoublesInFolder);

        List<List<PhotoModel>> newDoublesList = [];
        newDoublesList.addAll(totalGroupedDoubles);
        totalGroupedDoublesList.addAll(newDoublesList); //////////////

        emitter(state.copyWith(
          photosCount: photosCount,
          doublePhotosCount: totalGroupedDoublesCount,
          folderName: folder.name,
          doublePhotosList: newDoublesList,
        ));
      } ///////// цикл по папкам
    }
  }

  Future<void> _onDeletePhotos(
    DoublePhotosDeletePhotosEvent event,
    Emitter emitter,
  ) async {
    lol("deletePhotos() async --===--");
    List<String> listToDelete = [];
    for (List<PhotoModel> list in totalGroupedDoublesList) {
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
    final List<String> result =
        await PhotoManager.editor.deleteWithIds(listToDelete);
    lol("DELETED ============== ${result.length}");
  }

  void _addCurrentFolderDoublesToTotalCount(
      List<List<PhotoModel>> groupedDoublesInFolder) {
    groupedDoublesInFolder.forEach((element) {
      element.forEach((element) {
        totalGroupedDoublesCount++;
      });
    });
  }

  List<List<PhotoModel>> _getGroupedDuplicatesInFolder({
    required List<PhotoModel> photos,
  }) {
    List<List<PhotoModel>> dou = filterPhotosToGetDouble(photos);
    return dou;
  }

  List<List<PhotoModel>> filterPhotosToGetDouble(List<PhotoModel> imageList) {
    List<List<PhotoModel>> listOfAllDoubleImages = [];
    List<PhotoModel> doublePhotosList = [];
    int currentIndex = 0;
    bool isNewDoublePhotoList = true;

    while (currentIndex < (imageList.length - 1)) {
      var imageModelCurrent = imageList[currentIndex]; // текущий для сравнения
      var imageModelNext =
          imageList[currentIndex + 1]; // следующий для сравнения

      int filter1 =
          (imageModelCurrent.timeInSeconds - imageModelNext.timeInSeconds)
              .abs();
      double filter2 = ((imageModelCurrent.size - imageModelNext.size) /
              (imageModelCurrent.size / 2 + imageModelNext.size / 2))
          .abs();

      // настройка определения дублей (3 степени фильтрации)
      if (filter1 < 3 && filter2 < 0.05 && imageModelCurrent.size > 600000) {
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
