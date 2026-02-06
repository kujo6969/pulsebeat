import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:testing3/providers/bluetooth_provider.dart';
import 'package:testing3/screens/pulse_monitoring/widgets/heartbeat_monitoring_widget.dart';

class PulseMonitoringScreen extends StatefulWidget {
  const PulseMonitoringScreen({super.key});

  @override
  State<PulseMonitoringScreen> createState() => PulseMonitoringScreenState();
}

class PulseMonitoringScreenState extends State<PulseMonitoringScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final connected = ref.watch(isConnectedProvider);
        final device = ref.watch(connectedDeviceProvider);
        return connected
            ? HeartbeatMonitoringWidget(device: device!)
            : Center(
                child: Text(
                  'Please connect to a device first.',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 22,
                  ),
                ),
              );
      },
    );
  }
}
