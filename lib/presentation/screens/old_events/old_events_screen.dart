import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hello_flutter/presentation/screens/old_events/widgets/cancel_dialog.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
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
  final CalendarPlugin _myPlugin = CalendarPlugin();

  @override
  void initState() {
    _bloc = OldEventsBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _showCancellationDialog(context);
        return false;
      },
      child: SafeArea(
        child: Container(
          color: AppColors.mainBgColor,
          child: BlocBuilder<OldEventsBloc, OldEventsState>(
            bloc: _bloc,
            buildWhen: (previous, current) => previous.isScanning != current.isScanning,
            builder: (BuildContext context, state) {
              if (state.isScanning) {
                return Column(
                  children: [
                    Expanded(
                        flex: 2, child: Lottie.asset("assets/lottie/108977-video-scanning.json")),
                    const Expanded(
                        flex: 1,
                        child:
                            Center(child: Text("Events searching...", style: Styles.titleStyle))),
                    Expanded(
                      flex: 2,
                      child: BlocBuilder<OldEventsBloc, OldEventsState>(
                        bloc: _bloc,
                        buildWhen: (previous, current) =>
                            previous.eventsFound != current.eventsFound,
                        builder: (BuildContext context, state) {
                          return Text('Events found in calendar: ${state.eventsFound}');
                        },
                      ),
                    ),
                  ],
                );
              } else {
                return Column(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Row(children: [
                        Lottie.asset("assets/lottie/done_676.json"),
                        const Expanded(
                            flex: 7,
                            child: Center(
                                child: Text("Searching completed!", style: Styles.titleStyle))),
                      ]),
                    ),
                    Expanded(
                      flex: 4,
                      child: BlocBuilder<OldEventsBloc, OldEventsState>(
                        bloc: _bloc,
                        builder: (BuildContext context, state) {
                          return Column(
                            children: [
                              Text(
                                'Events found in calendar: ${state.eventsFound}',
                                style: Styles.text15,
                              ),
                              Visibility(
                                visible: true, //_bloc.state.isReadyToDelete,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 3),
                                  child: CupertinoButton(
                                    onPressed: () {
                                      _bloc.add(OldEventsDeleteEvent());
                                    },
                                    color: AppColors.mainBtnColor,
                                    child: const Text('Delete'),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    Expanded(
                        flex: 15,
                        child: BlocBuilder<OldEventsBloc, OldEventsState>(
                            bloc: _bloc,
                            builder: (BuildContext context, state) {
                              final data = _bloc.calendarRepo.allEventsList;
                              return ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                itemCount: data.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final subtitleText =
                                      "${getFormattedDate(data[index].startDate)} ${data[index].location}";
                                  return Card(
                                      color: Colors.greenAccent[100],
                                      elevation: 5,
                                      shadowColor: Colors.blue,
                                      margin: const EdgeInsets.all(5),
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15)),
                                      child: ListTile(
                                        title: Text(data[index].title ?? '', style: Styles.text15),
                                        subtitle: Text(subtitleText, style: Styles.text15),
                                        trailing: IconButton(
                                          icon: const Icon(Icons.delete_sweep_rounded,
                                              color: Colors.deepOrange),
                                          onPressed: () => removeItemByIndex(data, index),
                                        ),
                                      ));
                                },
                              );
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

  String getFormattedDate(DateTime? date) {
    return DateFormat('yyyy-MM-dd – kk:mm').format(date ?? DateTime.now());
  }

  removeItemByIndex(List<CalendarEvent> data, int index) {
    final deletedId = data[index].eventId;
    _myPlugin.deleteEvent(calendarId: "3", eventId: data[index].eventId ?? '').then((value) {
      if (value!) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Event $deletedId deleted")));
        data.removeAt(index);
      }
    });
    setState(() {});
  }

  Future<void> _showCancellationDialog(BuildContext context) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CancelDialogEvents(onCancel: () => _bloc.add(OldEventsCancelJobEvent()));
        });
  }
}
