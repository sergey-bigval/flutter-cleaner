import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hello_flutter/presentation/screens/double_photos/bloc/double_photos_bloc.dart';
import 'package:hello_flutter/presentation/screens/double_photos/bloc/events.dart';
import 'package:hello_flutter/presentation/screens/double_photos/bloc/state.dart';
import 'package:hello_flutter/presentation/screens/double_photos/widgets/deleting_done_dialog.dart';
import 'package:hello_flutter/presentation/screens/double_photos/widgets/title_doubles.dart';
import 'package:hello_flutter/themes/styles.dart';

import '../models/photo_model.dart';

class ScanningResult extends StatelessWidget {
  final DoublePhotosBloc bloc;

  const ScanningResult({required this.bloc, super.key});

  @override
  Widget build(BuildContext context) {
    return getPhotosList();
  }

  Widget getPhotosList() {
    return BlocConsumer<DoublePhotosBloc, DoublePhotosState>(
      bloc: bloc,
      buildWhen: (previous, current) =>
          previous.doublePhotosList != current.doublePhotosList,
      listener: (context, state) {
        if (state.isDeleted) {
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) => const DeletingDoneDialog());
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: Column(children: [
              const DoublePhotosTitle("DUPLICATES FOUND"),
              Text(
                textAlign: TextAlign.center,
                state.doublePhotosCount.toString(),
                style: Styles.textWhiteBold90,
              ),
              getPhotoGrid(state.doublePhotosList),
            ]),
          ),
          floatingActionButton: getMyFAB(),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        );
      },
    );
  }

  Widget getMyFAB() {
    return Container(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: Colors.yellow,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            )),
        child: const Padding(
          padding: EdgeInsets.all(10),
          child: Text(
            "Delete",
            style: TextStyle(color: Colors.lightBlue, fontSize: 24),
          ),
        ),
        onPressed: () {
          bloc.add(DoublePhotosDeletePhotosEvent());
        },
      ),
    );
  }

  Widget getPhotoGrid(List<List<PhotoModel>> photoList) {
    return Expanded(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        physics: const BouncingScrollPhysics(),
        itemCount: photoList.length,
        itemBuilder: (context, index) {
          return getPhotoRow(photoRow: photoList[index]);
        },
      ),
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
