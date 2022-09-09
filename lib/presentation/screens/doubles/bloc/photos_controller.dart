import 'package:flutter/material.dart';
import 'package:hello_flutter/presentation/screens/doubles/doubles_screen.dart';

import '../models/photo_filter_info.dart';

class PhotosController {
  static ValueNotifier<List<List<PhotoModel>>> duplicatedPhotos = ValueNotifier([]);
  static ValueNotifier<PhotoFilterInfo> filterCounterInfo
    = ValueNotifier(PhotoFilterInfo());
}