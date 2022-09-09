class VideoFoundInfo {
  final int videoCount;
  final String folder;

  VideoFoundInfo({
    this.videoCount = 0,
    this.folder = "",
  });

  VideoFoundInfo copyWith({int? videoCount, int? duplicateCount, String? folder}) {
    return VideoFoundInfo(
      videoCount: videoCount ?? this.videoCount,
      folder: folder ?? this.folder,
    );
  }
}