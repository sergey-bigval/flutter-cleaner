import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manage_calendar_events/manage_calendar_events.dart';

import '../bloc/old_events_bloc.dart';
import '../bloc/old_events_events.dart';
import '../bloc/old_events_state.dart';

class MonthCheckboxWidget extends StatelessWidget {
  final OldEventsBloc bloc;
  final List<CalendarEvent> groupData;

  const MonthCheckboxWidget({required this.bloc, required this.groupData, Key? key,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OldEventsBloc, OldEventsState>(
      bloc: bloc,
      builder: (BuildContext context, state) {
        return Checkbox(
          value: bloc.calendarRepo.isCheckedMonthGroup(groupData.first.startDate),
          onChanged: (isChecked) {
            if (isChecked!) {
              bloc.add(OldEventsGroupSelectedEvent(dateTime: groupData.first.startDate));
            } else {
              bloc.add(OldEventsGroupUnSelectedEvent(dateTime: groupData.first.startDate));
            }
          },
        );
      },
    );
  }
}
