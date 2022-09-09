import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

import '../models/video_found_info.dart';

class VideoController {
  static ValueNotifier<List<VideoModel>> videos = ValueNotifier([]);
  static ValueNotifier<VideoFoundInfo> videosCount = ValueNotifier(VideoFoundInfo());
}

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
