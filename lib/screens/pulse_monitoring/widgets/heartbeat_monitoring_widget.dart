import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:testing3/providers/bluetooth_provider.dart';
import 'package:testing3/widgets/heartbeat_painter_widget.dart';

class HeartbeatMonitoringWidget extends ConsumerStatefulWidget {
  final BluetoothDevice device;

  const HeartbeatMonitoringWidget({required this.device, super.key});

  @override
  ConsumerState<HeartbeatMonitoringWidget> createState() =>
      _HeartbeatMonitoringWidgetState();
}

class _HeartbeatMonitoringWidgetState
    extends ConsumerState<HeartbeatMonitoringWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  int bpm = 60;
  String status = "No Data";
  StreamSubscription<List<int>>? _subscription;

  final serviceUuid = Guid("12345678-1234-1234-1234-1234567890ab");
  final characteristicUuid = Guid("87654321-4321-4321-4321-0987654321ba");

  late List<double> points;
  final int frameWidth = 300;
  final double midY = 75;

  // Realistic ECG waveform (multiple points per wave)
  late List<double> ecgPattern;
  List<double> currentPattern = [];
  int patternIndex = 0;

  @override
  void initState() {
    super.initState();

    points = List.filled(frameWidth, midY);

    ecgPattern = _generateEcgPattern();

    _animationController =
        AnimationController(
            vsync: this,
            duration: const Duration(milliseconds: 16),
          )
          ..addListener(() {
            _updateWave();
          })
          ..repeat();

    _subscribeToHeartbeats();
  }

  Future<void> _subscribeToHeartbeats() async {
    final services = await widget.device.discoverServices();

    for (var service in services) {
      if (service.uuid == serviceUuid) {
        for (var characteristic in service.characteristics) {
          if (characteristic.uuid == characteristicUuid) {
            await characteristic.setNotifyValue(true);

            _subscription = characteristic.lastValueStream.listen((data) {
              if (data.isNotEmpty) {
                final receivedBpm = data[0];
                if (receivedBpm > 0) {
                  setState(() {
                    bpm = receivedBpm;
                    status = _getStatus(bpm);
                  });
                  ref.read(bpmProvider.notifier).state = bpm;

                  final deviceId = widget.device.remoteId.str;
                  bpmService.addBpmReading(deviceId, bpm);
                }
              }
            });
          }
        }
      }
    }
  }

  void _updateWave() {
    for (int i = 0; i < points.length - 1; i++) {
      points[i] = points[i + 1];
    }

    double newY = midY + Random().nextDouble() * 1.5;

    final intervalFrames = (60 / bpm * 60).clamp(5, 300);

    double bpmFactor = ((bpm - 40) / 80 * (1.5 - 0.5) + 0.5).clamp(0.5, 1.5);

    if (currentPattern.isEmpty &&
        (DateTime.now().millisecondsSinceEpoch ~/ 16) %
                intervalFrames.toInt() ==
            0) {
      currentPattern = ecgPattern.map((e) {
        if (e > 30) return e * bpmFactor;
        return e;
      }).toList();
      patternIndex = 0;
    }

    if (currentPattern.isNotEmpty) {
      newY = midY - currentPattern[patternIndex];
      patternIndex++;
      if (patternIndex >= currentPattern.length) currentPattern = [];
    }

    points[points.length - 1] = newY;

    setState(() {});
  }

  // Generate smooth ECG pattern
  List<double> _generateEcgPattern() {
    final List<double> pattern = [];
    void addWave(double start, double peak, int steps) {
      for (int i = 0; i < steps; i++) {
        // simple linear rise and fall
        double value;
        if (i < steps / 2) {
          value = start + (peak - start) * (i / (steps / 2));
        } else {
          value = peak - (peak - start) * ((i - steps / 2) / (steps / 2));
        }
        pattern.add(value);
      }
    }

    // P wave: small, wide
    addWave(0, 5, 5);
    // small dip before Q
    addWave(0, -5, 3);
    // Q wave: small dip
    addWave(0, -10, 2);
    // R wave: tall spike
    addWave(0, 50, 3);
    // S wave: dip
    addWave(0, -15, 2);
    // Back to baseline
    addWave(0, 0, 2);
    // T wave: medium bump
    addWave(0, 15, 5);
    // Return to baseline
    addWave(0, 0, 3);

    return pattern;
  }

  String _getStatus(int bpm) {
    if (bpm < 50) return "⚠️ Low Pulse (Risk of Fainting)";
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
    _subscription?.cancel();
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
          child: CustomPaint(painter: HeartbeatPainter(points: points, dx: 2)),
        ),
        const SizedBox(height: 8),
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
      ],
    );
  }
}
