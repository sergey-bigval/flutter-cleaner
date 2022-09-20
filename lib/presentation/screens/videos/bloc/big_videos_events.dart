import 'big_videos_state.dart';

abstract class BigVideosEvent {}

class BigVideosFoundNewEvent extends BigVideosEvent {
  final BigVideosState bigVideosState;

  BigVideosFoundNewEvent({required this.bigVideosState});
}

class BigVideosScanFinishEvent extends BigVideosEvent {}

class BigVideosThumbDoneEvent extends BigVideosEvent {}

class BigVideosItemSelectedEvent extends BigVideosEvent {
  final String id;

  BigVideosItemSelectedEvent({required this.id});
}

class BigVideosItemUnSelectedEvent extends BigVideosEvent {
  final String id;

  BigVideosItemUnSelectedEvent({required this.id});
}

class BigVideosDeleteEvent extends BigVideosEvent {}

class BigVideosCancelJobEvent extends BigVideosEvent {}
