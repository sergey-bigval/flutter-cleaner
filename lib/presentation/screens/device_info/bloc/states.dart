import 'package:battery_plus/battery_plus.dart';
import 'package:hello_flutter/presentation/screens/device_info/enum/battery_save_mode_enum.dart';

class DeviceInfoState {
  final int batteryLevel;
  final BatteryState batteryState;
  final BatterySaveMode batterySaveMode;

  final double totalMemory;
  final double freeMemory;

  final double totalRam;
  final double freeRam;

  DeviceInfoState(
      {required this.batteryLevel,
      required this.batteryState,
      required this.batterySaveMode,
      required this.totalMemory,
      required this.freeMemory,
      required this.totalRam,
      required this.freeRam});

  factory DeviceInfoState.initial() => DeviceInfoState(
        batteryLevel: 0,
        batteryState: BatteryState.unknown,
        batterySaveMode: BatterySaveMode.notAvailable,
        totalMemory: 0,
        freeMemory: 0,
        totalRam: 0,
        freeRam: 0,
      );

  DeviceInfoState copyWith({
    int? batteryLevel,
    BatteryState? batteryState,
    BatterySaveMode? batterySaveMode,
    double? totalMemory,
    double? freeMemory,
    double? totalRam,
    double? freeRam,
  }) {
    return DeviceInfoState(
      batteryLevel: batteryLevel ?? this.batteryLevel,
      batteryState: batteryState ?? this.batteryState,
      batterySaveMode: batterySaveMode ?? this.batterySaveMode,
      totalMemory: totalMemory ?? this.totalMemory,
      freeMemory: freeMemory ?? this.freeMemory,
      totalRam: totalRam ?? this.totalRam,
      freeRam: freeRam ?? this.freeRam,
    );
  }
}
