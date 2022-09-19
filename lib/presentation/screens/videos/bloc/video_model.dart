import 'dart:typed_data';

import 'package:photo_manager/photo_manager.dart';

class VideoModel {
  VideoModel({
    required this.absolutePath,
    required this.size,
    required this.timeInSeconds,
    required this.entity,
    required this.thumb,
  });

  String absolutePath;
  int size;
  int timeInSeconds;
  AssetEntity entity;
  Uint8List? thumb;
}
