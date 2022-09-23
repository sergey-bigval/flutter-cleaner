import 'package:intl/intl.dart';
import 'package:manage_calendar_events/manage_calendar_events.dart';

import '../../../../utils/logging.dart';
import 'old_events_bloc.dart';
import 'old_events_events.dart';

class CalendarRepo {
  late final OldEventsBloc bloc;
  final CalendarPlugin _myPlugin = CalendarPlugin();
  final List<CalendarEvent> allEventsList = [];
  List<List<CalendarEvent>> groupedEvents = [];
  final Set<String> _idsToDelete = {};

  CalendarRepo({required this.bloc});

  Future<void> loadEvents() async {
    allEventsList.clear();
    var allCalendars = await _myPlugin.getCalendars();
    lol("CALENDARS length = ${allCalendars?.length}");

    allCalendars?.forEach((calendar) async {
      final isUserAccount = calendar.accountName?.contains('@') ?? false;
      if (!isUserAccount) return;

      lol("calendar.accountName = ${calendar.accountName}");
      lol("calendar.id = ${calendar.id}");

      bloc.add(OldEventsGetCalendarIdEvent(calendarId: calendar.id!));

      var events = await _myPlugin.getEvents(calendarId: calendar.id!);
      final streamOfEvents = Stream.fromIterable(events ?? []);
      lol("======================== ${calendar.accountName} ========================");
      await for (CalendarEvent event in streamOfEvents) {
        if (event.startDate?.isBefore(DateTime.now().add(const Duration(days: -10))) ?? true) {
          allEventsList.add(event);
          // await Future.delayed(const Duration(
          //     milliseconds: 20)); // todo: Удалить в релизе. Для эмуляции долгого поиска
          bloc.add(OldEventsFoundNewEvent(eventsCount: allEventsList.length));
          lol("MY EVENT title = ${event.title} - StartDate: ${getFormattedDate(event.startDate)} - ID = ${event.eventId}");
        }
      }
      groupedEvents = getEventsGroupedByMonth();
      bloc.add(OldEventsScanFinishEvent(eventsData: groupedEvents));
    });
  }

  String getFormattedDate(DateTime? date) {
    return DateFormat('yyyy-MM-dd – kk:mm').format(date ?? DateTime.now());
  }

  void addItemToRemoveList(String id) {
    _idsToDelete.add(id);
  }

  void takeItemFromRemoveList(String id) {
    _idsToDelete.remove(id);
  }

  List<List<CalendarEvent>> getEventsGroupedByMonth() {
    const defStamp = -1;
    final List<List<CalendarEvent>> groupedEvents = [];
    List<CalendarEvent> group = [];
    var prevGroupStamp = defStamp;
    for (CalendarEvent event in allEventsList) {
      var year = event.startDate?.year ?? 0;
      var month = event.startDate?.month ?? 0;
      var groupStamp = year * 100 + month;
      if (groupStamp == prevGroupStamp || prevGroupStamp == defStamp) {
        group.add(event);
        prevGroupStamp = groupStamp;
      } else {
        groupedEvents.add(group);
        group = [];
        group.add(event);
        prevGroupStamp = groupStamp;
      }
    }
    // _debugGroupCheck(groupedEvents);
    return groupedEvents;
  }

  void _debugGroupCheck(List<List<CalendarEvent>> groupedEvents) {
    //// проверка группирования
    for (List<CalendarEvent> list in groupedEvents) {
      lol('======== GROUP =======');
      for (CalendarEvent event in list) {
        lol('${event.startDate} --- ${event.title}');
      }
    }
  }

  bool shouldCheckMonthGroup(DateTime? startDate) {
    var year = startDate?.year ?? 0;
    var month = startDate?.month ?? 0;
    var groupStamp = year * 100 + month;
    for (List<CalendarEvent> list in groupedEvents) {
      var year = list.first.startDate?.year ?? 0;
      var month = list.first.startDate?.month ?? 0;
      var currentListStamp = year * 100 + month;
      if (currentListStamp == groupStamp) {
        final listIDs = [];
        for (CalendarEvent event in list) {
          listIDs.add(event.eventId);
        }
        return _idsToDelete.containsAll(listIDs);
      }
    }
    return false;
  }

  void addGroupToRemoveList(DateTime? dateTime) {
    var year = dateTime?.year ?? 0;
    var month = dateTime?.month ?? 0;
    var groupStamp = year * 100 + month;
    for (List<CalendarEvent> list in groupedEvents) {
      var year = list.first.startDate?.year ?? 0;
      var month = list.first.startDate?.month ?? 0;
      var currentListStamp = year * 100 + month;
      if (currentListStamp == groupStamp) {
        for (CalendarEvent event in list) {
          _idsToDelete.add(event.eventId!);
        }
      }
    }
  }

  void takeGroupFromRemoveList(DateTime? dateTime) {
    var year = dateTime?.year ?? 0;
    var month = dateTime?.month ?? 0;
    var groupStamp = year * 100 + month;
    for (List<CalendarEvent> list in groupedEvents) {
      var year = list.first.startDate?.year ?? 0;
      var month = list.first.startDate?.month ?? 0;
      var currentListStamp = year * 100 + month;
      if (currentListStamp == groupStamp) {
        for (CalendarEvent event in list) {
          _idsToDelete.remove(event.eventId);
        }
      }
    }
  }

  bool isCheckedItem(String id) {
    return _idsToDelete.contains(id);
  }

  void addAllToRemoveList() {
    if (bloc.state.isAllSelected) {
      _idsToDelete.clear();
    } else {
      for (CalendarEvent event in allEventsList) {
        _idsToDelete.add(event.eventId!);
      }
    }
  }

  Future<void> deleteSelected() async {
    /////////////////////////////////////////
    lol('EVENTS TO DELETE ${_idsToDelete.length}');
    for (String id in _idsToDelete) {
      _myPlugin.deleteEvent(calendarId: bloc.state.calendarId, eventId: id).then((isDeleted) {
        if (isDeleted!) {
          lol('SUCCESSFULLY DELETED EVENT # $id');
        }
      });
    }
    _idsToDelete.clear();
    await loadEvents();
  }

  int getCountToDelete() {
    return _idsToDelete.length;
  }
}
