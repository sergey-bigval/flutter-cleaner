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

    on<OldEventsItemSelectedEvent>(_onOldEventsItemSelectedEvent);
    on<OldEventsItemUnSelectedEvent>(_onOldEventsItemUnSelectedEvent);

    on<OldEventsGroupSelectedEvent>(_onOldEventsGroupSelectedEvent);
    on<OldEventsGroupUnSelectedEvent>(_onOldEventsGroupUnSelectedEvent);

    on<OldEventsTapSelectAllEvent>(_onOldEventsTapSelectAllEvent);

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
    emitter(state.copyWith(isScanning: false, eventsData: event.eventsData));
  }

  Future<void> _onOldEventsItemSelectedEvent(
    OldEventsItemSelectedEvent event,
    Emitter emitter,
  ) async {
    calendarRepo.addItemToRemoveList(event.id);
    emitter(state.copyWith(isJobCancelled: false));
  }

  Future<void> _onOldEventsItemUnSelectedEvent(
    OldEventsItemUnSelectedEvent event,
    Emitter emitter,
  ) async {
    calendarRepo.takeItemFromRemoveList(event.id);
    emitter(state.copyWith(isJobCancelled: false));
  }

  Future<void> _onOldEventsGroupSelectedEvent(
    OldEventsGroupSelectedEvent event,
    Emitter emitter,
  ) async {
    calendarRepo.addGroupToRemoveList(event.dateTime);
    emitter(state.copyWith(isJobCancelled: false));
  }

  Future<void> _onOldEventsGroupUnSelectedEvent(
    OldEventsGroupUnSelectedEvent event,
    Emitter emitter,
  ) async {
    calendarRepo.takeGroupFromRemoveList(event.dateTime);
    emitter(state.copyWith(isJobCancelled: false));
  }

  Future<void> _onOldEventsTapSelectAllEvent(
    OldEventsTapSelectAllEvent event,
    Emitter emitter,
  ) async {
    calendarRepo.addAllToRemoveList();
    emitter(state.copyWith(isAllSelected: !state.isAllSelected));
  }

  Future<void> _onOldEventsCancelJobEvent(
    OldEventsCancelJobEvent event,
    Emitter emitter,
  ) async {
    emitter(state.copyWith(isJobCancelled: true));
  }
}
