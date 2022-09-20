import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class PhotoModel {
  PhotoModel({
    required this.absolutePath,
    required this.size,
    required this.timeInSeconds,
    required this.isSelected,
    required this.entity,
  });

  String absolutePath;
  int size;
  int timeInSeconds;
  bool isSelected = false;
  final checkboxState = ValueNotifier<bool>(false); //Initialized to false
  AssetEntity entity;
}
