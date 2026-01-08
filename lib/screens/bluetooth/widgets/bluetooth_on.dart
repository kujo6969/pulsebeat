import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:testing3/providers/connection_provider.dart';

class BluetoothOn extends ConsumerWidget {
  const BluetoothOn({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(isConnected);

    return Column(
      children: [
        AvatarGlow(
          animate: true,
          repeat: true,
          glowColor: Theme.of(context).colorScheme.tertiary,
          glowShape: BoxShape.circle,
          curve: Curves.fastOutSlowIn,
          child: FloatingActionButton(
            onPressed: () {},
            elevation: 10.0,
            shape: CircleBorder(),
            backgroundColor: Theme.of(context).colorScheme.tertiary,
            child: Icon(
              Icons.bluetooth_connected,
              size: 30,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: Text(
            status ? "Connected" : "Not connected",
            style: TextStyle(
              fontSize: 24,
              color: status ? Colors.blue : Colors.redAccent,
            ),
          ),
        ),
      ],
    );
  }
}
