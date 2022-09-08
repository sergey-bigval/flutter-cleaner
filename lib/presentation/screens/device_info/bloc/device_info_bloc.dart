import 'dart:async';

import 'package:battery_plus/battery_plus.dart';
import 'package:disk_space/disk_space.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hello_flutter/presentation/screens/device_info/bloc/states.dart';
import 'package:system_info/system_info.dart';

import 'events.dart';

class DeviceInfoBloc extends Bloc<DeviceInfoEvent, DeviceInfoState> {
  final batteryStateStream = Battery().onBatteryStateChanged;
  late StreamSubscription<BatteryState> batteryListener;

  DeviceInfoBloc() : super(DeviceInfoState.initial()) {
    on<BatteryInfoEvent>(_onBatteryInfo);
    on<InfoStorageEvent>(_onStorageData);
    on<InfoRamEvent>(_onRamData);
  }

  void listenBatteryStream() {
    batteryListener = batteryStateStream.listen((batState) async {
      var batteryState = "";
      switch (batState) {
        case BatteryState.charging:
          {
            batteryState = "charging";
            break;
          }
        case BatteryState.discharging:
          {
            batteryState = "discharging";
            break;
          }
        case BatteryState.full:
          {
            batteryState = "full";
            break;
          }
        case BatteryState.unknown:
          {
            batteryState = "No info";
            break;
          }
      }

      var saveMode = "Not available";
      getSaveModeStatus().then((value) => saveMode = value);

      add(BatteryInfoEvent(
          batteryState: batteryState,
          batteryLevel: await Battery().batteryLevel,
          batteryIsSaveMode: saveMode));
    });
  }

  Future<String> getSaveModeStatus() async {
    return await Battery().isInBatterySaveMode.then((value) async {
      if (value) {
        return "enabled";
      } else {
        return "disabled";
      }
    });
  }

  void cancelBatteryListener() {
    batteryListener.cancel();
  }

  Future<void> _onBatteryInfo(
    BatteryInfoEvent event,
    Emitter emitter,
  ) async {
    emitter(state.copyWith(
        batteryLevel: event.batteryLevel,
        batteryState: event.batteryState,
        batteryIsSaveMode: event.batteryIsSaveMode));
  }

  Future<void> _onStorageData(
    InfoStorageEvent event,
    Emitter emitter,
  ) async {
    var totalMemory =
        await DiskSpace.getTotalDiskSpace.then((value) => value! / 1024);
    var freeMemory =
        await DiskSpace.getFreeDiskSpace.then((value) => value! / 1024);
    emitter(state.copyWith(totalMemory: totalMemory, freeMemory: freeMemory));
  }

  Future<void> _onRamData(
    InfoRamEvent event,
    Emitter emitter,
  ) async {
    emitter(state.copyWith(
        totalRam:
            (SysInfo.getTotalPhysicalMemory() ~/ (1024 * 1024)).toDouble(),
        freeRam:
            (SysInfo.getFreePhysicalMemory() ~/ (1024 * 1024)).toDouble()));
  }
}
