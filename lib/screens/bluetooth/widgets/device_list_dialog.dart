import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:testing3/models/ble_state.dart';
import 'package:testing3/providers/bluetooth_provider.dart';

class DeviceListDialog extends ConsumerStatefulWidget {
  const DeviceListDialog({super.key});

  @override
  ConsumerState<DeviceListDialog> createState() => _DeviceListDialogState();
}

class _DeviceListDialogState extends ConsumerState<DeviceListDialog> {
  final List<ScanResult> _results = [];
  StreamSubscription<List<ScanResult>>? _scanSub;

  int bpm = 0;
  String status = "Disconnected";
  int _lastBeatTime = 0;

  @override
  void initState() {
    super.initState();
    _startScanWithPermissions();
  }

  Future<void> _startScanWithPermissions() async {
    final bluetoothScanStatus = await Permission.bluetoothScan.request();
    final bluetoothConnectStatus = await Permission.bluetoothConnect.request();
    final locationStatus = await Permission.location.request();

    if (bluetoothScanStatus.isDenied ||
        bluetoothConnectStatus.isDenied ||
        locationStatus.isDenied) {
      if (mounted) Navigator.pop(context);
      return;
    }

    final state = await FlutterBluePlus.adapterState.first;
    if (state != BluetoothAdapterState.on) {
      await FlutterBluePlus.turnOn();
    }

    _startScan();
  }

  void _startScan() async {
    _results.clear();

    await _scanSub?.cancel();
    _scanSub = null;

    try {
      final state = await FlutterBluePlus.adapterState.first;
      if (state != BluetoothAdapterState.on) {
        print("Bluetooth is off, cannot scan");
        return; // Don't start scanning
      }

      // Listen to scan results safely
      _scanSub = FlutterBluePlus.onScanResults.listen(
        (results) {
          for (final r in results) {
            if (_results.any((e) => e.device.remoteId == r.device.remoteId)) {
              continue;
            }
            setState(() => _results.add(r));
          }
        },
        onError: (error) {
          print("Scan error: $error");
          // Update state to disconnected if scanning fails
          final notifier = ref.read(bluetoothProvider.notifier);
          notifier.disconnected();
        },
        cancelOnError: true,
      );

      // Start scanning safely
      await FlutterBluePlus.startScan(
        timeout: const Duration(seconds: 15),
      ).catchError((e) {
        print("StartScan failed: $e");
        final notifier = ref.read(bluetoothProvider.notifier);
        notifier.disconnected();
      });

      // Wait for scan to finish
      await FlutterBluePlus.isScanning.where((val) => val == false).first;
    } catch (e) {
      print("Scanning exception caught: $e");
      final notifier = ref.read(bluetoothProvider.notifier);
      notifier.disconnected();
    } finally {
      // Always cancel subscription after scan or error
      await _scanSub?.cancel();
      _scanSub = null;
    }
  }

  @override
  void dispose() {
    _scanSub?.cancel();
    FlutterBluePlus.stopScan();
    super.dispose();
  }

  String _getDeviceName(ScanResult result) {
    return result.advertisementData.advName.isNotEmpty
        ? result.advertisementData.advName
        : result.device.platformName.isNotEmpty
        ? result.device.platformName
        : result.device.remoteId.toString();
  }

  Future<void> _connectToDevice(ScanResult result) async {
    final notifier = ref.read(bluetoothProvider.notifier);

    notifier.connecting(result.device.remoteId.str, _getDeviceName(result));

    try {
      await result.device.connect(
        timeout: const Duration(seconds: 10),
        license: License.free,
      );

      await _subscribeToHeartRate(result.device);

      notifier.connected(result.device.remoteId.str, _getDeviceName(result));

      if (mounted) Navigator.pop(context, result.device);
    } catch (e) {
      print("Connection error: $e");
      notifier.disconnected();
    }
  }

  Future<void> _subscribeToHeartRate(BluetoothDevice device) async {
    final services = await device.discoverServices();

    for (var service in services) {
      if (service.uuid.toString().toLowerCase() ==
          "0000180d-0000-1000-8000-00805f9b34fb") {
        // Heart Rate service
        for (var characteristic in service.characteristics) {
          if (characteristic.uuid.toString().toLowerCase() ==
              "00002a37-0000-1000-8000-00805f9b34fb") {
            await characteristic.setNotifyValue(true);

            characteristic.lastValueStream.listen((data) {
              print("BLE data received: $data"); // debug

              if (data.isNotEmpty && data[0] == 1) {
                int now = DateTime.now().millisecondsSinceEpoch;

                if (_lastBeatTime != 0) {
                  int interval = now - _lastBeatTime;
                  if (interval > 0) {
                    int newBpm = (60000 ~/ interval);
                    setState(() {
                      bpm = newBpm;
                      status = _getStatus(newBpm);
                    });
                  }
                } else {
                  setState(() {
                    status = "First beat received...";
                  });
                }

                _lastBeatTime = now;
              }
            });
          }
        }
      }
    }
  }

  String _getStatus(int bpm) {
    if (bpm < 55) return "⚠️ Low Pulse";
    if (bpm > 100) return "⚠️ Elevated Pulse";
    return "Normal";
  }

  @override
  Widget build(BuildContext context) {
    final btState = ref.watch(bluetoothProvider);
    final connected = ref.watch(isConnectedProvider);
    print("isConnected $connected");
    return AlertDialog(
      title: const Text('Devices available'),
      content: SizedBox(
        width: double.maxFinite,
        child: btState.when(
          disconnected: () => _results.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: _results.length,
                  itemBuilder: (context, index) {
                    final result = _results[index];
                    return ListTile(
                      title: Text(_getDeviceName(result)),
                      subtitle: Text('ID: ${result.device.remoteId}'),
                      trailing: Text('RSSI: ${result.rssi}'),
                      onTap: () => _connectToDevice(result),
                    );
                  },
                ),
          scanning: () => const Center(child: CircularProgressIndicator()),
          connecting: () => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text('Connecting to ...'),
            ],
          ),
          connected: (deviceId, deviceName, data) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Connected to $deviceName'),
              Text('BPM: $bpm'),
              Text('Status: $status'),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ],
    );
  }
}
