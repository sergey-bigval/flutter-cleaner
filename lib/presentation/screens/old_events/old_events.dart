// import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/cupertino.dart';
import 'package:hello_flutter/themes/app_colors.dart';
import 'package:hello_flutter/utils/constants.dart';
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
    return Center(
      child: CupertinoButton(
        color: AppColors.mainBtnColor,
        onPressed: () => goOldEventsScreen(),
        child: const Text(
          'Go to \'Old Events\'',
          textAlign: TextAlign.center,
          style: Styles.text20WhiteB,
        ),
      ),
    );
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
