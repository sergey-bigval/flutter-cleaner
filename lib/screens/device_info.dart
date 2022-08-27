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
