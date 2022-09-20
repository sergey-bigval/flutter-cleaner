class BigVideosState {
  final bool isScanning;
  final int videosFound;
  final int videosTotalSize;
  final String currentFolder;
  final bool isReadyToDelete;
  final bool isJobCancelled;

  BigVideosState({
    required this.isScanning,
    required this.videosFound,
    required this.videosTotalSize,
    required this.currentFolder,
    required this.isReadyToDelete,
    required this.isJobCancelled,
  });

  factory BigVideosState.initial() => BigVideosState(
        isScanning: true,
        videosFound: 0,
        videosTotalSize: 0,
        currentFolder: '',
        isReadyToDelete: false,
        isJobCancelled: false,
      );

  BigVideosState copyWith({
    bool? isScanning,
    int? videosFound,
    int? videosTotalSize,
    String? currentFolder,
    bool? isReadyToDelete,
    bool? isJobCancelled,
  }) {
    return BigVideosState(
      isScanning: isScanning ?? this.isScanning,
      videosFound: videosFound ?? this.videosFound,
      videosTotalSize: videosTotalSize ?? this.videosTotalSize,
      currentFolder: currentFolder ?? this.currentFolder,
      isReadyToDelete: isReadyToDelete ?? this.isReadyToDelete,
      isJobCancelled: isJobCancelled ?? this.isJobCancelled,
    );
  }
}
