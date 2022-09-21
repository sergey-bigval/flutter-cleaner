import 'package:flutter_bloc/flutter_bloc.dart';

import 'calendar_repo.dart';
import 'old_events_events.dart';
import 'old_events_state.dart';

class OldEventsBloc extends Bloc<OldEventsEvent, OldEventsState> {
  late final CalendarRepo calendarRepo;

  OldEventsBloc() : super(OldEventsState.initial()) {
    calendarRepo = CalendarRepo(bloc: this)..loadEvents();

    on<OldEventsFoundNewEvent>(_onBigVideosFoundNewEvent);
    on<OldEventsScanFinishEvent>(_onOldEventsScanFinishEvent);
    on<OldEventsCancelJobEvent>(_onOldEventsCancelJobEvent);
  }

  Future<void> _onBigVideosFoundNewEvent(
    OldEventsFoundNewEvent event,
    Emitter emitter,
  ) async {
    emitter(state.copyWith(eventsFound: event.eventsCount));
  }

  Future<void> _onOldEventsScanFinishEvent(
    OldEventsScanFinishEvent event,
    Emitter emitter,
  ) async {
    emitter(state.copyWith(isScanning: false));
  }

  Future<void> _onOldEventsCancelJobEvent(
    OldEventsCancelJobEvent event,
    Emitter emitter,
  ) async {
    emitter(state.copyWith(isJobCancelled: true));
  }
}
