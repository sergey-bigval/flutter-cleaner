import 'package:flutter/material.dart';
import 'package:hello_flutter/models/photo_filter_info.dart';
import 'package:hello_flutter/presentation/screens/doubles/bloc/photos_controller.dart';

class FilteringInfo extends StatelessWidget {
  const FilteringInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<PhotoFilterInfo>(
        valueListenable: PhotosController.filterCounter,
        builder: (context, info, _) {
          return Column(
            children: [
              foundPhotos(info.photoCount),
              const SizedBox(height: 5),
              foundDuplicatedPhotos(info.duplicateCount),
            ],
          );
        }
    );
  }

  Widget foundPhotos(int count) => Text('Found photos : $count');
  Widget foundDuplicatedPhotos(int count) => Text('Found duplicates : $count');
}
