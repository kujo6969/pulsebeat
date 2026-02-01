import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:testing3/providers/bluetooth_provider.dart';

class BluetoothOff extends ConsumerWidget {
  const BluetoothOff({super.key});

  Future<void> _confirmDisconnect(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Disconnect Bluetooth'),
        content: const Text(
          'Are you sure you want to disconnect from the current device?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Disconnect'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      ref.read(bluetoothProvider.notifier).disconnected();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        SizedBox(
          height: 150,
          width: 150,
          child: FloatingActionButton(
            elevation: 10.0,
            shape: const CircleBorder(),
            backgroundColor: Theme.of(context).colorScheme.tertiary,
            onPressed: () => _confirmDisconnect(context, ref),
            child: Icon(
              Icons.bluetooth_disabled,
              size: 30,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ),
      ],
    );
  }
}
