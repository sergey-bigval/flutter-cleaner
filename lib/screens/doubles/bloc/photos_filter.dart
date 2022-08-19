import 'dart:core';

import 'package:hello_flutter/screens/doubles/doubles_screen.dart';

List<List<PhotoModel>> filterPhotosToGetDouble(List<PhotoModel> imageList) {
  List<List<PhotoModel>> listOfAllDoubleImages = [];
  List<PhotoModel> doublePhotosList = [];
  var currentIndex = 0;
  var isNewDoublePhotoList = true;
  while (currentIndex < (imageList.length - 1)) {
    var imageModelCurrent = imageList[currentIndex]; // текущий для сравнения
    var imageModelNext = imageList[currentIndex + 1]; // следующий для сравнения
    int filter1 = (imageModelCurrent.timeInSeconds - imageModelNext.timeInSeconds).abs();
    double filter2 =
        ((imageModelCurrent.size - imageModelNext.size) / (imageModelCurrent.size / 2 + imageModelNext.size / 2)).abs();

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
