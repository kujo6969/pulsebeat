import 'package:flutter/material.dart';
import 'package:testing3/screens/bluetooth/bluetooth_screen.dart';
import 'package:testing3/screens/history/history_screen.dart';
import 'package:testing3/screens/pulse_monitoring/pulse_monitoring_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  late final List<Widget> _pages = [
    BluetoothScreen(),
    PulseMonitoringScreen(),
    HistoryScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PulseBeat", style: TextStyle(color: Colors.white)),
        backgroundColor: Theme.of(context).colorScheme.tertiary,
      ),

      body: IndexedStack(index: _currentIndex, children: _pages),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: Theme.of(context).colorScheme.tertiary,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.bluetooth),
            label: 'Bluetooth',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Pulse'),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
        ],
      ),
    );
  }
}
