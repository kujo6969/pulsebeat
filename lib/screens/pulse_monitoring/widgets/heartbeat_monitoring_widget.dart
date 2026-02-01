import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:testing3/screens/pulse_monitoring/widgets/heartbeat_painter_widget.dart';

final flutterReactiveBle = FlutterReactiveBle();
final serviceUuid = Uuid.parse("180D"); // Heart Rate Service
final characteristicUuid = Uuid.parse("2A37"); // Heart Rate Measurement

class HeartbeatMonitoringWidget extends StatefulWidget {
  const HeartbeatMonitoringWidget({super.key});

  @override
  State<HeartbeatMonitoringWidget> createState() => HeartbeatMonitoringWidgetState();
}

class HeartbeatMonitoringWidgetState extends State<HeartbeatMonitoringWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  int bpm = 0;
  String status = "No Data";
  DiscoveredDevice? device;
  StreamSubscription<List<int>>? _bleSubscription;
  int _lastBeatTime = 0;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat();

    scanAndConnect();
  }

  void scanAndConnect() {
    flutterReactiveBle.scanForDevices(withServices: [serviceUuid]).listen((d) {
      if (d.name == "PulseBeat Necklace") {
        device = d;
        connectToDevice(d);
      }
    });
  }

  void connectToDevice(DiscoveredDevice device) {
    flutterReactiveBle.connectToDevice(id: device.id).listen((connectionState) {
      if (connectionState.connectionState == DeviceConnectionState.connected) {
        subscribeToHeartbeats(device);
      }
    });
  }

  void subscribeToHeartbeats(DiscoveredDevice device) {
    final characteristic = QualifiedCharacteristic(
      serviceId: serviceUuid,
      characteristicId: characteristicUuid,
      deviceId: device.id,
    );

    _bleSubscription = flutterReactiveBle
        .subscribeToCharacteristic(characteristic)
        .listen((data) {
          print("darta $data");
          if (data.isNotEmpty) {
            int now = DateTime.now().millisecondsSinceEpoch;

            if (_lastBeatTime == 0 || now - _lastBeatTime > 600) {
              if (_lastBeatTime != 0) {
                int interval = now - _lastBeatTime;
                int newBpm = (60000 ~/ interval);
                if (bpm != newBpm) {
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
          }
        });
  }

  String _getStatus(int bpm) {
    if (bpm < 55) return "⚠️ Low Pulse (Risk of Fainting)";
    if (bpm > 100) return "⚠️ Elevated Pulse";
    return "Normal";
  }

  Color _getStatusColor() {
    if (status.contains("⚠️")) return Colors.red;
    return Colors.green;
  }

  @override
  void dispose() {
    _animationController.dispose();
    _bleSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 150,
          width: double.infinity,
          child: CustomPaint(
            painter: HeartbeatPainter(_animationController.value),
          ),
        ),
        Text(
          "$bpm BPM",
          style: TextStyle(
            color: _getStatusColor(),
            fontSize: 48,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          status,
          style: TextStyle(
            color: _getStatusColor(),
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          "Real Data from ESP32",
          style: TextStyle(
            color: Colors.grey[600],
            fontWeight: FontWeight.w700,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }
}
