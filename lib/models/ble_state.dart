import 'package:freezed_annotation/freezed_annotation.dart';

part 'ble_state.freezed.dart';

@freezed
class BleState with _$BleState {
  const factory BleState.disconnected() = _Disconnected;
  const factory BleState.scanning() = _Scanning;
  const factory BleState.connecting() = _Connecting;
  const factory BleState.connected({
    required String deviceId,
    required String deviceName,
    required String data,
  }) = _Connected;
}
