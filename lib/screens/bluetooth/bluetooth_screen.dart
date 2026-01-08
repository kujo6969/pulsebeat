import 'package:flutter/material.dart';
import 'package:testing3/screens/bluetooth/widgets/bluetooth_off.dart';
import 'package:testing3/screens/bluetooth/widgets/bluetooth_on.dart';

class BluetoothScreen extends StatefulWidget {
  const BluetoothScreen({super.key});

  @override
  State<BluetoothScreen> createState() => _BluetoothScreenState();
}

class _BluetoothScreenState extends State<BluetoothScreen> {
  @override
  Widget build(BuildContext context) {
    return BluetoothOn();
  }
}
