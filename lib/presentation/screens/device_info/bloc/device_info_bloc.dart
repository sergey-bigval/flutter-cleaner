import 'dart:async';

import 'package:battery_plus/battery_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hello_flutter/utils/logging.dart';

class DeviceInfoBloc extends Bloc<DeviceInfoEvent, DeviceInfoState> {
  DeviceInfoBloc() : super(DeviceInfoState.initial()) {
    on<InfoBatteryLevel>(_onInfoBatteryLevel);
      on<_InfoBatteryLevel>(_onInnerInfoBatteryLevel);

    on<InfoBatteryState>(_onInfoBatteryState);
    on<InfoBatteryIsSaveMode>(_onInfoBatteryIsSaveMode);
  }

  Future<void> _onInfoBatteryLevel(InfoBatteryLevel event, Emitter emitter) async {
    Timer.periodic(const Duration(seconds: 5), (timer) async {
      add(_InfoBatteryLevel(batteryLevel: await Battery().batteryLevel));
    });
  }

  Future<void> _onInnerInfoBatteryLevel(_InfoBatteryLevel event, Emitter emitter) async {
      emitter(state.copyWith(batteryLevel: event.batteryLevel));
  }

  Future<void> _onInfoBatteryState(
    InfoBatteryState event,
    Emitter emitter,
  ) async {
    var batteryState = "";
    Battery().onBatteryStateChanged.listen((BatteryState batState) {
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

    });
    emitter(state.copyWith(batteryState: batteryState));
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
}

abstract class DeviceInfoEvent {}

class InfoBatteryLevel extends DeviceInfoEvent {}
class _InfoBatteryLevel extends DeviceInfoEvent {
  final int batteryLevel;

  _InfoBatteryLevel({required this.batteryLevel});
}


class InfoBatteryState extends DeviceInfoEvent {}
class InfoBatteryIsSaveMode extends DeviceInfoEvent {}

class DeviceInfoState {
  final int batteryLevel;
  final String batteryState;
  final String batteryIsSaveMode;

  DeviceInfoState(
      {required this.batteryLevel,
      required this.batteryState,
      required this.batteryIsSaveMode});

  factory DeviceInfoState.initial() => DeviceInfoState(
      batteryLevel: 0,
      batteryState: "Not available",
      batteryIsSaveMode: "disabled");

  DeviceInfoState copyWith(
      {int? batteryLevel, String? batteryState, String? batteryIsSaveMode}) {
    return DeviceInfoState(
      batteryLevel: batteryLevel ?? this.batteryLevel,
      batteryState: batteryState ?? this.batteryState,
      batteryIsSaveMode: batteryIsSaveMode ?? this.batteryIsSaveMode,
    );
  }
}
