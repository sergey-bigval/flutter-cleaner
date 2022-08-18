import 'dart:async';
import 'dart:io';

import 'package:battery_plus/battery_plus.dart';
import 'package:disk_space/disk_space.dart';
import 'package:flutter/material.dart';
import 'package:hello_flutter/utils/logging.dart';
import 'package:path_provider/path_provider.dart';
import 'package:system_info/system_info.dart';

class BatteryInfoPage extends StatefulWidget {
  const BatteryInfoPage({Key? key}) : super(key: key);

  @override
  DeviceInfoPageState createState() => DeviceInfoPageState();
}

class DeviceInfoPageState extends State<BatteryInfoPage> {
  final Battery _battery = Battery();

  String _batteryState = "";
  StreamSubscription<BatteryState>? _batteryStateSubscription;
  int _batteryLevel = 0;
  String _isInPowerSaveMode = "Not available";

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


  @override
  void initState() {
    super.initState();
    initDiskSpace();
    getBatteryState();
    checkBatterSaveMode();

    Timer.periodic(const Duration(seconds: 5), (timer) {
      getBatteryLevel();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.grey[100],
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text("Device Info",
                style: TextStyle(
                    decoration: TextDecoration.none,
                    color: Colors.blueGrey[700],
                    fontSize: 30,
                    fontFamily: "Comfortaa")),
          ),
          Row(children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                          margin: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          elevation: 14,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(children: [
                                  Icon(Icons.battery_charging_full_rounded,
                                      color: Colors.green[700], size: 75),
                                  Text(
                                    "$_batteryLevel%",
                                    style: const TextStyle(
                                        fontSize: 40,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 14),
                                        child: RichText(
                                          text: TextSpan(
                                              style: const TextStyle(
                                                fontSize: 15.0,
                                                color: Colors.white,
                                              ),
                                              children: [
                                                const TextSpan(
                                                    text: "Battery state: ",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                TextSpan(
                                                  text: _batteryState,
                                                ),
                                              ]),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 14),
                                        child: RichText(
                                          text: TextSpan(
                                              style: const TextStyle(
                                                fontSize: 15.0,
                                                color: Colors.white,
                                              ),
                                              children: [
                                                const TextSpan(
                                                    text: "Save mode: ",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                TextSpan(
                                                  text: _isInPowerSaveMode,
                                                ),
                                              ]),
                                        ),
                                      ),
                                    ],
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
                      Expanded(
                        flex: 1,
                        child: Card(
                          color: Colors.deepPurple[200],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          shadowColor: Colors.white54,
                          margin: const EdgeInsets.fromLTRB(20, 10, 10, 10),
                          elevation: 14,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(children: [
                                  Icon(Icons.sd_storage_rounded,
                                      color: Colors.deepPurple[400], size: 40),
                                  Text(
                                    "${totalDiskSpace.toStringAsFixed(1)}/${(totalDiskSpace - freeDiskSpace).toStringAsFixed(1)}GB",
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ]),
                                const SizedBox(height: 5),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 6),
                                      child: RichText(
                                        text: TextSpan(
                                            style: const TextStyle(
                                              fontSize: 12.0,
                                              color: Colors.white,
                                            ),
                                            children: [
                                              const TextSpan(
                                                  text: "Total space: ",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              TextSpan(
                                                text:
                                                    "${totalDiskSpace.toStringAsFixed(3)}GB",
                                              ),
                                            ]),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 6),
                                      child: RichText(
                                        text: TextSpan(
                                            style: const TextStyle(
                                              fontSize: 11.1,
                                              color: Colors.white,
                                            ),
                                            children: [
                                              const TextSpan(
                                                  text: "Occupied space: ",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              TextSpan(
                                                text:
                                                    "${(totalDiskSpace - freeDiskSpace).toStringAsFixed(3)}GB",
                                              ),
                                            ]),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 6),
                                      child: RichText(
                                        text: TextSpan(
                                            style: const TextStyle(
                                              fontSize: 12.0,
                                              color: Colors.white,
                                            ),
                                            children: [
                                              const TextSpan(
                                                  text: "Free space: ",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              TextSpan(
                                                text:
                                                    "${freeDiskSpace.toStringAsFixed(3)}GB",
                                              ),
                                            ]),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Card(
                          color: Colors.yellow[700],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          shadowColor: Colors.white54,
                          margin: const EdgeInsets.fromLTRB(10, 10, 20, 10),
                          elevation: 14,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(children: [
                                  Icon(Icons.memory_rounded,
                                      color: Colors.yellow[900], size: 40),
                                  Text(
                                    "$totalRam/${totalRam - freeRam}MB",
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ]),
                                const SizedBox(height: 5),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 6),
                                      child: RichText(
                                        text: TextSpan(
                                            style: const TextStyle(
                                              fontSize: 12.0,
                                              color: Colors.white,
                                            ),
                                            children: [
                                              const TextSpan(
                                                  text: "Total ram: ",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              TextSpan(
                                                text:
                                                    "$totalRam MB",
                                              ),
                                            ]),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 6),
                                      child: RichText(
                                        text: TextSpan(
                                            style: const TextStyle(
                                              fontSize: 12.0,
                                              color: Colors.white,
                                            ),
                                            children: [
                                              const TextSpan(
                                                  text: "Occupied ram: ",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              TextSpan(
                                                text:
                                                    "${totalRam - freeRam}MB",
                                              ),
                                            ]),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 6),
                                      child: RichText(
                                        text: TextSpan(
                                            style: const TextStyle(
                                              fontSize: 12.0,
                                              color: Colors.white,
                                            ),
                                            children: [
                                              const TextSpan(
                                                  text: "Free space: ",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              TextSpan(
                                                text:
                                                    "$freeRam MB",
                                              ),
                                            ]),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ]),
        ]),
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

  void getBatteryState() {
    _batteryStateSubscription =
        _battery.onBatteryStateChanged.listen((BatteryState state) {
      var batState = "";
      switch (state) {
        case BatteryState.charging:
          {
            batState = "charging";
            break;
          }
        case BatteryState.discharging:
          {
            batState = "discharging";
            break;
          }
        case BatteryState.full:
          {
            batState = "full";
            break;
          }
        case BatteryState.unknown:
          {
            batState = "No info";
            break;
          }
      }
      setState(() {
        _batteryState = batState;
      });
    });
  }

  getBatteryLevel() async {
    final level = await _battery.batteryLevel;
    setState(() {
      _batteryLevel = level;
    });
  }

  checkBatterSaveMode() async {
    await _battery.isInBatterySaveMode.then((value) {
      var saveModeMessage = "";
      if (value) {
        saveModeMessage = "enabled";
      } else {
        saveModeMessage = "disabled";
      }
      setState(() {
        _isInPowerSaveMode = saveModeMessage;
      });
    });
  }
}
