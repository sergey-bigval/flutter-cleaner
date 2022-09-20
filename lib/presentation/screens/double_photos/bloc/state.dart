import 'package:hello_flutter/presentation/screens/double_photos/models/photo_model.dart';

class DoublePhotosState {
  final String folderName;
  final int photosCount;
  final int doublePhotosCount;
  final List<List<PhotoModel>> doublePhotosList;

  DoublePhotosState(
      {required this.folderName,
      required this.photosCount,
      required this.doublePhotosCount,
      required this.doublePhotosList});

  factory DoublePhotosState.initial() => DoublePhotosState(
        folderName: "",
        photosCount: 0,
        doublePhotosCount: 0,
        doublePhotosList: <List<PhotoModel>>[],
      );

  DoublePhotosState copyWith({
    String? folderName,
    int? photosCount,
    int? doublePhotosCount,
    List<List<PhotoModel>>? doublePhotosList,
  }) {
    return DoublePhotosState(
      folderName: folderName ?? this.folderName,
      photosCount: photosCount ?? this.photosCount,
      doublePhotosCount: doublePhotosCount ?? this.doublePhotosCount,
      doublePhotosList: doublePhotosList ?? this.doublePhotosList,
    );
  }
}
