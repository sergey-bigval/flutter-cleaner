import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hello_flutter/presentation/screens/old_events/widgets/item_checkbox.dart';
import 'package:hello_flutter/presentation/screens/old_events/widgets/month_checkbox.dart';
import 'package:intl/intl.dart';
import 'package:manage_calendar_events/manage_calendar_events.dart';

import '../../../themes/app_colors.dart';
import '../../../themes/styles.dart';
import 'bloc/old_events_bloc.dart';
import 'bloc/old_events_events.dart';
import 'bloc/old_events_state.dart';

class OldEventsScreen extends StatefulWidget {
  const OldEventsScreen({Key? key}) : super(key: key);

  @override
  State<OldEventsScreen> createState() => _OldEventsScreenState();
}

class _OldEventsScreenState extends State<OldEventsScreen> {
  late OldEventsBloc _bloc;

  @override
  void initState() {
    _bloc = OldEventsBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: _getCalendarBar(),
        body: Container(
          color: AppColors.mainBgColor,
          child: BlocBuilder<OldEventsBloc, OldEventsState>(
            bloc: _bloc,
            buildWhen: (previous, current) => previous.isScanning != current.isScanning,
            builder: (BuildContext context, state) {
              if (state.isScanning) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text(
                        'Events found in calendar: ${state.eventsFound}',
                        style: Styles.text16B,
                      ),
                    ),
                    Expanded(
                        child: BlocBuilder<OldEventsBloc, OldEventsState>(
                            bloc: _bloc,
                            builder: (BuildContext context, state) {
                              final data = _bloc.state.eventsData;
                              return _getListView(data);
                            })),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }

  AppBar _getCalendarBar() {
    return AppBar(
      iconTheme: const IconThemeData(color: Colors.black),
      backgroundColor: AppColors.mainBgColor,
      title: Row(
        children: [
          const Spacer(),
          const Text('Calendar', style: Styles.text20),
          const Spacer(),
          InkWell(
              onTap: () {
                if (_bloc.state.isScanning) return;
                _bloc.add(OldEventsTapSelectAllEvent());
              },
              child: Text('Select all', style: Styles.clickable16)),
        ],
      ),
    );
  }

  ListView _getListView(List<List<CalendarEvent>> data) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: data.length,
      itemBuilder: (BuildContext context, int index) {
        return Card(
            color: _getCardColor(index),
            elevation: 5,
            shadowColor: Colors.blue,
            margin: const EdgeInsets.all(5),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: ListTile(
              title: Text(
                _getFormattedDateWithEventsCount(data[index]),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: _getSublistWidget(data[index]),
              trailing: MonthCheckboxWidget(bloc: _bloc, groupData: data[index]),
            ));
      },
    );
  }

  Widget _getSublistWidget(List<CalendarEvent> groupData) {
    final List<Widget> columnOfWidgets = [];
    for (CalendarEvent event in groupData) {
      final index = groupData.indexOf(event);
      final item = Card(
        color: Colors.white54,
        elevation: 5,
        shadowColor: Colors.black54,
        margin: const EdgeInsets.all(5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: ListTile(
          title: Text(_getTitleWithFormattedDate(groupData[index].startDate), style: Styles.text15),
          subtitle: Text(groupData[index].title.toString(), style: Styles.text15),
          trailing: ItemCheckboxWidget(bloc: _bloc, event: groupData[index]),
        ),
      );
      columnOfWidgets.add(item);
    }
    return Column(children: columnOfWidgets);
  }

  String _getTitleWithFormattedDate(DateTime? date) {
    if (date == null) {
      return '---';
    } else {
      return "${DateFormat('yyyy MMMM dd').format(date)}\nTime: ${DateFormat('kk:mm').format(date)}";
    }
  }

  Color _getCardColor(int index) {
    switch (index % 3) {
      case 0:
        return Colors.orange.shade100;
      case 1:
        return Colors.purple.shade100;
      default:
        return Colors.green.shade100;
    }
  }

  String _getFormattedDateWithEventsCount(List<CalendarEvent> list) {
    final date = list.first.startDate ?? DateTime.now();
    final monthYear = DateFormat('MMMM yyyy').format(date);
    final monthTitle = '$monthYear - has ${list.length} events';
    return monthTitle;
  }
}
