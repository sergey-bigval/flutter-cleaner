class OldEventsState {
  final bool isScanning;
  final int eventsFound;
  final bool isJobCancelled;

  OldEventsState({
    required this.isScanning,
    required this.eventsFound,
    required this.isJobCancelled,
  });

  factory OldEventsState.initial() => OldEventsState(
        isScanning: true,
        eventsFound: 0,
        isJobCancelled: false,
      );

  OldEventsState copyWith({
    bool? isScanning,
    int? eventsFound,
    bool? isJobCancelled,
  }) {
    return OldEventsState(
      isScanning: isScanning ?? this.isScanning,
      eventsFound: eventsFound ?? this.eventsFound,
      isJobCancelled: isJobCancelled ?? this.isJobCancelled,
    );
  }
}
