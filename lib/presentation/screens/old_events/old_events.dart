// import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hello_flutter/themes/app_colors.dart';
import 'package:hello_flutter/utils/constants.dart';
import 'package:hello_flutter/utils/logging.dart';
import 'package:intl/intl.dart';
import 'package:manage_calendar_events/manage_calendar_events.dart';

import '../../../themes/styles.dart';

class OldCalendarEvents extends StatefulWidget {
  const OldCalendarEvents({Key? key}) : super(key: key);

  @override
  State<OldCalendarEvents> createState() => _OldCalendarEventsState();
}

class _OldCalendarEventsState extends State<OldCalendarEvents> {
  final CalendarPlugin _myPlugin = CalendarPlugin();
  final List<CalendarEvent> _allEventsList = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: CupertinoButton(
            color: AppColors.mainBtnColor,
            onPressed: () => goOldEventsScreen(),
            child: const Text(
              'Go to \'Old Events\'',
              textAlign: TextAlign.center,
              style: Styles.text20WhiteB,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: _allEventsList.length,
            itemBuilder: (BuildContext context, int index) {
              final subtitleText =
                  "${getFormattedDate(_allEventsList[index].startDate)} ${_allEventsList[index].location}";
              return Card(
                  color: Colors.greenAccent[100],
                  elevation: 5,
                  shadowColor: Colors.blue,
                  margin: const EdgeInsets.all(5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: ListTile(
                    title: Text(_allEventsList[index].title ?? '', style: Styles.text15),
                    subtitle: Text(subtitleText, style: Styles.text15),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_sweep_rounded, color: Colors.deepOrange),
                      onPressed: () => removeItemByIndex(index),
                    ),
                  ));
            },
          ),
        ),
      ],
    );
  }

  printUsersCalendarToLog() {
    sendPush();

    _myPlugin.hasPermissions().then((value) async {
      if (!value!) {
        _myPlugin.requestPermissions();
      } else {
        // _allEventsList.clear();
        //
        // var allCalendars = await _myPlugin.getCalendars();
        // lol("CALENDARS length = ${allCalendars?.length}");
        //
        // allCalendars?.forEach((calendar) async {
        //   final isUserAccount = calendar.accountName?.contains('@') ?? false;
        //   if (!isUserAccount) return;
        //
        //   lol("calendar.accountName = ${calendar.accountName}");
        //   lol("calendar.id = ${calendar.id}");
        //   var events = await _myPlugin.getEvents(calendarId: calendar.id!);
        //   lol("======================== ${calendar.accountName} ========================");
        //   // List<CalendarEvent> eventList = [];
        //   events?.forEach((event) async {
        //     if (event.startDate?.isBefore(DateTime.now().add(const Duration(days: -10))) ?? true) {
        //       _allEventsList.add(event);
        //       lol("MY EVENT title = ${event.title} - StartDate: ${getFormattedDate(event.startDate)} - ID = ${event.eventId}");
        //     }
        //   });
        //   setState(() {});
        //   // allEventsList.add(eventList);
        // });
      }
    });
  }

  String getFormattedDate(DateTime? date) {
    return DateFormat('yyyy-MM-dd – kk:mm').format(date ?? DateTime.now());
  }

  void sendPush() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings("@mipmap/ic_launcher");
    const IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(onDidReceiveLocalNotification: null);
    const MacOSInitializationSettings initializationSettingsMacOS = MacOSInitializationSettings();
    const InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
        macOS: initializationSettingsMacOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: null);

    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel id', 'your channel name',
        channelDescription: 'your channel description',
        importance: Importance.max,
        priority: Priority.high,
        fullScreenIntent: true,
        enableVibration: true,
        onlyAlertOnce: true,
        playSound: true,
        ticker: 'ticker');
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    flutterLocalNotificationsPlugin.show(
        0, 'Push title', 'Hello androbene first PUSH !', platformChannelSpecifics,
        payload: 'item x');
  }

  removeItemByIndex(int index) {
    final deletedId = _allEventsList[index].eventId;
    _myPlugin
        .deleteEvent(calendarId: "3", eventId: _allEventsList[index].eventId ?? '')
        .then((value) {
      if (value!) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Event $deletedId deleted")));
        _allEventsList.removeAt(index);
      }
    });
    setState(() {
      printUsersCalendarToLog();
    });
  }

  goOldEventsScreen() {
    _myPlugin.hasPermissions().then((value) async {
      if (!value!) {
        _myPlugin.requestPermissions();
        // todo: тут надо чтото придумать, т.к. у нас есть только 2 шанса вызвать СИСТЕМНОЕ окно пермишенов
      } else {
        Navigator.pushNamed(context, oldEventsScreen);
      }
    });
  }
}
