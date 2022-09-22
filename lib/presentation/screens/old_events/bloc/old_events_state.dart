import 'package:manage_calendar_events/manage_calendar_events.dart';

class OldEventsState {
  bool isSubscribed = false;
  final bool isScanning;
  final int eventsFound;
  final List<List<CalendarEvent>> eventsData;
  final bool isAllSelected;
  final bool isJobCancelled;

  OldEventsState({
    required this.isScanning,
    required this.eventsFound,
    required this.eventsData,
    required this.isAllSelected,
    required this.isJobCancelled,
  });

  factory OldEventsState.initial() => OldEventsState(
        isScanning: true,
        eventsFound: 0,
        eventsData: [],
        isAllSelected: false,
        isJobCancelled: false,
      );

  OldEventsState copyWith({
    bool? isScanning,
    int? eventsFound,
    List<List<CalendarEvent>>? eventsData,
    bool? isAllSelected,
    bool? isJobCancelled,
  }) {
    return OldEventsState(
      isScanning: isScanning ?? this.isScanning,
      eventsFound: eventsFound ?? this.eventsFound,
      eventsData: eventsData ?? this.eventsData,
      isAllSelected: isAllSelected ?? this.isAllSelected,
      isJobCancelled: isJobCancelled ?? this.isJobCancelled,
    );
  }
}
