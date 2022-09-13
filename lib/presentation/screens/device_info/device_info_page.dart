import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hello_flutter/presentation/screens/device_info/enum/battery_save_mode_enum.dart';
import 'package:hello_flutter/presentation/screens/device_info/widgets/app_bar.dart';
import 'package:hello_flutter/presentation/screens/device_info/widgets/battery_text.dart';
import 'package:hello_flutter/presentation/screens/device_info/widgets/memory_card.dart';

import 'bloc/device_info_bloc.dart';
import 'bloc/events.dart';
import 'bloc/states.dart';

class DeviceInfoPage extends StatefulWidget {
  const DeviceInfoPage({Key? key}) : super(key: key);

  @override
  DeviceInfoPageState createState() => DeviceInfoPageState();
}

class DeviceInfoPageState extends State<DeviceInfoPage> {
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
    _bloc.add(DeviceInfoGetInfoStorageEvent());
    _bloc.add(DeviceInfoGetInfoRamEvent());
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
                        BlocBuilder<DeviceInfoBloc, DeviceInfoState>(
                          bloc: _bloc,
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
                        BlocBuilder<DeviceInfoBloc, DeviceInfoState>(
                          bloc: _bloc,
                          builder: (context, state) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                BatteryText(
                                    title: "Battery State: ",
                                    value: getBatteryState(state.batteryState)),
                                BatteryText(
                                    title: "Save mode: ",
                                    value: getSaveModeStatus(
                                        state.batterySaveMode)),
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
            BlocBuilder<DeviceInfoBloc, DeviceInfoState>(
              bloc: _bloc,
              buildWhen: (previous, current) =>
                  previous.totalMemory != current.totalMemory ||
                  previous.freeMemory != current.freeMemory,
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
            BlocBuilder<DeviceInfoBloc, DeviceInfoState>(
              bloc: _bloc,
              buildWhen: (previous, current) =>
                  previous.totalRam != current.totalRam ||
                  previous.freeRam != current.freeRam,
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

  String getSaveModeStatus(BatterySaveMode status) {
    switch (status) {
      case BatterySaveMode.enabled:
        return "enabled";
      case BatterySaveMode.disabled:
        return "disabled";
      default:
        return "not available";
    }
  }

  String getBatteryState(BatteryState state) {
    switch (state) {
      case BatteryState.charging:
        return "charging";
      case BatteryState.discharging:
        return "discharging";
      case BatteryState.full:
        return "full";
      default:
        return "No info";
    }
  }
}
