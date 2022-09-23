import 'package:manage_calendar_events/manage_calendar_events.dart';

class OldEventsState {
  bool isSubscribed = false;
  final String calendarId;
  final bool isScanning;
  final int eventsFound;
  final List<List<CalendarEvent>> eventsData;
  final bool isAllSelected;
  final bool isJobCancelled;

  OldEventsState({
    required this.calendarId,
    required this.isScanning,
    required this.eventsFound,
    required this.eventsData,
    required this.isAllSelected,
    required this.isJobCancelled,
  });

  factory OldEventsState.initial() => OldEventsState(
        calendarId: '',
        isScanning: true,
        eventsFound: 0,
        eventsData: [],
        isAllSelected: false,
        isJobCancelled: false,
      );

  OldEventsState copyWith({
    String? calendarId,
    bool? isScanning,
    int? eventsFound,
    List<List<CalendarEvent>>? eventsData,
    bool? isAllSelected,
    bool? isJobCancelled,
  }) {
    return OldEventsState(
      calendarId: calendarId ?? this.calendarId,
      isScanning: isScanning ?? this.isScanning,
      eventsFound: eventsFound ?? this.eventsFound,
      eventsData: eventsData ?? this.eventsData,
      isAllSelected: isAllSelected ?? this.isAllSelected,
      isJobCancelled: isJobCancelled ?? this.isJobCancelled,
    );
  }
}
