import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hello_flutter/presentation/screens/double_photos/bloc/double_photos_bloc.dart';
import 'package:hello_flutter/presentation/screens/double_photos/bloc/state.dart';

class FilteringInfo extends StatelessWidget {
  final DoublePhotosBloc bloc;

  const FilteringInfo({super.key, required this.bloc});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DoublePhotosBloc, DoublePhotosState>(
      bloc: bloc,
      builder: (context, state) {
        return Column(
          children: [
            getFoundPhotosText(state.photosCount),
            const SizedBox(height: 5),
            getFoundDuplicatedPhotosText(state.doublePhotosCount),
            const SizedBox(height: 5),
            getCurrentFolderText(state.folderName),
          ],
        );
      },
    );
  }

  Widget getFoundPhotosText(int count) => Text('Photos processed : $count');

  Widget getFoundDuplicatedPhotosText(int count) =>
      Text('Found duplicates : $count');

  Widget getCurrentFolderText(String folder) =>
      Center(child: Text('Scanning in folder : \n $folder'));
}
