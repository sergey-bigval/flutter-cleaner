class DeviceInfoState {
  final int batteryLevel;
  final String batteryState;
  final String batteryIsSaveMode;

  final double totalMemory;
  final double freeMemory;

  final double totalRam;
  final double freeRam;

  DeviceInfoState(
      {required this.batteryLevel,
        required this.batteryState,
        required this.batteryIsSaveMode,
        required this.totalMemory,
        required this.freeMemory,
        required this.totalRam,
        required this.freeRam});

  factory DeviceInfoState.initial() => DeviceInfoState(
    batteryLevel: 0,
    batteryState: "Not available",
    batteryIsSaveMode: "disabled",
    totalMemory: 0,
    freeMemory: 0,
    totalRam: 0,
    freeRam: 0,
  );

  DeviceInfoState copyWith({
    int? batteryLevel,
    String? batteryState,
    String? batteryIsSaveMode,
    double? totalMemory,
    double? freeMemory,
    double? totalRam,
    double? freeRam,
  }) {
    return DeviceInfoState(
      batteryLevel: batteryLevel ?? this.batteryLevel,
      batteryState: batteryState ?? this.batteryState,
      batteryIsSaveMode: batteryIsSaveMode ?? this.batteryIsSaveMode,
      totalMemory: totalMemory ?? this.totalMemory,
      freeMemory: freeMemory ?? this.freeMemory,
      totalRam: totalRam ?? this.totalRam,
      freeRam: freeRam ?? this.freeRam,
    );
  }
}
