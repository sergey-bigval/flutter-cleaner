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
    on<DoublePhotosCancelScanningEvent>(_onCancelScanning);
  }

  List<List<PhotoModel>> totalGroupedDoubles = [];
  List<List<PhotoModel>> totalGroupedDoublesList = [];
  int photosCount = 0;
  int totalGroupedDoublesCount = 0;

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

        List<PhotoModel> folderPhotos = [];
        for (AssetEntity media in mediasInFolder) {
          if (state.isScanningCanceled) return;

          ///////// цикл по файлам в папке
          File? file = await media.originFile;
          String path = file?.path ?? 'NON';
          int size = file?.lengthSync() ?? 0;
          // String mimeType = media.mimeType ?? 'NON';
          int timeInSeconds =
              media.createDateTime.millisecondsSinceEpoch ~/ 1000;

          photosCount++;
          emitter(state.copyWith(
              photosCount: photosCount, imagePath: path, isScanning: true));

          folderPhotos.add(PhotoModel(
              absolutePath: path,
              size: size,
              timeInSeconds: timeInSeconds,
              isSelected: false,
              entity: media));
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
            doublePhotosList: newDoublesList));
      } ///////// цикл по папкам
      emitter(state.copyWith(isScanning: false));
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
    for (var element in listToDelete) {
      lol(element);
    }
    final List<String> result =
        await PhotoManager.editor.deleteWithIds(listToDelete);
    lol("DELETED ============== ${result.length}");

    emitter(state.copyWith(isDeleted: true));
  }

  Future<void> _onCancelScanning(
    DoublePhotosCancelScanningEvent event,
    Emitter emitter,
  ) async {
    emitter(state.copyWith(isScanningCanceled: true));
  }

  void _addCurrentFolderDoublesToTotalCount(
      List<List<PhotoModel>> groupedDoublesInFolder) {
    for (var element in groupedDoublesInFolder) {
      for (var element in element) {
        totalGroupedDoublesCount++;
      }
    }
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

      final isTimeDifferenceSmall = checkTimeDifference(
          imageModelCurrent.timeInSeconds, imageModelNext.timeInSeconds);
      final isSizeDifferenceSmall =
          checkSizeDifference(imageModelCurrent.size, imageModelNext.size);
      final isPhotoSizeOptimal = imageModelCurrent.size > 300000 /*in KB*/;

      // настройка определения дублей (3 степени фильтрации)
      if (isTimeDifferenceSmall &&
          isSizeDifferenceSmall &&
          isPhotoSizeOptimal) {
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

  bool checkTimeDifference(int firstPhotoTime, int secondPhotoTime) {
    const allowableSecondsDifference = 6;
    return (firstPhotoTime - secondPhotoTime).abs() <
        allowableSecondsDifference;
  }

  bool checkSizeDifference(int firstPhotoSize, int secondPhotoSize) {
    var percentOfDifference = 20;
    var percentDifferenceInNumber = 0.0;
    var sizeDifference = 0;
    if (firstPhotoSize > secondPhotoSize) {
      percentDifferenceInNumber = (firstPhotoSize / 100) * percentOfDifference;
      sizeDifference = firstPhotoSize - secondPhotoSize;
    } else {
      percentDifferenceInNumber = (firstPhotoSize / 100) * percentOfDifference;
      sizeDifference = firstPhotoSize - secondPhotoSize;
    }
    return sizeDifference < percentDifferenceInNumber;
  }
}
