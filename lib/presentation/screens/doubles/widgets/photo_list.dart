import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hello_flutter/presentation/screens/doubles/bloc/photos_controller.dart';
import 'package:hello_flutter/presentation/screens/doubles/doubles_screen.dart';

class PhotoList extends StatelessWidget {
  const PhotoList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return photosList();
  }

  Widget photosList() {
    return ValueListenableBuilder<List<PhotoModel>>(
      valueListenable: PhotosController.duplicatedPhotos,
      builder: (context, photoList, _) {
        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
          ),
          itemCount: photoList.length,
          itemBuilder: (context, index) {
            return photo(photoModel: photoList[index]);
          },
        );
      },
    );
  }

  Widget photo({required PhotoModel photoModel}) {
    return Image.file(File(photoModel.absolutePath));
  }
}
