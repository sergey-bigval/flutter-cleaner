import 'dart:async';

import 'package:battery_plus/battery_plus.dart';
import 'package:disk_space/disk_space.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:system_info/system_info.dart';

class DeviceInfoBloc extends Bloc<DeviceInfoEvent, DeviceInfoState> {
  final batteryStateStream = Battery().onBatteryStateChanged;
  late StreamSubscription<BatteryState> batteryListener;

  DeviceInfoBloc() : super(DeviceInfoState.initial()) {
    on<InfoBatteryLevel>(_onInfoBatteryLevel);
    on<_InfoBatteryLevel>(_onPrivateInfoBatteryLevel);

    on<InfoBatteryState>(_onInfoBatteryState);
    on<_InfoBatteryState>(_onPrivateInfoBatteryState);

    on<InfoBatteryIsSaveMode>(_onInfoBatteryIsSaveMode);

    on<InfoMemory>(_onMemoryData);
    on<InfoRam>(_onRamData);
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
      add(_InfoBatteryState(batteryState: batteryState));
      add(_InfoBatteryLevel(batteryLevel: await Battery().batteryLevel));
    });
  }

  void cancelBatteryListener() {
    batteryListener.cancel();
  }

  Future<void> _onInfoBatteryLevel(InfoBatteryLevel event, Emitter emitter) async {
    // Timer.periodic(const Duration(seconds: 1), (timer) async {
    //   add(_InfoBatteryLevel(batteryLevel: await Battery().batteryLevel));
    // });
  }

  Future<void> _onPrivateInfoBatteryLevel(_InfoBatteryLevel event, Emitter emitter) async {
    emitter(state.copyWith(batteryLevel: event.batteryLevel));
  }

  Future<void> _onInfoBatteryState(
    InfoBatteryState event,
    Emitter emitter,
  ) async {}

  Future<void> _onPrivateInfoBatteryState(_InfoBatteryState event, Emitter emitter) async {
    emitter(state.copyWith(batteryState: event.batteryState));
  }

  Future<void> _onInfoBatteryIsSaveMode(
    InfoBatteryIsSaveMode event,
    Emitter emitter,
  ) async {
    await Battery().isInBatterySaveMode.then((value) {
      var saveModeMessage = "";
      if (value) {
        saveModeMessage = "enabled";
      } else {
        saveModeMessage = "disabled";
      }
      emitter(state.copyWith(batteryIsSaveMode: saveModeMessage));
    });
  }

  Future<void> _onMemoryData(
    InfoMemory event,
    Emitter emitter,
  ) async {
    var totalMemory = await DiskSpace.getTotalDiskSpace.then((value) => value! / 1024);
    var freeMemory = await DiskSpace.getFreeDiskSpace.then((value) => value! / 1024);
    emitter(state.copyWith(totalMemory: totalMemory, freeMemory: freeMemory));
  }

  Future<void> _onRamData(
    InfoRam event,
    Emitter emitter,
  ) async {
    emitter(state.copyWith(
        totalRam: (SysInfo.getTotalPhysicalMemory() ~/ (1024 * 1024)).toDouble(),
        freeRam: (SysInfo.getFreePhysicalMemory() ~/ (1024 * 1024)).toDouble()));
  }
}

abstract class DeviceInfoEvent {}

class InfoBatteryLevel extends DeviceInfoEvent {}

class _InfoBatteryLevel extends DeviceInfoEvent {
  final int batteryLevel;

  _InfoBatteryLevel({required this.batteryLevel});
}

class InfoBatteryState extends DeviceInfoEvent {}

class _InfoBatteryState extends DeviceInfoEvent {
  final String batteryState;

  _InfoBatteryState({required this.batteryState});
}

class InfoBatteryIsSaveMode extends DeviceInfoEvent {}

class InfoMemory extends DeviceInfoEvent {}

class InfoRam extends DeviceInfoEvent {}

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
