class PhotoFilterInfo {
  final int photoCount;
  final int duplicateCount;
  final String folder;

  PhotoFilterInfo({
    this.photoCount = 0,
    this.duplicateCount = 0,
    this.folder = "",
  });

  PhotoFilterInfo copyWith({int? photoCount, int? duplicateCount, String? folder}) {
    return PhotoFilterInfo(
      photoCount: photoCount ?? this.photoCount,
      duplicateCount: duplicateCount ?? this.duplicateCount,
      folder: folder ?? this.folder,
    );
  }
}