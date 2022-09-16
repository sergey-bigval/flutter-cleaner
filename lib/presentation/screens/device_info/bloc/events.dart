import 'package:battery_plus/battery_plus.dart';

import '../enum/battery_save_mode_enum.dart';

abstract class DeviceInfoEvent {}

class DeviceInfoGetBatteryInfoEvent extends DeviceInfoEvent {
  final int batteryLevel;
  final BatteryState batteryState;
  final BatterySaveMode batterySaveMode;

  DeviceInfoGetBatteryInfoEvent(
      {required this.batteryState,
      required this.batteryLevel,
      required this.batterySaveMode});
}

class DeviceInfoGetInfoStorageEvent extends DeviceInfoEvent {}

class DeviceInfoGetInfoRamEvent extends DeviceInfoEvent {}
