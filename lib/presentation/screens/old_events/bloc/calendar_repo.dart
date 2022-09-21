import 'package:hello_flutter/presentation/screens/videos/models/video_model.dart';
import 'package:intl/intl.dart';
import 'package:manage_calendar_events/manage_calendar_events.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../../../utils/logging.dart';
import 'old_events_bloc.dart';
import 'old_events_events.dart';

class CalendarRepo {
  late final OldEventsBloc bloc;
  final CalendarPlugin _myPlugin = CalendarPlugin();
  final List<CalendarEvent> allEventsList = [];

  CalendarRepo({required this.bloc});

  int videosCount = 0;
  List<VideoModel> allVideos = [];
  final Set<String> _idsToDelete = {};

  Future<void> loadEvents() async {
    allEventsList.clear();
    var allCalendars = await _myPlugin.getCalendars();
    lol("CALENDARS length = ${allCalendars?.length}");

    allCalendars?.forEach((calendar) async {
      final isUserAccount = calendar.accountName?.contains('@') ?? false;
      if (!isUserAccount) return;

      lol("calendar.accountName = ${calendar.accountName}");
      lol("calendar.id = ${calendar.id}");
      var events = await _myPlugin.getEvents(calendarId: calendar.id!);
      lol("======================== ${calendar.accountName} ========================");
      // List<CalendarEvent> eventList = [];
      events?.forEach((event) async {
        if (event.startDate?.isBefore(DateTime.now().add(const Duration(days: -10))) ?? true) {
          allEventsList.add(event);
          await Future.delayed(Duration(seconds: 1));
          bloc.add(OldEventsFoundNewEvent(eventsCount: allEventsList.length));
          lol("MY EVENT title = ${event.title} - StartDate: ${getFormattedDate(event.startDate)} - ID = ${event.eventId}");
        }
      });
      bloc.add(OldEventsScanFinishEvent());
    });

  }

  String getFormattedDate(DateTime? date) {
    return DateFormat('yyyy-MM-dd – kk:mm').format(date ?? DateTime.now());
  }

  Future<void> deleteSelected() async {
    /////////////////////////////////////////
    final List<String> deletedIds = await PhotoManager.editor.deleteWithIds(_idsToDelete.toList());
    lol('DELETED ${deletedIds.length} videos');
    for (var id in deletedIds) {
      allVideos.removeWhere((element) => element.entity.id == id);
      lol('DELETED VIDEO # $id');
      _idsToDelete.remove(id);
    }
  }

  void addToRemoveList(String id) {
    _idsToDelete.add(id);
  }

  void takeFromRemoveList(String id) {
    _idsToDelete.remove(id);
  }

  bool isCheckedById(String id) {
    return _idsToDelete.contains(id);
  }
}
