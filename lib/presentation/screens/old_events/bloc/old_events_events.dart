import 'package:manage_calendar_events/manage_calendar_events.dart';

abstract class OldEventsEvent {}

class OldEventsFoundNewEvent extends OldEventsEvent { // найдена очередная запись в календаре
  final int eventsCount;

  OldEventsFoundNewEvent({required this.eventsCount});
}

class OldEventsScanFinishEvent extends OldEventsEvent { // окончание поиска
  final List<List<CalendarEvent>> eventsData;

  OldEventsScanFinishEvent({required this.eventsData});
}

class OldEventsItemSelectedEvent extends OldEventsEvent { // селект поштучно
  final String id;

  OldEventsItemSelectedEvent({required this.id});
}

class OldEventsItemUnSelectedEvent extends OldEventsEvent { // снятие поштучно
  final String id;

  OldEventsItemUnSelectedEvent({required this.id});
}

class OldEventsGroupSelectedEvent extends OldEventsEvent { // селект группы
  final DateTime? dateTime;

  OldEventsGroupSelectedEvent({required this.dateTime});
}

class OldEventsGroupUnSelectedEvent extends OldEventsEvent { // снятие группы
  final DateTime? dateTime;

  OldEventsGroupUnSelectedEvent({required this.dateTime});
}

class OldEventsTapSelectAllEvent extends OldEventsEvent {} // клик на выбрать ВСЁ

class OldEventsDeleteEvent extends OldEventsEvent {} // удаление

class OldEventsCancelJobEvent extends OldEventsEvent {} // отмена
