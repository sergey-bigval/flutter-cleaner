class BigVideosState {
  final bool isScanning;
  final int videosFound;
  final int videosTotalSize;
  final String currentFolder;

  BigVideosState({
    required this.isScanning,
    required this.videosFound,
    required this.videosTotalSize,
    required this.currentFolder,
  });

  factory BigVideosState.initial() => BigVideosState(
        isScanning: true,
        videosFound: 0,
        videosTotalSize: 0,
        currentFolder: '',
      );

  BigVideosState copyWith({
    bool? isScanning,
    int? videosFound,
    int? videosTotalSize,
    String? currentFolder,
  }) {
    return BigVideosState(
      isScanning: isScanning ?? this.isScanning,
      videosFound: videosFound ?? this.videosFound,
      videosTotalSize: videosTotalSize ?? this.videosTotalSize,
      currentFolder: currentFolder ?? this.currentFolder,
    );
  }
}
