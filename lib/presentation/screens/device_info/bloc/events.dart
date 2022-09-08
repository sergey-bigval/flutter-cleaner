abstract class DeviceInfoEvent {}

class BatteryInfoEvent extends DeviceInfoEvent {
  final String batteryState;
  final int batteryLevel;
  final String batteryIsSaveMode;

  BatteryInfoEvent(
      {required this.batteryState,
      required this.batteryLevel,
      required this.batteryIsSaveMode});
}

class InfoStorageEvent extends DeviceInfoEvent {}

class InfoRamEvent extends DeviceInfoEvent {}
