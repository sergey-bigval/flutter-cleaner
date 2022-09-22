import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manage_calendar_events/manage_calendar_events.dart';

import '../bloc/old_events_bloc.dart';
import '../bloc/old_events_events.dart';
import '../bloc/old_events_state.dart';

class ItemCheckboxWidget extends StatelessWidget {
  final OldEventsBloc bloc;
  final CalendarEvent event;

  const ItemCheckboxWidget({required this.bloc, required this.event, Key? key,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OldEventsBloc, OldEventsState>(
      bloc: bloc,
      builder: (BuildContext context, state) {
        return Checkbox(
          value: bloc.calendarRepo.isCheckedItem(event.eventId!),
          onChanged: (isChecked) {
            if (isChecked!) {
              bloc.add(OldEventsItemSelectedEvent(id: event.eventId!));
            } else {
              bloc.add(OldEventsItemUnSelectedEvent(id: event.eventId!));
            }
          },
        );
      },
    );
  }
}
