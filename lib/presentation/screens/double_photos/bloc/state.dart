import 'package:hello_flutter/presentation/screens/double_photos/models/photo_model.dart';

class DoublePhotosState {
  final String imagePath;
  final int photosCount;
  final int doublePhotosCount;
  final List<List<PhotoModel>> doublePhotosList;
  final bool isScanningCanceled;
  final bool isScanning;
  final bool isSubscribed;
  final bool isDeleted;

  DoublePhotosState(
      {required this.imagePath,
      required this.photosCount,
      required this.doublePhotosCount,
      required this.doublePhotosList,
      required this.isScanningCanceled,
      required this.isScanning,
      required this.isSubscribed,
      required this.isDeleted});

  factory DoublePhotosState.initial() => DoublePhotosState(
        imagePath: "",
        photosCount: 0,
        doublePhotosCount: 0,
        doublePhotosList: <List<PhotoModel>>[],
        isScanningCanceled: false,
        isScanning: true,
        isSubscribed: false,
        isDeleted: false,
      );

  DoublePhotosState copyWith({
    String? imagePath,
    int? photosCount,
    int? doublePhotosCount,
    List<List<PhotoModel>>? doublePhotosList,
    bool? isScanningCanceled,
    bool? isScanning,
    bool? isSubscribed,
    bool? isDeleted,
  }) {
    return DoublePhotosState(
      imagePath: imagePath ?? this.imagePath,
      photosCount: photosCount ?? this.photosCount,
      doublePhotosCount: doublePhotosCount ?? this.doublePhotosCount,
      doublePhotosList: doublePhotosList ?? this.doublePhotosList,
      isScanningCanceled: isScanningCanceled ?? this.isScanningCanceled,
      isScanning: isScanning ?? this.isScanning,
      isSubscribed: isSubscribed ?? this.isSubscribed,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }
}
