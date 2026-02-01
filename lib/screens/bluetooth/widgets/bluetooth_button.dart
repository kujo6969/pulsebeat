import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import 'device_list_dialog.dart';

class BluetoothButton extends StatefulWidget {
  const BluetoothButton({super.key});

  @override
  State<BluetoothButton> createState() => _BluetoothButtonState();
}

class _BluetoothButtonState extends State<BluetoothButton> {
  bool _connecting = false;

  @override
  Widget build(BuildContext context) {
    return AvatarGlow(
      animate: !_connecting,
      // glowColor: Theme.of(context).colorScheme.tertiary,
      glowColor: Colors.white,
      glowShape: BoxShape.circle,
      child: SizedBox(
        height: 150,
        width: 150,
        child: FloatingActionButton(
          elevation: 10.0,
          shape: const CircleBorder(),
          backgroundColor: Colors.white70,
          onPressed: _connecting ? null : _onBluetoothPressed,
          child: Icon(
            Icons.bluetooth,
            size: 30,
            color: Theme.of(context).colorScheme.secondary,

          ),
        ),
      ),
    );
  }

  Future<void> _onBluetoothPressed() async {
    setState(() => _connecting = true);

    final BluetoothDevice? device = await showDialog<BluetoothDevice>(
      context: context,
      builder: (_) => const DeviceListDialog(),
    );

    if (device != null) {
      try {
        await device.connect(license: License.free);
        debugPrint('Connected to ${device.remoteId}');
      } catch (e) {
        debugPrint('Connection failed: $e');
      }
    }

    if (mounted) {
      setState(() => _connecting = false);
    }
  }
}
