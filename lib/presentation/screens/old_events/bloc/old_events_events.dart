abstract class OldEventsEvent {}

class OldEventsFoundNewEvent extends OldEventsEvent {
  final int eventsCount;

  OldEventsFoundNewEvent({required this.eventsCount});
}

class OldEventsScanFinishEvent extends OldEventsEvent {}

class OldEventsItemSelectedEvent extends OldEventsEvent {
  final String id;

  OldEventsItemSelectedEvent({required this.id});
}

class OldEventsItemUnSelectedEvent extends OldEventsEvent {
  final String id;

  OldEventsItemUnSelectedEvent({required this.id});
}

class OldEventsDeleteEvent extends OldEventsEvent {}

class OldEventsCancelJobEvent extends OldEventsEvent {}
