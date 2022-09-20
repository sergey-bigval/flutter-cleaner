import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hello_flutter/presentation/screens/double_photos/bloc/double_photos_bloc.dart';
import 'package:hello_flutter/presentation/screens/double_photos/bloc/state.dart';

import '../models/photo_model.dart';

class PhotoList extends StatelessWidget {
  final DoublePhotosBloc bloc;

  const PhotoList({required this.bloc, super.key});

  @override
  Widget build(BuildContext context) {
    return getPhotosList();
  }

  Widget getPhotosList() {
    return BlocBuilder<DoublePhotosBloc, DoublePhotosState>(
      bloc: bloc,
      buildWhen: (previous, current) =>
          previous.doublePhotosList != current.doublePhotosList,
      builder: (context, state) {
        return getPhotoGrid(state.doublePhotosList);
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
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              image: Image.file(
                File(photoModel.absolutePath),
                cacheHeight: 300,
              ).image,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Row(children: [
          const Spacer(),
          ValueListenableBuilder(
            valueListenable: photoModel.checkboxState,
            builder: (BuildContext context, bool value, Widget? child) {
              return Checkbox(
                value: photoModel.checkboxState.value,
                onChanged: (newCheckboxState) {
                  photoModel.checkboxState.value = newCheckboxState ?? false;
                  photoModel.isSelected = newCheckboxState ?? false;
                },
              );
            },
          ),
        ])
      ],
    );
  }
}
