import 'package:flutter/material.dart';
import 'package:testing3/screens/bluetooth/bluetooth_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("PulseBeat", style: TextStyle(color: Colors.white)),
        backgroundColor: Theme.of(context).colorScheme.tertiary,
      ),
      body: Container(
        color: Theme.of(context).colorScheme.primary,
        child: Center(
          child: Column(
            mainAxisAlignment: .center,
            children: [BluetoothScreen()],
          ),
        ),
      ),
    );
  }
}
