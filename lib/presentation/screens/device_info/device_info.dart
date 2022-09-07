import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hello_flutter/presentation/screens/device_info/widgets/app_bar.dart';
import 'package:hello_flutter/presentation/screens/device_info/widgets/battery_text.dart';
import 'package:hello_flutter/presentation/screens/device_info/widgets/memory_card.dart';
import 'package:hello_flutter/utils/logging.dart';

import 'bloc/device_info_bloc.dart';

class BatteryInfoPage extends StatefulWidget {
  const BatteryInfoPage({Key? key}) : super(key: key);

  @override
  DeviceInfoPageState createState() => DeviceInfoPageState();
}

class DeviceInfoPageState extends State<BatteryInfoPage> {
  final mainTextStyleSmall = const TextStyle(
    decoration: TextDecoration.none,
    color: Colors.black54,
    fontSize: 14.0,
    letterSpacing: 1,
  );

  late final DeviceInfoBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = DeviceInfoBloc();

    _bloc.add(InfoBatteryLevel());
    _bloc.add(InfoBatteryState());
    _bloc.add(InfoBatteryIsSaveMode());
    _bloc.add(InfoMemory());
    _bloc.add(InfoRam());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const MyAppBar(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Card(
                color: Colors.green[300],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                shadowColor: Colors.white54,
                margin: const EdgeInsets.fromLTRB(5, 10, 5, 5),
                elevation: 14,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Icon(Icons.battery_charging_full_rounded,
                            color: Colors.green[700], size: 60),
                        BlocConsumer<DeviceInfoBloc, DeviceInfoState>(
                          bloc: _bloc,
                          listener: (context, state) {
                            lol("STATE IS: ${state.batteryLevel}");
                          },
                          builder: (context, state) {
                            return Text(
                              "${state.batteryLevel}%",
                              style: const TextStyle(
                                  fontSize: 35,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            );
                          },
                        ),
                        BlocConsumer<DeviceInfoBloc, DeviceInfoState>(
                          bloc: _bloc,
                          listener: (context, state) {
                            lol("STATE2 IS: ${state.batteryState}");
                            lol("STATE3 IS: ${state.batteryIsSaveMode}");
                          },
                          builder: (context, state) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                BatteryText(
                                    title: "Battery State: ",
                                    value: state.batteryState),
                                BatteryText(
                                    title: "Save mode: ",
                                    value: state.batteryIsSaveMode),
                              ],
                            );
                          },
                        )
                      ]),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            BlocConsumer<DeviceInfoBloc, DeviceInfoState>(
              bloc: _bloc,
              listener: (context, state) {},
              builder: (context, state) {
                return MemoryCard(
                  cardColor: Colors.deepPurpleAccent,
                  iconColor: Colors.deepPurpleAccent.shade100,
                  icon: Icons.sd_storage_rounded,
                  totalMemory: state.totalMemory,
                  freeMemory: state.freeMemory,
                  unit: "GB",
                );
              },
            ),
            BlocConsumer<DeviceInfoBloc, DeviceInfoState>(
              bloc: _bloc,
              listener: (context, state) {},
              builder: (context, state) {
                return MemoryCard(
                  cardColor: Colors.orangeAccent.shade200,
                  iconColor: Colors.deepOrangeAccent,
                  icon: Icons.memory_rounded,
                  totalMemory: state.totalRam,
                  freeMemory: state.freeRam,
                  unit: "MB",
                );
              },
            ),
          ],
        )
      ],
    );
  }
}
