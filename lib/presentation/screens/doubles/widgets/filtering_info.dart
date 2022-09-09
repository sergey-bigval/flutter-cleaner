import 'package:flutter/material.dart';
import 'package:hello_flutter/presentation/screens/doubles/bloc/photos_controller.dart';

import '../models/photo_filter_info.dart';

class FilteringInfo extends StatelessWidget {
  const FilteringInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<PhotoFilterInfo>(
        valueListenable: PhotosController.filterCounterInfo,
        builder: (context, info, _) {
          return Column(
            children: [
              getFoundPhotosText(info.photoCount),
              const SizedBox(height: 5),
              getFoundDuplicatedPhotosText(info.duplicateCount),
              const SizedBox(height: 5),
              getCurrentFolderText(info.folder),
            ],
          );
        });
  }

  Widget getFoundPhotosText(int count) => Text('Photos processed : $count');

  Widget getFoundDuplicatedPhotosText(int count) => Text('Found duplicates : $count');

  Widget getCurrentFolderText(String folder) => Center(child: Text('Scanning in folder : \n $folder'));
}
