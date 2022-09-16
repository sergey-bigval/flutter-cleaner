import 'dart:async';

import 'package:battery_plus/battery_plus.dart';
import 'package:disk_space/disk_space.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hello_flutter/presentation/screens/device_info/bloc/states.dart';
import 'package:hello_flutter/presentation/screens/device_info/enum/battery_save_mode_enum.dart';
import 'package:system_info/system_info.dart';

import 'events.dart';

class DeviceInfoBloc extends Bloc<DeviceInfoEvent, DeviceInfoState> {
  late final Battery _battery;
  late final Stream<BatteryState> _batteryStateStream;
  late final StreamSubscription<BatteryState> _batteryListener;

  DeviceInfoBloc() : super(DeviceInfoState.initial()) {
    _battery = Battery();
    _batteryStateStream = _battery.onBatteryStateChanged;
    listenBatteryStream();

    on<DeviceInfoGetBatteryInfoEvent>(_onBatteryInfo);
    on<DeviceInfoGetInfoStorageEvent>(_onStorageData);
    on<DeviceInfoGetInfoRamEvent>(_onRamData);
  }

  @override
  Future<void> close() async {
    _batteryListener.cancel();
    super.close();
  }

  void listenBatteryStream() {
    _batteryListener = _batteryStateStream.listen((batteryState) async {

      var saveMode = await getSaveModeStatus();

      add(
        DeviceInfoGetBatteryInfoEvent(
          batteryState: batteryState,
          batteryLevel: await Battery().batteryLevel,
          batterySaveMode: saveMode,
        ),
      );
    });
  }

  Future<BatterySaveMode> getSaveModeStatus() async {
    try {
      var result = await _battery.isInBatterySaveMode.timeout(
        const Duration(seconds: 1),
      );
      return result ? BatterySaveMode.enabled : BatterySaveMode.disabled;
    } catch (e) {
      return BatterySaveMode.notAvailable;
    }
  }

  Future<void> _onBatteryInfo(
    DeviceInfoGetBatteryInfoEvent event,
    Emitter emitter,
  ) async {
    emitter(
      state.copyWith(
        batteryLevel: event.batteryLevel,
        batteryState: event.batteryState,
        batterySaveMode: event.batterySaveMode,
      ),
    );
  }

  Future<void> _onStorageData(DeviceInfoGetInfoStorageEvent event, Emitter emitter) async {
    var totalMemory = await DiskSpace.getTotalDiskSpace ?? 0;
    var freeMemory = await DiskSpace.getFreeDiskSpace ?? 0;
    emitter(
      state.copyWith(
        totalMemory: totalMemory / 1024,
        freeMemory: freeMemory / 1024,
      ),
    );
  }

  Future<void> _onRamData(DeviceInfoGetInfoRamEvent event, Emitter emitter) async {
    emitter(state.copyWith(
        totalRam:
            (SysInfo.getTotalPhysicalMemory() ~/ (1024 * 1024)).toDouble(),
        freeRam:
            (SysInfo.getFreePhysicalMemory() ~/ (1024 * 1024)).toDouble()));
  }
}
