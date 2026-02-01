import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:testing3/providers/bluetooth_provider.dart';
import 'package:testing3/screens/bluetooth/widgets/bluetooth_button.dart';
import 'package:testing3/screens/bluetooth/widgets/bluetooth_off.dart';

class BluetoothScreen extends StatefulWidget {
  const BluetoothScreen({super.key});

  @override
  State<BluetoothScreen> createState() => _BluetoothScreenState();
}

class _BluetoothScreenState extends State<BluetoothScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final isConnected = ref.watch(isConnectedProvider);
        final connected = ref.watch(connectedTo);
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              isConnected ? BluetoothOff() : BluetoothButton(),
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text(
                  isConnected ? connected : "No connected device",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 24,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
