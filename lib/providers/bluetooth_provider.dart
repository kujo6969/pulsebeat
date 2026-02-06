import 'dart:async';
import 'package:flutter_blue_plus/flutter_blue_plus.dart' as fb;
import 'package:flutter_riverpod/legacy.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:testing3/services/firestore_service.dart';
import '../models/ble_state.dart';

part 'bluetooth_provider.g.dart';

/// A global provider to track connection status
final isConnectedProvider = StateProvider<bool>((ref) => false);
final connectedTo = StateProvider<String>((ref) => '');
final connectedDeviceProvider = StateProvider<fb.BluetoothDevice?>(
  (ref) => null,
);
final bpmService = BpmService();
final bpmProvider = StateProvider<int>((ref) => 0);

@riverpod
class BluetoothNotifier extends _$BluetoothNotifier {
  StreamSubscription<List<fb.ScanResult>>? _scanSub;
  StreamSubscription<List<int>>? _dataSub;
  fb.BluetoothDevice? _device;

  @override
  BleState build() {
    ref.onDispose(() {
      _scanSub?.cancel();
      _dataSub?.cancel();
      _device?.disconnect();
    });

    return const BleState.disconnected();
  }

  void scanning() {
    state = const BleState.scanning();
    ref.read(isConnectedProvider.notifier).state = false;
  }

  void connecting(String deviceId, String deviceName) {
    state = BleState.connecting();
    ref.read(isConnectedProvider.notifier).state = false;
  }

  void connected(String deviceId, String deviceName) {
    state = BleState.connected(
      deviceId: deviceId,
      deviceName: deviceName,
      data: '',
    );
    ref.read(isConnectedProvider.notifier).state = true;
    ref.read(connectedTo.notifier).state = deviceName;
    final bpm = ref.watch(bpmProvider);
    bpmService.addBpmReading(deviceId, bpm);
  }

  void disconnected() {
    state = const BleState.disconnected();
    _device?.disconnect();
    _scanSub?.cancel();
    _dataSub?.cancel();
    ref.read(isConnectedProvider.notifier).state = false;
    ref.read(connectedTo.notifier).state = '';
    ref.read(connectedDeviceProvider.notifier).state = null;
  }

  // Optional: expose isConnected getter for convenience
  bool get isConnected => ref.read(isConnectedProvider);
}
