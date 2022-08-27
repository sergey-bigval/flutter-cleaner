import 'dart:async';
import 'dart:io';

import 'package:battery_plus/battery_plus.dart';
import 'package:disk_space/disk_space.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hello_flutter/screens/device_info/widgets/app_bar.dart';
import 'package:hello_flutter/screens/device_info/widgets/battery_text.dart';
import 'package:hello_flutter/screens/device_info/widgets/memory_card.dart';
import 'package:hello_flutter/utils/logging.dart';
import 'package:path_provider/path_provider.dart';
import 'package:system_info/system_info.dart';

import 'bloc/device_info_bloc.dart';

class BatteryInfoPage extends StatefulWidget {
  const BatteryInfoPage({Key? key}) : super(key: key);

  @override
  DeviceInfoPageState createState() => DeviceInfoPageState();
}

class DeviceInfoPageState extends State<BatteryInfoPage> {
  StreamSubscription<BatteryState>? _batteryStateSubscription;

  final mainTextStyleSmall = const TextStyle(
    decoration: TextDecoration.none,
    color: Colors.black54,
    fontSize: 14.0,
    letterSpacing: 1,
  );

  double _diskSpace = 0;
  Map<Directory, double> _directorySpace = {};

  double totalDiskSpace = 0;
  double freeDiskSpace = 0;

  int totalRam = SysInfo.getTotalPhysicalMemory() ~/ (1024 * 1024);
  int freeRam = SysInfo.getFreePhysicalMemory() ~/ (1024 * 1024);

  late final DeviceInfoBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = DeviceInfoBloc();

    _bloc.add(InfoBatteryLevel());
    _bloc.add(InfoBatteryState());
    _bloc.add(InfoBatteryIsSaveMode());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: const MyAppBar(),
        body: Column(
          children: [
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
                MemoryCard(
                  cardColor: Colors.deepPurpleAccent,
                  iconColor: Colors.deepPurpleAccent.shade100,
                  icon: Icons.sd_storage_rounded,
                  totalMemory: totalDiskSpace,
                  freeMemory: freeDiskSpace,
                  unit: "GB",
                ),
                MemoryCard(
                  cardColor: Colors.orangeAccent.shade200,
                  iconColor: Colors.deepOrangeAccent,
                  icon: Icons.memory_rounded,
                  totalMemory: totalRam.toDouble(),
                  freeMemory: freeRam.toDouble(),
                  unit: "MB",
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    if (_batteryStateSubscription != null) {
      _batteryStateSubscription!.cancel();
    }
  }

  void initDiskSpace() async {
    double? diskSpace = 0;

    diskSpace = await DiskSpace.getFreeDiskSpace;

    List<Directory> directories;
    Map<Directory, double> directorySpace = {};

    if (Platform.isIOS) {
      directories = [await getApplicationDocumentsDirectory()];
    } else if (Platform.isAndroid) {
      directories =
          await getExternalStorageDirectories(type: StorageDirectory.movies)
              .then(
        (list) async => list ?? [await getApplicationDocumentsDirectory()],
      );
    } else {
      return;
    }

    for (var directory in directories) {
      var space = await DiskSpace.getFreeDiskSpaceForPath(directory.path);
      directorySpace.addEntries([MapEntry(directory, space!)]);
    }

    if (!mounted) return;

    setState(() {
      _diskSpace = diskSpace!;
      _directorySpace = directorySpace;
      lol("disc SPACE = ${diskSpace / 1024}");
      lol("directory SPACE = $directorySpace");
      // values are in GB
      DiskSpace.getFreeDiskSpace.then((value) => freeDiskSpace = value! / 1024);
      DiskSpace.getTotalDiskSpace
          .then((value) => totalDiskSpace = value! / 1024);
    });
  }
}