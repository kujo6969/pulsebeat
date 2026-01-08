import 'package:flutter/material.dart';

class BluetoothOff extends StatelessWidget {
  const BluetoothOff({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 150,
          width: 150,
          child: FloatingActionButton(
            onPressed: null,
            elevation: 10.0,
            shape: CircleBorder(),
            backgroundColor: Theme.of(context).colorScheme.secondary,
            child: Icon(
              Icons.bluetooth_disabled,
              size: 30,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: Text(
            "Turn on your bluetooth",
            style: TextStyle(fontSize: 24, color: Colors.blueAccent),
          ),
        ),
      ],
    );
  }
}
