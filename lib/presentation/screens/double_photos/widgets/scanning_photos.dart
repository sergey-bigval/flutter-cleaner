import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hello_flutter/presentation/screens/double_photos/bloc/double_photos_bloc.dart';
import 'package:hello_flutter/presentation/screens/double_photos/bloc/state.dart';
import 'package:hello_flutter/presentation/screens/double_photos/widgets/scanned_photos_count.dart';
import 'package:hello_flutter/presentation/screens/double_photos/widgets/title_doubles.dart';

import 'image_path.dart';

class ScanningPhotos extends StatelessWidget {
  final DoublePhotosBloc bloc;

  const ScanningPhotos({super.key, required this.bloc});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DoublePhotosBloc, DoublePhotosState>(
      bloc: bloc,
      builder: (context, state) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const DoublePhotosTitle("PHOTOS PROCESSED"),
              ScannedPhotosCount(state.photosCount.toString()),
              ImagePath(state.imagePath),
            ],
          ),
        );
      },
    );
  }
}
