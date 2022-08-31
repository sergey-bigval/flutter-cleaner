import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hello_flutter/presentation/screens/doubles/bloc/photos_controller.dart';
import 'package:hello_flutter/presentation/screens/doubles/doubles_screen.dart';

class PhotoList extends StatelessWidget {
  const PhotoList({super.key});

  @override
  Widget build(BuildContext context) {
    return getPhotosList();
  }

  Widget getPhotosList() {
    return ValueListenableBuilder<List<List<PhotoModel>>>(
      valueListenable: PhotosController.duplicatedPhotos,
      builder: (context, photoList, _) {
        return getPhotoGrid(photoList);
      },
    );
  }

  Widget getPhotoGrid(List<List<PhotoModel>> photoList) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      physics: const BouncingScrollPhysics(),
      itemCount: photoList.length,
      itemBuilder: (context, index) {
        return getPhotoRow(photoRow: photoList[index]);
      },
    );
  }

  Widget getPhotoRow({required List<PhotoModel> photoRow}) {
    return SizedBox(
      width: double.infinity,
      height: 120,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: GridView.builder(
          itemCount: photoRow.length,
          scrollDirection: Axis.horizontal,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
          ),
          itemBuilder: (BuildContext context, int index) {
            return getPhotoItem(photoModel: photoRow[index]);
          },
        ),
      ),
    );
  }

  Widget getPhotoItem({required PhotoModel photoModel}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        image: DecorationImage(
          image: Image.file(
            File(photoModel.absolutePath),
            cacheHeight: 400,
          ).image,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
