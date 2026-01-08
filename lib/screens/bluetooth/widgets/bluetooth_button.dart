import 'dart:async';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BluetoothButton extends StatefulWidget {
  const BluetoothButton({super.key});

  @override
  State<BluetoothButton> createState() => _BluetoothButtonState();
}

class _BluetoothButtonState extends State<BluetoothButton> {
  BluetoothAdapterState _adapterState = BluetoothAdapterState.unknown;

  late StreamSubscription<BluetoothAdapterState> _adapterStateStateSubscription;

  @override
  void initState() {
    super.initState();
    _adapterStateStateSubscription = FlutterBluePlus.adapterState.listen((
      state,
    ) {
      _adapterState = state;
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _adapterStateStateSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(_adapterState);

    return AvatarGlow(
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
    );
    // return FloatingActionButton(
    //   onPressed: () {},
    //   elevation: 10.0,
    //   shape: CircleBorder(),
    //   child: Icon(Icons.bluetooth_connected, size: 30),
    // );
  }
}
