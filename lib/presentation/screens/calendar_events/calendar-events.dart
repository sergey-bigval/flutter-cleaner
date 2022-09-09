// import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hello_flutter/utils/logging.dart';
import 'package:intl/intl.dart';
import 'package:manage_calendar_events/manage_calendar_events.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarEvents extends StatefulWidget {
  const CalendarEvents({Key? key}) : super(key: key);

  @override
  State<CalendarEvents> createState() => _CalendarEventsState();
}

class _CalendarEventsState extends State<CalendarEvents> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TableCalendar(
          firstDay: DateTime.utc(2010, 10, 16),
          lastDay: DateTime.utc(2030, 3, 14),
          focusedDay: DateTime.now(),
        ),
        CupertinoButton(
          color: Colors.redAccent,
          onPressed: () {
            printUsersCalendarToLog();
          },
          child: const Text('Show in Log'),
        ),
      ],
    );
  }

  final CalendarPlugin _myPlugin = CalendarPlugin();

  printUsersCalendarToLog() async {
    sendPush();
    _myPlugin.hasPermissions().then((value) async {
      if (!value!) {
        _myPlugin.requestPermissions();
      } else {
        var calendars = await _myPlugin.getCalendars();
        lol("CALENDARS length = ${calendars?.length}");
        calendars?.forEach((calendar) async {
          lol("element.accountName = ${calendar.accountName}");
          var events = await _myPlugin.getEvents(
            // var events = await _myPlugin.getEventsByDateRange(
            calendarId: calendar.id!,
            // startDate: DateTime.now().add(const Duration(days: -100)),
            // endDate: DateTime.now().add(const Duration(days: 100))
          );
          if (calendar.accountName != "") {
            lol("======================== ${calendar.accountName} =============================");
            events?.forEach((event) async {
              String formattedDate = DateFormat('yyyy-MM-dd').format(event.startDate ?? DateTime.now());
              lol("MY EVENT title = ${event.title} - StartDate: $formattedDate - ID = ${event.eventId}");
            });
          }
        });
      }
    });
  }


  void sendPush() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings("@mipmap/ic_launcher");
    const IOSInitializationSettings initializationSettingsIOS =
    IOSInitializationSettings(
        onDidReceiveLocalNotification: null);
    const MacOSInitializationSettings initializationSettingsMacOS =
    MacOSInitializationSettings();
    const InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
        macOS: initializationSettingsMacOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: null);

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails('your channel id', 'your channel name',
        channelDescription: 'your channel description',
        importance: Importance.max,
        priority: Priority.high,
        fullScreenIntent: true,
        enableVibration: true,
        onlyAlertOnce:true,
        playSound: true,
        ticker: 'ticker');
    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);
    flutterLocalNotificationsPlugin.show(
        0, 'Push title', 'Hello androbene first PUSH !', platformChannelSpecifics,
        payload: 'item x');
  }
}
