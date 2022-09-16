import 'big_videos_state.dart';

abstract class BigVideosEvent {}

class BigVideosFoundNewEvent extends BigVideosEvent {
  final BigVideosState bigVideosState;

  BigVideosFoundNewEvent({required this.bigVideosState});
}

class BigVideosScanFinishEvent extends BigVideosEvent {}

class BigVideosUserSelectEvent extends BigVideosEvent {}

class BigVideosUserBackPressEvent extends BigVideosEvent {}

class BigVideosUserCancelEvent extends BigVideosEvent {}
