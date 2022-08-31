import 'package:flutter/material.dart';
import 'package:hello_flutter/models/photo_filter_info.dart';
import 'package:hello_flutter/presentation/screens/doubles/doubles_screen.dart';

class PhotosController {
  static ValueNotifier<List<List<PhotoModel>>> duplicatedPhotos = ValueNotifier([]);
  static ValueNotifier<PhotoFilterInfo> filterCounter
    = ValueNotifier(PhotoFilterInfo());
}